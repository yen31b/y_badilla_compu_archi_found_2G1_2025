module sub4_flags(
    input  logic [3:0] a,
    input  logic [3:0] b,
    output logic [3:0] result,
    output logic       zero,
    output logic       negative,
    output logic       carry,
    output logic       overflow
);
    // Complemento a dos de B
    logic [3:0] not_b;
    logic [3:0] b_comp2;
    logic       cout1, cout2;

    negador4 n1(.in(b), .out(not_b));
    adder4   a1(.a(not_b), .b(4'b0001), .cin(1'b0), .sum(b_comp2), .cout(cout1));

    // Suma A + complemento a dos de B
    adder4   a2(.a(a), .b(b_comp2), .cin(1'b0), .sum(result), .cout(cout2));

    // Flags
    assign zero     = (result == 4'b0000);
    assign negative = result[3];
    assign carry    = ~cout2; // borrow: carry-out de la suma invertido
    assign overflow = (a[3] != b[3]) && (result[3] != a[3]);
endmodule