module registro_param #(parameter N = 8)(
    input  logic clk,
    input  logic [N-1:0] d,
    input  logic en,
    output logic [N-1:0] q
);
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : regbits
            dff_estructural dff_inst (
                .clk(clk),
                .rst(1'b0),
                .en(en),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule