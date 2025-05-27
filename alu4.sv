module alu4(
    input  logic [3:0] a,
    input  logic [3:0] b,
    input  logic [1:0] opcode, // 00: mult, 01: and, 10: xor, 11: sub
    output logic [7:0] result,
    output logic       zero,
    output logic       negative,
    output logic       carry,
    output logic       overflow,
	 output logic [6:0] segments
);
    // Señales intermedias para cada operación
    logic [7:0] mult_result;
    logic       mult_zero, mult_negative, mult_carry, mult_overflow;

    logic [3:0] and_result;
    logic       and_zero, and_negative, and_carry, and_overflow;

    logic [3:0] xor_result;
    logic       xor_zero, xor_negative, xor_carry, xor_overflow;

    logic [3:0] sub_result;
    logic       sub_zero, sub_negative, sub_carry, sub_overflow;

    // Instancias de módulos
    signed_mult4_flags mult_mod(
        .a(a),
        .b(b),
        .result(mult_result),
        .zero(mult_zero),
        .negative(mult_negative),
        .carry(mult_carry),
        .overflow(mult_overflow)
    );

    and4_flags and_mod(
        .a(a),
        .b(b),
        .result(and_result),
        .zero(and_zero),
        .negative(and_negative),
        .carry(and_carry),
        .overflow(and_overflow)
    );

    xor4_flags xor_mod(
        .a(a),
        .b(b),
        .result(xor_result),
        .zero(xor_zero),
        .negative(xor_negative),
        .carry(xor_carry),
        .overflow(xor_overflow)
    );

    sub4_flags sub_mod(
        .a(a),
        .b(b),
        .result(sub_result),
        .zero(sub_zero),
        .negative(sub_negative),
        .carry(sub_carry),
        .overflow(sub_overflow)
    );
	 
	 sevenSegmentsDisplay sevenSegD( .A(result[3]),
	.B(result[2]),
	.C(result[1]),
	.D(result[0]),
	.segments(segments));

    // MUX select signals
    logic sel0, sel1, sel2, sel3;
    // opcode: 00, 01, 10, 11
    assign sel0 = ~opcode[1] & ~opcode[0]; // 00
    assign sel1 = ~opcode[1] &  opcode[0]; // 01
    assign sel2 =  opcode[1] & ~opcode[0]; // 10
    assign sel3 =  opcode[1] &  opcode[0]; // 11

    // Resultado de 8 bits
    assign result =
        ({8{sel0}} & mult_result) |
        ({8{sel1}} & {4'b0000, and_result}) |
        ({8{sel2}} & {4'b0000, xor_result}) |
        ({8{sel3}} & {4'b0000, sub_result});

    // Flags, multiplexados estructuralmente
    assign zero =
        (sel0 & mult_zero)     |
        (sel1 & and_zero)      |
        (sel2 & xor_zero)      |
        (sel3 & sub_zero);

    assign negative =
        (sel0 & mult_negative) |
        (sel1 & and_negative)  |
        (sel2 & xor_negative)  |
        (sel3 & sub_negative);

    assign carry =
        (sel0 & mult_carry)    |
        (sel1 & and_carry)     |
        (sel2 & xor_carry)     |
        (sel3 & sub_carry);

    assign overflow =
        (sel0 & mult_overflow) |
        (sel1 & and_overflow)  |
        (sel2 & xor_overflow)  |
        (sel3 & sub_overflow);

endmodule