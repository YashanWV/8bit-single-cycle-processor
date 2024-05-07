/*
CO224: Computer Architecture 
Lab 05: Part-1				 
The Sub Module ADD			 
Group - 12					 
*/

`timescale 1ns/100ps

// ADD module definition
module ADD(DATA1, DATA2, RESULT);

	// Begin port declaration
	input [7:0] DATA1, DATA2; // Declare inputs
	
	output [7:0] RESULT; // Declare output
	// End of port declaration
	
	// Using continuous assignment assign DATA1 + DATA2 to RESULT (Unit's delay = #2)
	assign #2 RESULT = DATA1 + DATA2;
	
endmodule
