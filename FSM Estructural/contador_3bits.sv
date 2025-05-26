module contador_3bits (
    input  logic clk,          // Reloj
    input  logic rst,          // Reset
    input  logic en,           // Habilitación
    output logic [2:0] count   // Salida del contador
);


    logic q0, q1, q2; // Salidas individuales de flip-flop
    logic d0, d1, d2; // Entradas individuales de flip-flop

    //incremento del contador
    assign d0 = ~q0;                          // Bit 0: toggle
    assign d1 = q1 ^ q0;                      // Bit 1: suma con acarreo
    assign d2 = q2 ^ (q1 & q0);               // Bit 2: suma con acarreo

    // Flip-flops D estructurales para cada bit
    dff ff0 (
        .clk(clk),
        .rst(rst),
        .en(en),
        .d(d0),
        .q(q0)
    );

    dff ff1 (
        .clk(clk),
        .rst(rst),
        .en(en),
        .d(d1),
        .q(q1)
    );

    dff ff2 (
        .clk(clk),
        .rst(rst),
        .en(en),
        .d(d2),
        .q(q2)
    );

    // Salida del contador
    assign count = {q2, q1, q0};

endmodule