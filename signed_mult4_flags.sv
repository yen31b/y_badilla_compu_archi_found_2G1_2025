module signed_mult4_flags(
    input  logic [3:0] a,
    input  logic [3:0] b,
    output logic [7:0] result,
    output logic       zero,
    output logic       negative,
    output logic       carry,
    output logic       overflow
);
    // Señales intermedias
    logic [3:0] abs_a, abs_b;
    logic [7:0] unsigned_result, neg_result, final_result;
    logic sign_a, sign_b, result_sign;

    // Detectar signo
    assign sign_a = a[3];
    assign sign_b = b[3];
    assign result_sign = sign_a ^ sign_b; // XOR para el signo del resultado

    // Valor absoluto de a
    logic [3:0] not_a, not_b;
    logic [3:0] abs_a_tmp, abs_b_tmp;
    logic dummy_cout_a, dummy_cout_b;
    negador4 neg_a(.in(a), .out(not_a));
    adder4 add_a(.a(not_a), .b(4'b0001), .cin(1'b0), .sum(abs_a_tmp), .cout(dummy_cout_a));
    assign abs_a = sign_a ? abs_a_tmp : a;

    // Valor absoluto de b
    negador4 neg_b(.in(b), .out(not_b));
    adder4 add_b(.a(not_b), .b(4'b0001), .cin(1'b0), .sum(abs_b_tmp), .cout(dummy_cout_b));
    assign abs_b = sign_b ? abs_b_tmp : b;

    // Multiplicación unsigned estructural
    multiplier_unsigned4 mul_unsigned(.a(abs_a), .b(abs_b), .result(unsigned_result));

    // Si el resultado debe ser negativo, sacar complemento a dos (8 bits)
    negador8 neg_r(.in(unsigned_result), .out(neg_result));
    logic [7:0] final_result_tmp;
    logic dummy_cout_r;
    adder8 add_r(.a(neg_result), .b(8'b00000001), .cin(1'b0), .sum(final_result_tmp), .cout(dummy_cout_r));

    assign final_result = result_sign ? final_result_tmp : unsigned_result;
    assign result = final_result;

    // FLAGS
    assign zero     = (final_result == 8'b0);
    assign negative = final_result[7]; // MSB del resultado 8 bits

    // Carry y Overflow:
    // Carry: si algún bit más allá de 7..4 no coincide con el signo (saturación), o si el resultado no cabe en 4 bits signed.
    // Overflow: para multiplicación signed de 4x4, ocurre si los bits 7..4 no son extensión de signo de bit 3.
    assign carry = |(final_result[7:4] != {4{final_result[3]}});

    // Overflow: en mult signed, es 1 si los bits 7..4 no son iguales a la extensión de signo de bit 3 (resultado esperado para 4 bits signed)
    assign overflow = ~(&({final_result[7],final_result[6],final_result[5],final_result[4]} == {4{final_result[3]}}));

endmodule