module registro8 (
    input  logic clk,
    input  logic rst,
    input  logic enable,            // Control de carga
    input  logic [7:0] d,           // Entrada de datos
    output logic [7:0] q            // Salida de datos
);
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dffs
            dff dff_inst (
                .clk(clk),
                .rst(rst),
                .en(enable),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule