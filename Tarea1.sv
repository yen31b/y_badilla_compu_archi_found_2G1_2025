// ==========================
// Módulo sumador estructural
// ==========================

module Tarea1 (
    input  logic clk, reset,
    input  logic enable,          // Pulsador (controla la carga)
    input  logic A, B,
    output logic [1:0] cod_out,   // Salida del codificador
    output logic [1:0] sum_out    // Salida del sumador (por si se quiere monitorear)
);

    logic [1:0] C_D;              // Registro que se actualiza (representa C y D)
    logic [1:0] suma_result;

    // Codificador
    codificador_4_2 codificador_inst (
        .A(A),
        .B(B),
        .C(C_D[1]),
        .D(C_D[0]),
        .S1(cod_out[1]),
        .S0(cod_out[0])
    );

    // Sumador
    sumador sumador_inst (
        .A(A),
        .B(B),
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

    // Exponer resultado del sumador si se quiere observar
    assign sum_out = suma_result;

endmodule





