`timescale 1ns/1ps

module uart_top_tb;

    // Señales del testbench
    reg clk;
    reg rst;
    reg tick;
    reg rxd;
    wire txd;
    wire [7:0] data_out;
    wire data_ready;

    // Instancia del DUT (Device Under Test)
    UART_top dut (
        .clk(clk),
        .rst(rst),
        .tick(tick),
        .rxd(rxd),
        .txd(txd),
        .data_out(data_out),
        .data_ready(data_ready)
    );

    // Generador de reloj: 100 MHz
    initial clk = 0;
    always #5 clk = ~clk;

    // Generador de tick (puede ser la señal de baudrate, aquí cada 160ns aprox)
    initial tick = 0;
    always #80 tick = ~tick;

    // Simulación de envío de un byte por línea RXD (formato UART: start(0), 8 bits, stop(1))
    task send_uart_byte;
        input [7:0] data;
        integer i;
        begin
            // Start bit
            rxd = 0;
            repeat(16) @(posedge tick);
            // Bits de datos (LSB primero)
            for (i = 0; i < 8; i = i + 1) begin
                rxd = data[i];
                repeat(16) @(posedge tick);
            end
            // Stop bit
            rxd = 1;
            repeat(16) @(posedge tick);
        end
    endtask

    // Proceso principal de prueba
    initial begin
        // Inicialización
        rxd = 1;
        rst = 1;
        @(posedge clk);
        rst = 0;

        // Espera un poco antes del envío
        repeat(10) @(posedge clk);

        // Envía el byte 0xA5 por la UART (rxd)
        $display("Enviando 0xA5 por RXD...");
        send_uart_byte(8'hA5);

        // Espera hasta que data_ready esté en alto
        wait(data_ready == 1);
        $display("Dato recibido: %h", data_out);

        // Espera unos ciclos extra para observar el eco por TXD
        repeat(100) @(posedge clk);

        // Finaliza simulación
        $display("Fin de la simulación.");
        $finish;
    end

endmodule