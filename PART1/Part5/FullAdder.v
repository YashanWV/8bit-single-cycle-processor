/*
CO224: Computer Architecture 
Lab 05: Part-5				 
The Sub Module FullAdder			 
Group - 12					 
*/

// FullAdder module definition
module FullAdder(A, B, C, SUM, CARRY);

	// Begin port declaration
	input A, B, C;      // Declare inputs

	output SUM, CARRY;  // Declare output
    // End of port declaration
	
	//Combinational logic for SUM and CARRY bit outputs
	assign SUM = ((A ^ B) ^ C);
	assign CARRY = (A & B) + (C & (A ^ B));

endmodule