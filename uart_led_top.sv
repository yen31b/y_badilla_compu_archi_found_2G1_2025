module uart_led_top (
    input  logic clk,       // 50 MHz
    input  logic reset,
    input  logic uart_rx,   // RX desde Arduino TX
    input  logic cs,        // Chip Select desde Arduino
    output logic [4:0] led  // 5 LEDs en la FPGA
);

    logic [3:0] rx_data;
    logic rx_done;

    // Instancia del módulo UART receptor
    uart_rx uart_inst (
        .clk(clk),
        .reset(reset),
        .rx(uart_rx),
        .cs(cs),             // Conectar CS al módulo UART
        .data(rx_data),
        .done(rx_done)
    );

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            led <= 5'b00000;
        end else begin
            // Mostrar el estado del CS en el LED 4
            led[4] <= cs;

            // Actualizar los LEDs con los datos recibidos solo si el CS está bajo
            if (rx_done && !cs)  
                led[3:0] <= rx_data;
        end
    end
endmodule
