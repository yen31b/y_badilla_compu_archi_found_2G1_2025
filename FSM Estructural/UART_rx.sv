module UART_rx (
  input  logic clk,
  input  logic tick,
  input  logic rxd,
  input  logic [2:0] count,
  output logic rx_done,
  output logic [7:0] data_out
);

  // Estados 
  logic S1, S0;
  logic S1_next, S0_next;

  
  logic [7:0] sbus_reg;
  logic [7:0] load_bit;
  logic [7:0] next_sbus_reg;

  // Comparador de count == 7 y count != 7
  logic count_eq7, count_neq7;
  assign count_eq7  = count[2] & count[1] & count[0];
  assign count_neq7 = ~count_eq7;

  // Cálculo del próximo estado 
  assign S1_next = (~S1 & S0  & tick & count_neq7) |
                   ( S1 & ~S0 & tick) |
                   ( S1 &  S0 & ~rxd);

  assign S0_next = (~S1 & ~S0 & ~rxd) |
                   (~S1 &  S0 & ~tick) |
                   ( ~S1 & S0 & tick & ~count_eq7) |
                   ( S1 & ~ S0 & tick & ~count_eq7) |
						 (S1 & S0 & ~rxd);

  // Registro de estado
  always_ff @(posedge clk) begin
    S1 <= S1_next;
    S0 <= S0_next;
  end

  // rx_done activo solo en estado STOP 
  assign rx_done = S1 & S0;

  // Señal para habilitar carga de bit en sbus_reg 
  wire enable_shift;
  assign enable_shift = S1 & ~S0 & tick;

  // Generación estructural para cargar cada bit según valor de count
  assign load_bit[0] = enable_shift & ~count[2] & ~count[1] & ~count[0];
  assign load_bit[1] = enable_shift & ~count[2] & ~count[1] &  count[0];
  assign load_bit[2] = enable_shift & ~count[2] &  count[1] & ~count[0];
  assign load_bit[3] = enable_shift & ~count[2] &  count[1] &  count[0];
  assign load_bit[4] = enable_shift &  count[2] & ~count[1] & ~count[0];
  assign load_bit[5] = enable_shift &  count[2] & ~count[1] &  count[0];
  assign load_bit[6] = enable_shift &  count[2] &  count[1] & ~count[0];
  assign load_bit[7] = enable_shift &  count[2] &  count[1] &  count[0];

  // Logica estructural para cada bit del registro
  assign next_sbus_reg[0] = (load_bit[0] & rxd) | (~load_bit[0] & sbus_reg[0]);
  assign next_sbus_reg[1] = (load_bit[1] & rxd) | (~load_bit[1] & sbus_reg[1]);
  assign next_sbus_reg[2] = (load_bit[2] & rxd) | (~load_bit[2] & sbus_reg[2]);
  assign next_sbus_reg[3] = (load_bit[3] & rxd) | (~load_bit[3] & sbus_reg[3]);
  assign next_sbus_reg[4] = (load_bit[4] & rxd) | (~load_bit[4] & sbus_reg[4]);
  assign next_sbus_reg[5] = (load_bit[5] & rxd) | (~load_bit[5] & sbus_reg[5]);
  assign next_sbus_reg[6] = (load_bit[6] & rxd) | (~load_bit[6] & sbus_reg[6]);
  assign next_sbus_reg[7] = (load_bit[7] & rxd) | (~load_bit[7] & sbus_reg[7]);

  always_ff @(posedge clk) begin
    sbus_reg <= next_sbus_reg;
  end

  // Salida final de datos
  assign data_out = sbus_reg;

endmodule