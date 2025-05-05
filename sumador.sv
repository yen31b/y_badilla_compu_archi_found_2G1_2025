module sumador (
    input  logic A, B, C, D,
    output logic S1, S0
);
    logic [1:0] val1, val2, suma;

    assign val1 = {A, B};
    assign val2 = {C, D};
    assign suma = val1 + val2;

    assign S1 = suma[1];
    assign S0 = suma[0];
endmodule
