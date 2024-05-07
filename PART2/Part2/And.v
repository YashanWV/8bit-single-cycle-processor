/*
CO224: Computer Architecture 
Lab 05: Part-1				 
The Sub Module AND			 
Group - 12					 
*/

`timescale 1ns/100ps

// AND module definition
module AND(DATA1, DATA2, RESULT);

	// Begin port declaration
	input [7:0] DATA1, DATA2; // Declare inputs
	
	output [7:0] RESULT; // Declare output
	// End of port declaration

	// Using continuous assignment assign DATA1 & DATA2 to RESULT (Unit's delay = #1)
	assign #1 RESULT = DATA1 & DATA2;
	
endmodule