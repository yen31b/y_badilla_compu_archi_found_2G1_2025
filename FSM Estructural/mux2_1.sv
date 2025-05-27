module mux2_1(
    input wire a, b, select,
    output wire y
);
    wire nselect;
    wire a_and_nsel, b_and_sel;

    assign nselect      = ~select;
    assign a_and_nsel   = a & nselect;
    assign b_and_sel    = b & select;
    assign y            = a_and_nsel | b_and_sel;
endmodule

	