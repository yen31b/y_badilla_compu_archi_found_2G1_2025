module uart_rx (
    input  logic clk,       // 50 MHz
    input  logic reset,
    input  logic rx,        // desde Arduino (TX)
    input  logic cs,        // Chip Select desde Arduino
    output logic [3:0] data, // datos recibidos
    output logic done       // 1 cuando se recibió un byte
);

    localparam CLKS_PER_BIT = 5208; // 50_000_000 / 9600
    typedef enum logic [1:0] {IDLE, START, DATA, STOP} state_t;
    state_t state;

    logic [12:0] clk_count;
    logic [2:0] bit_index;
    logic [7:0] rx_shift;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            clk_count <= 0;
            bit_index <= 0;
            rx_shift <= 0;
            done <= 0;
            data <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    // Solo iniciar recepción si CS está bajo
                    if (rx == 0 && !cs) begin
                        state <= START;
                        clk_count <= 0;
                    end
                end

                START: begin
                    if (clk_count == (CLKS_PER_BIT / 2)) begin
                        state <= DATA;
                        clk_count <= 0;
                        bit_index <= 0;
                    end else begin
                        clk_count <= clk_count + 1;
                    end
                end

                DATA: begin
                    if (clk_count == CLKS_PER_BIT - 1) begin
                        clk_count <= 0;
                        rx_shift[bit_index] <= rx;
                        if (bit_index == 7) begin
                            state <= STOP;
                        end else begin
                            bit_index <= bit_index + 1;
                        end
                    end else begin
                        clk_count <= clk_count + 1;
                    end
                end

                STOP: begin
                    if (clk_count == CLKS_PER_BIT - 1) begin
                        done <= 1;
                        data <= rx_shift[3:0]; // solo queremos los 4 LSB
                        state <= IDLE;
                    end else begin
                        clk_count <= clk_count + 1;
                    end
                end
            endcase
        end
    end
endmodule
