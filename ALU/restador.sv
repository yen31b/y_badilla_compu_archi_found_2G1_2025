module restador (
  input  logic [3:0] A, B,
  output logic [3:0] R,
  output logic C, V
);

  logic [3:0] notB, sum;
  logic c1, c2, c3, c4;

  // Complemento a dos: A - B = A + (~B + 1)
  assign notB = ~B;

  // Suma A + (~B) + 1 usando sumadores completos
  full_adder FA0 (A[0], notB[0], 1'b1, sum[0], c1);
  full_adder FA1 (A[1], notB[1], c1,   sum[1], c2);
  full_adder FA2 (A[2], notB[2], c2,   sum[2], c3);
  full_adder FA3 (A[3], notB[3], c3,   sum[3], c4);

  assign R = sum;

  // C = 1 indica que hubo un préstamo en la resta
  assign C = ~c4;

  // V = 1 si hay overflow de signo (complemento a dos)
  assign V = (A[3] & ~B[3] & ~sum[3]) | (~A[3] & B[3] & sum[3]);

endmodule
