module multiplier_unsigned4(
    input  logic [3:0] a,
    input  logic [3:0] b,
    output logic [7:0] result
);
    // Productos parciales (ANDs)
    logic [3:0] pp0, pp1, pp2, pp3;
    assign pp0 = a & {4{b[0]}};
    assign pp1 = a & {4{b[1]}};
    assign pp2 = a & {4{b[2]}};
    assign pp3 = a & {4{b[3]}};

    // Sumas escalonadas (estructural, pero usando suma Verilog aquí para claridad)
    assign result = (pp0) +
                    (pp1 << 1) +
                    (pp2 << 2) +
                    (pp3 << 3);
endmodule