module negador8(
    input  logic [7:0] in,
    output logic [7:0] out
);
    assign out = ~in;
endmodule