// Mux 2 a 1 parametrizable
module mux2to1_param #(
    parameter N = 8)
(
    input  logic [N-1:0] a,
    input  logic [N-1:0] b,
    input  logic select,
    output logic [N-1:0] y
);
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : mux_bits
            assign y[i] = (a[i] & ~select) | (b[i] & select);
        end
    endgenerate
endmodule