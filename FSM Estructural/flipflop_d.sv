// Flip-flop D estructural con reset y enable
module flipflop_d(
    input  logic clk,
    input  logic rst,
    input  logic en,
    input  logic d,
    output logic q
);
    logic qm, qn_m; // Maestro
    logic qs, qn_s; // Esclavo

    // Maestro: transparente cuando clk=0
    wire s_m = (~clk & en & d & ~rst);
    wire r_m = (~clk & en & ~d & ~rst) | rst;
    assign qm   = ~(r_m | qn_m);
    assign qn_m = ~(s_m | qm);

    // Esclavo: transparente cuando clk=1
    wire s_s = (clk & qm & ~rst);
    wire r_s = (clk & ~qm & ~rst) | rst;
    assign qs   = ~(r_s | qn_s);
    assign qn_s = ~(s_s | qs);

    assign q = qs;
endmodule