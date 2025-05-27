module negador4(
    input  logic [3:0] in,
    output logic [3:0] out
);
    assign out = ~in;
endmodule