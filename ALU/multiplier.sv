module multiplier (
  input  logic [3:0] A, B,
  output logic [7:0] P
);
  logic [3:0] pp0, pp1, pp2, pp3;
  logic [7:0] temp1, temp2, temp3;

  assign pp0 = A & {4{B[0]}};
  assign pp1 = A & {4{B[1]}};
  assign pp2 = A & {4{B[2]}};
  assign pp3 = A & {4{B[3]}};

  assign temp1 = {4'b0000, pp0};
  assign temp2 = {3'b000, pp1, 1'b0};
  assign temp3 = {2'b00, pp2, 2'b00};
  assign P     = {1'b0, pp3, 3'b000} + temp3 + temp2 + temp1;
endmodule
