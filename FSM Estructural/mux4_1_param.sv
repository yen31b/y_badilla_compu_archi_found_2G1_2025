// Mux 4 a 1 parametrizable
module mux4to1_param #(
    parameter N = 8
)(
    input  logic [N-1:0] a,
    input  logic [N-1:0] b,
    input  logic [N-1:0] c,
    input  logic [N-1:0] d,
    input  logic [1:0]   select,
    output logic [N-1:0] y
);
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : mux_bits
            assign y[i] = (a[i] & ~select[1] & ~select[0]) |
                          (b[i] & ~select[1] &  select[0]) |
                          (c[i] &  select[1] & ~select[0]) |
                          (d[i] &  select[1] &  select[0]);
        end
    endgenerate
endmodule