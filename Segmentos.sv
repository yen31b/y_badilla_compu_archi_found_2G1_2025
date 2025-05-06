module Segmentos (
    input logic A, B,
    output logic a, b, c, d, e, f, g
);

    // Señales intermedias
    logic A_negado, B_negado;

    // Negaciones necesarias
    assign A_negado = ~A;  // A negado
    assign B_negado = ~B;  // B negado

    // Segmento a: B * A'
    assign a = B & A_negado;

    // Segmento b: 0
    assign b = 0;

    // Segmento c: A * B'
    assign c = A & B_negado;

    // Segmento d: A + B
    assign d = A | B;

    // Segmento e: B
    assign e = B;

    // Segmento f: A + B
    assign f = A | B;

    // Segmento g: A'
    assign g = A_negado;

endmodule