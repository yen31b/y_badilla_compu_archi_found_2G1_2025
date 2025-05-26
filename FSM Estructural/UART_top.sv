module UART_top (
    input  logic clk,
    input  logic rst,
    input  logic rxd,
	 input  logic signal_arduino,
    output logic txd,
    output logic [7:0] data_out,
    output logic data_ready
);
	 // feq / baudrate
	 localparam tick = 5208; // 50_000_000 / 9600

    // UART RX
    logic [2:0] rx_count;       // Contador para UART_rx
    logic rx_done;              // Bandera de dato recibido (de UART_rx)
    logic [7:0] rx_byte;        // Byte recibido desde UART_rx
	 

    // UART TX
    logic [2:0] tx_count;       // Contador para UART_tx
    logic tx_done;              // Bandera de transmisión terminada (de UART_tx)
    logic [7:0] tx_byte;        // Byte a transmitir hacia UART_tx
    logic tx_start;             // Señal para iniciar la transmis

    // Señales de control creadas por la FSM
    logic reg_rx_en;            // Habilitar registro de dato recibido
    logic reg_tx_en;            // Habilitar registro de dato a transmitir


    // RX
    UART_rx uart_rx_inst (
        .clk(clk),
        .tick(tick),
        .rxd(rxd),
        .count(rx_count),         
        .rx_done(rx_done),
        .data_out(rx_byte)
    );

    //TX
    UART_tx uart_tx_inst (
        .clk(clk),
        .tick(tick),
        .tx_start(tx_start),
        .count(tx_count),       
        .data_in(tx_byte),
        .txd(txd),
        .tx_done(tx_done)
    );


    // FSM comunicacion
    uart_fsm_estructural fsm_inst (
        .clk(clk),
        .rst(rst),
        .rx_done(rx_done),
        .tx_done(tx_done),
		  .signal_arduino(signal_arduino),
        .reg_rx_en(reg_rx_en),
        .reg_tx_en(reg_tx_en),
        .tx_start(tx_start),
        .data_ready(data_ready)
    );

    //Registro para guardar el byte recibido
    registro_param #(.N(8)) rx_byte_reg (
        .clk(clk),
        .d(rx_byte),
		  .rst(rst),
        .en(reg_rx_en),
        .q(data_out)
    );

    //Registro estructural para preparar el byte a transmitir
    registro_param #(.N(8)) tx_byte_reg (
        .clk(clk),
		  .rst(rst),
        .d(rx_byte), // en este caso manda lo que recibe, como un echo
        .en(reg_tx_en),
        .q(tx_byte)
    );
	 
	 //Contadores estructurales para RX/TX (3 bits) , va contando hasta 7
    registro_param #(.N(3)) rx_count_reg (
        .clk(clk),
		  .rst(rst),
        .d(rx_count + 3'd1),    // Incremento del contador
        .en(tick & ~rx_done),   // Incrementa mientras no se haya recibido el byte completo
        .q(rx_count)            // Salida del contador
    );

    registro_param #(.N(3)) tx_count_reg (
        .clk(clk),
		  .rst(rst),
        .d(tx_count + 3'd1),    // Incremento del contador
        .en(tick & ~tx_done),   // Incrementa mientras no se haya transmitido el byte completo
        .q(tx_count)            // Salida del contador
    );

endmodule
	