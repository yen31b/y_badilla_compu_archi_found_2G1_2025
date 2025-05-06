// ==========================
// Módulo sumador estructural
// ==========================

module Tarea1 (
    input  logic clk, reset,
    input  logic enable,          // Pulsador (controla la carga)
    input  logic A, B,C,D,
	 input  logic clk_btn, // Botón de FPGA que actúa como reloj
    output logic [1:0] cod_out,   // Salida del codificador
    output logic [1:0] sum_out,    // Salida del sumador (por si se quiere monitorear)
	 output logic [1:0] C_D,    // Salida del ff (por si se quiere monitorear)
	 output logic a, b, c, d, e, f, g,
	 output logic motor_on
);

    logic [1:0] suma_result;
	 logic [1:0] data_out;

    // Codificador
    codificador_4_2 codificador_inst (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .S1(cod_out[1]),
        .S0(cod_out[0])
    );

    // Sumador
    sumador sumador_inst (
        .A(cod_out[1]),
        .B(cod_out[0]),
        .C(data_out[1]),
        .D(data_out[0]),
        .S1(suma_result[1]),
        .S0(suma_result[0])
    );

    // Registro para almacenar resultado de suma
    FlipFlop registro_inst (
        .clk_btn(clk_btn), 
		  .reset(reset),
        .data_in(suma_result), 
        .data_out(data_out)
    );

    // Exponer resultado del sumador si se quiere observar
    assign sum_out = suma_result;
	 
	 // Decodificador que activa el motor en 01 y 11
		decodificador_motor motor_inst (
			.C(data_out[1]),
			.D(data_out[0]),
			.motor_on(motor_on)
		);
	 
	 // Instancia del display de 7 segmentos
    Segmentos display (
        .A(data_out[1]), 
        .B(data_out[0]), 
        .a(a), 
        .b(b), 
        .c(c), 
        .d(d), 
        .e(e), 
        .f(f), 
        .g(g)
    );

endmodule






