/*
CO224: Computer Architecture 
Lab 05: Part-3				 
The Sub Module 2sComp			 
Group - 12					 
*/

// twosComp module definition
module TwosComp(OPERAND, RESULT);

	// Begin port declaration
    input [7:0] OPERAND;    // Declare input
	output [7:0] RESULT;    // Declare output
    // End of port declaration
	
	// Combinational logic to getting the 2's complement of the OPERAND and assigning it to the RESULT
	assign #1 RESULT = ~OPERAND + 1;

endmodule