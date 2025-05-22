module uart_led_top (
    input  logic clk,       // 50 MHz
    input  logic reset,
    input  logic uart_rx,   // RX desde Arduino TX
    input  logic cs,        // Chip Select desde Arduino
    output logic uart_tx,   // TX hacia Arduino (va al RX del Arduino)
    output logic [4:0] led  // 5 LEDs en la FPGA
);

    logic [3:0] rx_data;
    logic rx_done;

    // Señales para transmisión
    logic [7:0] tx_data;
    logic tx_start;
    logic tx_busy;

    // Instancia del UART receptor
    uart_rx uart_inst (
        .clk(clk),
        .reset(reset),
        .rx(uart_rx),
        .cs(cs),
        .data(rx_data),
        .done(rx_done)
    );

    // Instancia del UART transmisor
    uart_tx uart_tx_inst (
        .clk(clk),
        .reset(reset),
        .start(tx_start),
        .data(tx_data),
        .tx(uart_tx),
        .busy(tx_busy)
    );

    // FSM simple para enviar respuesta
    typedef enum logic [1:0] {WAIT_RX, SEND_ACK, WAIT_BUSY} tx_state_t;
    tx_state_t tx_state;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            led <= 5'b00000;
            tx_data <= 8'h00;
            tx_start <= 0;
            tx_state <= WAIT_RX;
        end else begin
            led[4] <= cs;

            case (tx_state)
                WAIT_RX: begin
                    if (rx_done && !cs) begin
                        led[3:0] <= rx_data;
                        tx_data <= {4'b1010, rx_data}; // Ejemplo: Ack + dato recibido
                        tx_start <= 1;
                        tx_state <= SEND_ACK;
                    end
                end

                SEND_ACK: begin
                    // Solo bajar el start una vez lo activaste
                    tx_start <= 0;
                    if (tx_busy)
                        tx_state <= WAIT_BUSY;
                end

                WAIT_BUSY: begin
                    if (!tx_busy)
                        tx_state <= WAIT_RX;
                end
            endcase
        end
    end

endmodule


