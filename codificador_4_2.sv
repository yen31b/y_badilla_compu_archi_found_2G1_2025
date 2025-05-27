module codificador_4_2 (
    input  logic A, B, C, D, 
    output logic S1, S0
);

    // S1 = C OR D
    or OR1 (S1, C, D);

    // S0 = B OR D
    or OR2 (S0, B, D);

endmodule