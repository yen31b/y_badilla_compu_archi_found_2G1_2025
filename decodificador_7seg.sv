module decodificador_7seg (
    input  logic [1:0] valor,     // C_D (2 bits)
    output logic [6:0] segmentos  // a, b, c, d, e, f, g
);
    logic zero, one, two, three;

    // Detectar valores específicos
    assign zero  = ~valor[1] & ~valor[0];
    assign one   = ~valor[1] &  valor[0];
    assign two   =  valor[1] & ~valor[0];
    assign three =  valor[1] &  valor[0];

    // Segmentos activos bajos (0 = encendido, 1 = apagado), si es anodo común inviertes
    assign segmentos[0] = ~(zero | two | three);          // a
    assign segmentos[1] = ~(one | two | three);           // b
    assign segmentos[2] = ~(zero | one | three);          // c
    assign segmentos[3] = ~(zero | two | three);          // d
    assign segmentos[4] = ~(zero | two);                  // e
    assign segmentos[5] = ~(zero | one | three);          // f
    assign segmentos[6] = ~(two | three);                 // g
endmodule
