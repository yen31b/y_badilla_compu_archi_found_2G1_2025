module and4_flags(
    input  logic [3:0] a,
    input  logic [3:0] b,
    output logic [3:0] result,
    output logic       zero,
    output logic       negative,
    output logic       carry,
    output logic       overflow
);
    assign result   = a & b;
    assign zero     = (result == 4'b0000);
    assign negative = result[3];
    assign carry    = 1'b0;
    assign overflow = 1'b0;
endmodule