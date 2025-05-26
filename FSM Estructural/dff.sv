// Flip-flop D estructural con reset y enable
module dff(
    input  logic clk,
    input  logic rst,
    input  logic en,
    input  logic d,
    output logic q
);

    // Señales intermedias para el latch SR
    logic s, r;
    logic q_int, qn_int;

    // si rst es 1, salida va a 0
    assign s = (~clk & en & d & ~rst);      // Set cuando clk baja, enable y d=1 y no reset
    assign r = (~clk & en & ~d & ~rst) | rst; // Reset cuando clk baja, enable y d=0, o reset activo

    // Latch SR
    assign q_int  = ~(r | qn_int);
    assign qn_int = ~(s | q_int);

    // Salida
    assign q = q_int;

endmodule