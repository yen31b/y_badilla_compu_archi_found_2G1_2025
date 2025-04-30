module FlipFlop (
    input  logic clk,
    input  logic reset,
    input  logic enable,           // Pulsador
    input  logic [1:0] data_in,    // Suma combinacional (S1, S0)
    output logic [1:0] data_out    // Se conectará como C y D
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            data_out <= 2'b00;
        else if (enable)
            data_out <= data_in;
    end

endmodule
