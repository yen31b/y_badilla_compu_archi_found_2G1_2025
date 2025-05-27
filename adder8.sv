module adder8(
    input  logic [7:0] a,
    input  logic [7:0] b,
    input  logic       cin,
    output logic [7:0] sum,
    output logic       cout
);
    logic [6:0] c;
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : adder_gen
            if (i == 0) begin
                full_adder fa(.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(c[0]));
            end else if (i == 7) begin
                full_adder fa(.a(a[7]), .b(b[7]), .cin(c[6]), .sum(sum[7]), .cout(cout));
            end else begin
                full_adder fa(.a(a[i]), .b(b[i]), .cin(c[i-1]), .sum(sum[i]), .cout(c[i]));
            end
        end
    endgenerate
endmodule