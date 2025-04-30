`timescale 1ns/1ps

module tb_Tarea1;

    logic clk;
    logic reset;
    logic enable;
    logic A, B;
    logic [1:0] cod_out;
    logic [1:0] sum_out;

    // DUT: Design Under Test
    Tarea1 dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .A(A),
        .B(B),
        .cod_out(cod_out),
        .sum_out(sum_out)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Stimulus
    initial begin
        $display("Time | A B | C D | Sum_out | Enable");
        $monitor("%4t | %b %b | %b %b |   %b    |   %b",
                 $time, A, B, dut.C_D[1], dut.C_D[0], sum_out, enable);

        // Inicialización
        reset = 1;
        enable = 0;
        A = 0;
        B = 0;

        #10;
        reset = 0;

        // Primer valor A=0, B=1 => 01 + 00 = 01
        A = 0; B = 1; enable = 1; #10; enable = 0; #10;

        // Segundo valor A=1, B=0 => 10 + 01 = 11 (mod 4)
        A = 1; B = 0; enable = 1; #10; enable = 0; #10;

        // Tercer valor A=1, B=1 => 11 + 11 = 10 (mod 4)
        A = 1; B = 1; enable = 1; #10; enable = 0; #10;

        // Cuarto valor A=0, B=0 => 00 + 10 = 10
        A = 0; B = 0; enable = 1; #10; enable = 0; #10;
		  
		  // Quinto valor A=0, B=1 => 01 + 10 = 11
        A = 0; B = 1; enable = 1; #10; enable = 0; #10;

        // Sexto valor A=1, B=0 => 10 + 11 = 01 (mod 4)
        A = 1; B = 0; enable = 1; #10; enable = 0; #10;

        // Séptimo valor A=1, B=1 => 11 + 01 = 00 (mod 4)
        A = 1; B = 1; enable = 1; #10; enable = 0; #10;

        // Octavo valor A=0, B=0 => 00 + 11 = 11
        A = 0; B = 0; enable = 1; #10; enable = 0; #10;

        // Noveno valor A=0, B=1 => 01 + 11 = 00 (mod 4)
        A = 0; B = 1; enable = 1; #10; enable = 0; #10;

        // Décimo valor A=1, B=0 => 10 + 00 = 10
        A = 1; B = 0; enable = 1; #10; enable = 0; #10;

        // Undécimo valor A=1, B=1 => 11 + 10 = 01 (mod 4)
        A = 1; B = 1; enable = 1; #10; enable = 0; #10;

        // Duodécimo valor A=0, B=0 => 00 + 01 = 01
        A = 0; B = 0; enable = 1; #10; enable = 0; #10;

        // Decimotercer valor A=0, B=1 => 01 + 01 = 10
        A = 0; B = 1; enable = 1; #10; enable = 0; #10;

        // Decimocuarto valor A=1, B=0 => 10 + 10 = 00 (mod 4)
        A = 1; B = 0; enable = 1; #10; enable = 0; #10;

        // Decimoquinto valor A=1, B=1 => 11 + 00 = 11
        A = 1; B = 1; enable = 1; #10; enable = 0; #10;

        // Decimosexto valor A=0, B=0 => 00 + 11 = 11
        A = 0; B = 0; enable = 1; #10; enable = 0; #10;

		  

        // Fin
        $finish;
    end

endmodule

