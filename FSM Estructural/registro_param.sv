module registro_param #(parameter N = 8)(
    input  logic clk,
    input  logic [N-1:0] d,
    input  logic en,
	 input  logic rst, 
    output logic [N-1:0] q
);
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : regbits
            flipflop_d dff_inst (
                .clk(clk),
                .rst(rst),
                .en(en),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule