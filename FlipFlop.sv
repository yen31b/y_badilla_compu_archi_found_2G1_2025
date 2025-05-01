module FlipFlop (
    input  logic clk,
    input  logic reset,
    input  logic enable,           // Pulsador
    input  logic [1:0] data_in,    // Suma combinacional (S1, S0)
    output logic [1:0] data_out    // Se conectará como C y D
);

    logic d0_mux, d1_mux;
    logic hold0, load0;
    logic hold1, load1;
    logic final_d0, final_d1;
    logic n_reset;

    // ~reset
    not (n_reset, reset);

    // ========== BIT 0 ==========

    // hold0 = ~enable & data_out[0] (mantener)
    not (n_enable, enable);
    and (hold0, n_enable, data_out[0]);

    // load0 = enable & data_in[0] (cargar)
    and (load0, enable, data_in[0]);

    // d0_mux = hold0 | load0
    or (d0_mux, hold0, load0);

    // final_d0 = ~reset & d0_mux
    and (final_d0, n_reset, d0_mux);

    // Flip-flop bit 0
    dff ff0 (.clk(clk), .d(final_d0), .q(data_out[0]));

    // ========== BIT 1 ==========

    // hold1 = ~enable & data_out[1]
    and (hold1, n_enable, data_out[1]);

    // load1 = enable & data_in[1]
    and (load1, enable, data_in[1]);

    // d1_mux = hold1 | load1
    or (d1_mux, hold1, load1);

    // final_d1 = ~reset & d1_mux
    and (final_d1, n_reset, d1_mux);

    // Flip-flop bit 1
    dff ff1 (.clk(clk), .d(final_d1), .q(data_out[1]));

endmodule