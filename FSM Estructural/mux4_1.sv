// Mux 4 a 1 con compuertas lógicas
module mux4to1(
    input  logic [1:0] select, // Selector de 2 bits
    input  logic a,         // Entrada 0
    input  logic b,         // Entrada 1
    input  logic c,         // Entrada 2
    input  logic d,         // Entrada 3
    output logic y          // Salida
);
    logic nsel0, nsel1;
    logic s0_and_s1, s0_and_nsel1, nsel0_and_s1, nsel0_and_nsel1;
    logic a_term, b_term, c_term, d_term;

    assign nsel0 = ~select[0];
    assign nsel1 = ~select[1];

    assign a_term = a & nsel1 & nsel0; // sel=00
    assign b_term = b & nsel1 & select[0]; // sel=01
    assign c_term = c & select[1] & nsel0; // sel=10
    assign d_term = d & select[1] & select[0]; // sel=11

    assign y = a_term | b_term | c_term | d_term;
endmodule