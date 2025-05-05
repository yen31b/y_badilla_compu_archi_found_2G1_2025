`timescale 1ns/1ps

module tb_Tarea1;

    logic clk;
    logic reset;
    logic enable;
    logic [3:0] sensores;
    logic [1:0] cod_out;
    logic [1:0] sum_out;
    logic [6:0] segmentos;
    logic led0, led1, led2, led3;
    logic motor_on;

    // DUT (Device Under Test)
    Tarea1 dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .sensores(sensores),
        .cod_out(cod_out),
        .sum_out(sum_out),
        .segmentos(segmentos),
        .led0(led0),
        .led1(led1),
        .led2(led2),
        .led3(led3),
        .motor_on(motor_on)
    );

    // Clock
    initial clk = 0;
    always #5 clk = ~clk;

    // Estímulo
    initial begin
	     #5; // Delay mínimo para evitar valores x iniciales
				$display("Time | sensores | cod_out | sum_out | C_D | motor | LEDs | 7 segmentos | enable | suma | acumulado");
				$monitor("%4t | %b |   %b    |   %b     | %b  |   %b   | %b%b%b%b |   %b%b%b%b%b%b%b |   %b | suma=%0d | acumulado=%0d",
							$time,
							sensores,
							cod_out,
							sum_out,
							dut.C_D,
							motor_on,
							dut.led3, dut.led2, dut.led1, dut.led0,
							dut.segmentos[6], dut.segmentos[5], dut.segmentos[4],
							dut.segmentos[3], dut.segmentos[2], dut.segmentos[1], dut.segmentos[0],
							enable,
							sum_out, dut.C_D);
        // Inicialización
				reset = 1; enable = 0; sensores = 4'b0000;
				#5;
				@(posedge clk);  // aplicar reset en flanco de subida
				reset = 0;

        // Probar las 16 combinaciones
        for (int i = 0; i < 16; i++) begin
            sensores = i[3:0];   // Conversión automática a 4 bits
            enable = 1; #10;
            enable = 0; #10;
        end

        $finish;
    end

endmodule
