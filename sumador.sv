module sumador (
    input  logic A, B,   // Entrada 1 (AB)
    input  logic C, D,   // Entrada 2 (CD)
    output logic S1, S0  // Salida suma (2 bits)
);
    logic [1:0] in1, in2, sum;

    assign in1 = {A, B};
    assign in2 = {C, D};
    assign sum = in1 + in2;

    assign S1 = sum[1];
    assign S0 = sum[0];
endmodule
