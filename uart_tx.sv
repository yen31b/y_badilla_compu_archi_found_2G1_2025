module uart_tx (
    input  logic clk,        // Reloj de 50 MHz
    input  logic reset,
    input  logic start,      // Señal para iniciar la transmisión
    input  logic [7:0] data, // Byte a transmitir (puedes usar [3:0] y extender)
    output logic tx,         // Línea TX a la FPGA (va al RX de la FPGA)
    output logic busy        // Indica que está transmitiendo
);

    localparam CLKS_PER_BIT = 5208; // 50_000_000 / 9600
    typedef enum logic [1:0] {IDLE, START, DATA, STOP} state_t;
    state_t state;

    logic [12:0] clk_count;
    logic [2:0] bit_index;
    logic [7:0] tx_shift;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            clk_count <= 0;
            bit_index <= 0;
            tx_shift <= 8'hFF;
            tx <= 1;
            busy <= 0;
        end else begin
            case (state)
                IDLE: begin
                    tx <= 1;
                    busy <= 0;
                    if (start) begin
                        state <= START;
                        tx_shift <= data;
                        clk_count <= 0;
                        busy <= 1;
                    end
                end

                START: begin
                    tx <= 0; // Bit de inicio
                    if (clk_count == CLKS_PER_BIT - 1) begin
                        clk_count <= 0;
                        state <= DATA;
                        bit_index <= 0;
                    end else begin
                        clk_count <= clk_count + 1;
                    end
                end

                DATA: begin
                    tx <= tx_shift[bit_index];
                    if (clk_count == CLKS_PER_BIT - 1) begin
                        clk_count <= 0;
                        if (bit_index == 7)
                            state <= STOP;
                        else
                            bit_index <= bit_index + 1;
                    end else begin
                        clk_count <= clk_count + 1;
                    end
                end

                STOP: begin
                    tx <= 1; // Bit de parada
                    if (clk_count == CLKS_PER_BIT - 1) begin
                        state <= IDLE;
                        clk_count <= 0;
                        busy <= 0;
                    end else begin
                        clk_count <= clk_count + 1;
                    end
                end
            endcase
        end
    end
endmodule