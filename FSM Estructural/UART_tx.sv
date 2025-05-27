module UART_tx (
  input  logic        clk,
  input  logic        tick,
  input  logic        tx_start,
  input  logic [2:0]  count,
  input  logic [7:0]  data_in,
  output logic        txd,
  output logic        tx_done
);

  // Estado actual y próximo
  logic S1, S0;
  logic S1_next, S0_next;

  // Registros de datos y contador
  logic [7:0] buf_reg, next_buf_reg;
  logic [2:0] count_reg, next_count_reg;

  // Decodificadores de estado
  wire is_IDLE  = ~S1 & ~S0;
  wire is_START = ~S1 &  S0;
  wire is_TRANS =  S1 & ~S0;
  wire is_STOP  =  S1 &  S0;

  // Comparadores count == 7 y count != 7
  wire count_eq7  = count_reg[2] & count_reg[1] & count_reg[0];
  wire count_neq7 = ~count_eq7;

  // Ecuaciones de próximo estado 
  assign S1_next = (S1 & ~S0) | ((~S1) & S0 & tx_start & tick);
  assign S0_next = (~S1 & ~S0 & tx_start)
                 | (S1 & ~S0 & count_eq7)
                 | (S1 & S0 );

  // Señales de control para buf_reg y count_reg
  wire load_buf   = is_START & tx_start;
  wire shift_buf  = is_TRANS & tick & count_neq7;

  // Lógica para buf_reg 
  assign next_buf_reg[0] = (load_buf & data_in[0]) | (shift_buf & buf_reg[1]) | ((~load_buf) & (~shift_buf) & buf_reg[0]);
  assign next_buf_reg[1] = (load_buf & data_in[1]) | (shift_buf & buf_reg[2]) | ((~load_buf) & (~shift_buf) & buf_reg[1]);
  assign next_buf_reg[2] = (load_buf & data_in[2]) | (shift_buf & buf_reg[3]) | ((~load_buf) & (~shift_buf) & buf_reg[2]);
  assign next_buf_reg[3] = (load_buf & data_in[3]) | (shift_buf & buf_reg[4]) | ((~load_buf) & (~shift_buf) & buf_reg[3]);
  assign next_buf_reg[4] = (load_buf & data_in[4]) | (shift_buf & buf_reg[5]) | ((~load_buf) & (~shift_buf) & buf_reg[4]);
  assign next_buf_reg[5] = (load_buf & data_in[5]) | (shift_buf & buf_reg[6]) | ((~load_buf) & (~shift_buf) & buf_reg[5]);
  assign next_buf_reg[6] = (load_buf & data_in[6]) | (shift_buf & buf_reg[7]) | ((~load_buf) & (~shift_buf) & buf_reg[6]);
  assign next_buf_reg[7] = (load_buf & data_in[7]) | (shift_buf & 1'b0     ) | ((~load_buf) & (~shift_buf) & buf_reg[7]);

  // Sumador estructural para count_reg 
  wire c0_inc = ~count_reg[0];
  wire c1_inc = count_reg[1] ^ count_reg[0];
  wire c2_inc = count_reg[2] ^ (count_reg[1] & count_reg[0]);
  assign next_count_reg[0] = (load_buf & 1'b0   ) | (shift_buf & c0_inc) | ((~load_buf) & (~shift_buf) & count_reg[0]);
  assign next_count_reg[1] = (load_buf & 1'b0   ) | (shift_buf & c1_inc) | ((~load_buf) & (~shift_buf) & count_reg[1]);
  assign next_count_reg[2] = (load_buf & 1'b0   ) | (shift_buf & c2_inc) | ((~load_buf) & (~shift_buf) & count_reg[2]);

  // Registros de estado y datos
  always_ff @(posedge clk) begin
    S1        <= S1_next;
    S0        <= S0_next;
    buf_reg   <= next_buf_reg;
    count_reg <= next_count_reg;
  end

  // Salidas
  assign txd     = is_IDLE | is_START | is_STOP | (is_TRANS & buf_reg[0]);
  assign tx_done = is_STOP;

endmodule