// ==========================
// Módulo sumador estructural
// ==========================

module Tarea1 (
    input  logic clk,
    input  logic reset,
    input  logic enable,
    input  logic [3:0] sensores,
    output logic [1:0] cod_out,
    output logic [1:0] sum_out,
    output logic [6:0] segmentos,
    output logic led0, led1, led2, led3,
    output logic motor_on
);

    logic [1:0] C_D;              // Registro que se actualiza (representa C y D)
    logic [1:0] suma_result;
    logic [1:0] entrada_bin;            // Lo que va al acumulador


	 
    // Codificador
		codificador_4_2 codificador_inst (
			 .A(sensores[3]),
			 .B(sensores[2]),
			 .C(sensores[1]),
			 .D(sensores[0]),
			 .S1(entrada_bin[1]),
			 .S0(entrada_bin[0])
		);

    // Sumador
    sumador acumulador_inst (
        .A(entrada_bin[1]),
        .B(entrada_bin[0]),
        .C(C_D[1]),
        .D(C_D[0]),
        .S1(suma_result[1]),
        .S0(suma_result[0])
    );

    // Registro para almacenar resultado de suma
    FlipFlop registro_inst (
        .clk(clk),
        .reset(reset),
        .enable(enable),              // Pulsador
        .data_in(suma_result),
        .data_out(C_D)                // Actualiza C y D
    );


	 
	     // Decodificador que activa el motor en 01 y 11
				decodificador_motor dec2 (
					 .C(C_D[1]),
					 .D(C_D[0]),
					 .motor_on(motor_on)
				);
			
			
			
			//Instancia Modulo 7 segmentos 		
			 // Display de 7 segmentos
			 decodificador_7seg display (
				  .valor(C_D),
				  .segmentos(segmentos)
			 );
			
			visualizador_led vis_led (
				 .valor(C_D),
				 .led0(led0),
				 .led1(led1),
				 .led2(led2),
				 .led3(led3)
			);
	 assign cod_out = entrada_bin;
    assign sum_out = suma_result;


			
endmodule





