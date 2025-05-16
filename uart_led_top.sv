module uart_led_top (
    input  logic clk,       // 50 MHz
    input  logic reset,
    input  logic uart_rx,   // RX desde Arduino TX
    output logic [3:0] led  // LEDs en la FPGA
);

    logic [3:0] rx_data;
    logic rx_done;

    uart_rx uart_inst (
        .clk(clk),
        .reset(reset),
        .rx(uart_rx),
        .data(rx_data),
        .done(rx_done)
    );

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            led <= 4'b0000;
        else if (rx_done)
            led <= rx_data;
    end
endmodule
