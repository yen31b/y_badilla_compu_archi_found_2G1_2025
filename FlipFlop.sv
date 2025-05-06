module FlipFlop (
    input  logic clk_btn, // Botón de FPGA que actúa como reloj
    input  logic reset,
    input  logic enable,           // Pulsador
    input  logic [1:0] data_in,    // Suma combinacional (S1, S0)
    output logic [1:0] data_out    // Se conectará como C y D
);

	logic clk_ff;  // Reloj a usar en el flip-flop, invertido a la lógica del botón
	assign clk_ff = ~clk_btn;  // Se invierte la lógica del botón

	my_dff ff0 (
		 .clk(clk_ff),
		 .reset(reset),
		 .d(data_in[0]),
		 .q(data_out[0])
	);
	
    my_dff ff1 (
        .clk(clk_ff),
		  .reset(reset),
        .d(data_in[1]),
        .q(data_out[1])
    );
endmodule