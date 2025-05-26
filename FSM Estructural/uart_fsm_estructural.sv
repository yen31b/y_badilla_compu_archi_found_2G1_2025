module uart_fsm_estructural (
    input  logic clk,
    input  logic rst,
    input  logic rx_done,
    input  logic tx_done,
	 input  logic signal_arduino,
    output logic reg_rx_en,
    output logic reg_tx_en,
    output logic tx_start,
    output logic data_ready
);

    // Estado actual y siguiente
    logic [1:0] state, next_state;

    // Codificación de estados
    localparam [1:0]
        IDLE     = 2'b00,
        RECEIVE  = 2'b01,
        TRANSMIT = 2'b10,
        WAIT     = 2'b11;

    // next_state[1]
    assign next_state[1] = 
        (~state[1] &  state[0] & rx_done & signal_arduino) | // IDLE -> TRANSMIT
        ( state[1] & ~state[0])                | // TRANSMIT -> WAIT
        ( state[1] &  state[0] & tx_done);  // WAIT -> IDLE

    // next_state[0]
    assign next_state[0] = 
        (~state[1] & ~state[0] & rx_done& signal_arduino) | // IDLE -> RECEIVE
        ( state[1] & ~state[0])                | // TRANSMIT -> WAIT
        ( state[1] &  state[0] & ~tx_done); // WAIT mantiene WAIT si no termina TX

    // Registro de estado

    registro_param #(.N(2)) state_reg (
        .clk(clk),
        .d(next_state),
		  .rst(rst),
        .en(1'b1),
        .q(state)
    );


    //salidas

    // reg_rx_en: habilita carga de RX cuando IDLE y rx_done
    assign reg_rx_en  = (~state[1] & ~state[0] & rx_done& signal_arduino);

    // reg_tx_en: habilita carga de TX cuando pasa a TRANSMIT
    assign reg_tx_en  = (~state[1] &  state[0] & rx_done& signal_arduino);

    // tx_start: inicia transm cuando TRANSMIT
    assign tx_start   = (state == TRANSMIT);

    // data_ready: cuando esta en WAIT y termina TX
    assign data_ready = (state == WAIT) & tx_done;

endmodule