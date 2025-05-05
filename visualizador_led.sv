module visualizador_led (
    input  logic [1:0] valor,   // Entradas: C_D (estado acumulado)
    output logic led0,
    output logic led1,
    output logic led2,
    output logic led3
);

    // Detectar cada valor con compuertas

    // led0 activo cuando valor == 2'b00
    wire not_valor1, not_valor0;
    not (not_valor1, valor[1]);
    not (not_valor0, valor[0]);
    and (led0, not_valor1, not_valor0);

    // led1 activo cuando valor == 2'b01
    wire not_valor1_b;
    not (not_valor1_b, valor[1]);
    and (led1, not_valor1_b, valor[0]);

    // led2 activo cuando valor == 2'b10
    wire not_valor0_b;
    not (not_valor0_b, valor[0]);
    and (led2, valor[1], not_valor0_b);

    // led3 activo cuando valor == 2'b11
    and (led3, valor[1], valor[0]);

endmodule
