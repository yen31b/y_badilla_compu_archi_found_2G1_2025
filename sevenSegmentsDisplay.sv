module sevenSegmentsDisplay (
	input logic A,
	input logic B,
	input logic C,
	input logic D,
	output logic [6:0] segments
);

assign segments[0] = ~((A&~B&~C)|(~A&B&D)|(A&~D)|(~A&C) |(B&C)|(~B&~D));
assign segments[1] = ~((~A&~C&~D)|(~A&C&D)|(A&~C&D)|(~B&~C)|(~B&~D));
assign segments[2] = ~((~A&~C)|(~A&D)|(~C&D)|(~A&B)|(A&~B));
assign segments[3] = ~((~A&~B&~D)|(~B&C&D)|(B&~C&D)|(B&C&~D)|(A&~C));
assign segments[4] = ~((~B&~D)|(C&~D)|(A&C)|(A&B));
assign segments[5] = ~((~A&B&~C)|(~C&~D)|(B&~D)|(A&~B)|(A&C));
assign segments[6] = ~((~A&B&~C)|(~B&C)|(C&~D)|(A&~B)|(A&D));

endmodule