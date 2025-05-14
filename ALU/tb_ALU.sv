module tb_ALU;

  // Definición de señales
  reg [3:0] A, B;
  reg [1:0] OP;
  wire [7:0] R;
  wire Z, N, C, V;

  // Instancia del módulo ALU
  ALU uut (
    .A(A),
    .B(B),
    .OP(OP),
    .R(R),
    .Z(Z),
    .N(N),
    .C(C),
    .V(V)
  );

  // Bloque de prueba
  initial begin
    // Monitorear las señales
    $monitor("A = %b, B = %b, OP = %b, R = %b, Z = %b, N = %b, C = %b, V = %b", A, B, OP, R, Z, N, C, V);

    // Test de multiplicación (OP = 00)
    A = 4'b0011; B = 4'b0010; OP = 2'b00; // 3 * 2 = 6
    #10; // esperar 10 unidades de tiempo
    A = 4'b0100; B = 4'b0100; OP = 2'b00; // 4 * 4 = 16
    #10;
    
    // Test de resta (OP = 01)
    A = 4'b0101; B = 4'b0011; OP = 2'b01; // 5 - 3 = 2
    #10;
    A = 4'b0110; B = 4'b1000; OP = 2'b01; // 6 - 8 = -2 (verificar banderas de overflow y carry)
    #10;

    // Test de AND (OP = 10)
    A = 4'b1101; B = 4'b1011; OP = 2'b10; // 1101 AND 1011 = 1001
    #10;

    // Test de XOR (OP = 11)
    A = 4'b1101; B = 4'b1011; OP = 2'b11; // 1101 XOR 1011 = 0110
    #10;

    // Test de Zero flag (Z = 1 cuando el resultado es 0)
    A = 4'b0000; B = 4'b0000; OP = 2'b00; // 0 * 0 = 0
    #10;

    // Test de bandera negativa (N = 1 cuando el resultado es negativo, solo en operaciones de resta)
    A = 4'b1000; B = 4'b1100; OP = 2'b01; // 8 - 12 = -4
    #10;

    // Test de bandera de carry y overflow (solo para resta)
    A = 4'b0001; B = 4'b0010; OP = 2'b01; // 1 - 2 = -1 (verificar carry)
    #10;
    
    // Fin de la simulación
    $finish;
  end

endmodule
