module FlipFlop (
    input  logic clk,
    input  logic reset,
    input  logic enable,
    input  logic [1:0] data_in,
    output logic [1:0] data_out
);
    mi_dff ff0 (.clk(clk), .reset(reset), .enable(enable), .d(data_in[0]), .q(data_out[0]));
    mi_dff ff1 (.clk(clk), .reset(reset), .enable(enable), .d(data_in[1]), .q(data_out[1]));
endmodule