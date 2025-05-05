module mi_dff (
    input  logic clk,
    input  logic reset,
    input  logic enable,
    input  logic d,
    output logic q
);
    always_ff @(posedge clk) begin
        if (reset)
            q <= 0;
        else if (enable)
            q <= d;
    end
endmodule