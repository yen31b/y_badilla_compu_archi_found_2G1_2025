module ALU (
  input  logic [3:0] A, B,
  input  logic [1:0] OP,     // 00: Multiplicación, 01: Resta, 10: AND, 11: XOR
  output logic [7:0] R,      // Resultado extendido para multiplicación (4x4)
  output logic Z, N, C, V    // Banderas: Zero, Negativo, Carry, Overflow
);

  logic [7:0] mult_out;  // Salida de multiplicación (8 bits)
  logic [3:0] sub_out, and_out, xor_out;  // Salidas para resta, AND y XOR
  logic [3:0] alu_result;  // Resultado final de la ALU

  logic c_out_sub, v_out_sub;  // Banderas de acarreo y desbordamiento para la resta

  // Módulos individuales
  multiplier mult (A, B, mult_out);
  restador rest (A, B, sub_out, c_out_sub, v_out_sub);
  assign and_out = A & B;
  assign xor_out = A ^ B;

  // Selección del resultado principal (usando compuertas)
  assign alu_result[0] = (~OP[1] & ~OP[0] & mult_out[0]) |
                         (~OP[1] &  OP[0] & sub_out[0])   |
                         ( OP[1] & ~OP[0] & and_out[0])   |
                         ( OP[1] &  OP[0] & xor_out[0]);

  assign alu_result[1] = (~OP[1] & ~OP[0] & mult_out[1]) |
                         (~OP[1] &  OP[0] & sub_out[1])   |
                         ( OP[1] & ~OP[0] & and_out[1])   |
                         ( OP[1] &  OP[0] & xor_out[1]);

  assign alu_result[2] = (~OP[1] & ~OP[0] & mult_out[2]) |
                         (~OP[1] &  OP[0] & sub_out[2])   |
                         ( OP[1] & ~OP[0] & and_out[2])   |
                         ( OP[1] &  OP[0] & xor_out[2]);

  assign alu_result[3] = (~OP[1] & ~OP[0] & mult_out[3]) |
                         (~OP[1] &  OP[0] & sub_out[3])   |
                         ( OP[1] & ~OP[0] & and_out[3])   |
                         ( OP[1] &  OP[0] & xor_out[3]);

  // Selección de R 
  assign R = ({8{~OP[1] & ~OP[0]}} & mult_out) |
             ({8{OP[1] | OP[0]}} & {4'b0000, alu_result});

  // Flags
  assign Z = ((~OP[1] & ~OP[0]) & ~|mult_out) |
             ((OP[1] | OP[0]) & ~|alu_result);

  assign N = ((~OP[1] & ~OP[0]) & mult_out[7]) |
             ((OP[1] | OP[0]) & alu_result[3]);

  assign C = ((~OP[1] & OP[0]) & c_out_sub); 
  assign V = ((~OP[1] & OP[0]) & v_out_sub); 

endmodule
