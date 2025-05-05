module decodificador_motor (
    input logic C,
    input logic D,
    output logic motor_on
);
    assign motor_on = ~(C ^ D);  // Motor ON solo si C == D (00 o 11)
endmodule