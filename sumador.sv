module sumador (
    input  logic A, B, C, D,
    output logic S1, S0
);

    logic temp1, temp2, and1;

    // S0 = B ⊕ D
    xor XOR1 (S0, B, D);

    // temp1 = A ⊕ C
    xor XOR2 (temp1, A, C);

    // and1 = B ∧ D
    and AND1 (and1, B, D);

    // S1 = temp1 ⊕ and1
    xor XOR3 (S1, temp1, and1);

endmodule
