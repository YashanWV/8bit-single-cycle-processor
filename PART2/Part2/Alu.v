/*
CO224: Computer Architecture 
Lab 05: Part-1				 
The ALU Module			 
Group - 12					 
*/

`timescale 1ns/100ps

// Importing modules
`include "Add.v"
`include "And.v"
`include "Forward.v"
`include "Or.v"

// ALU module definition
module alu(DATA1, DATA2, RESULT, SELECT, ZERO);
	
	// Begin port declaration
	input [7:0] DATA1, DATA2;	// Declare inputs
	input [2:0] SELECT;
	
	output reg [7:0] RESULT;	// Declare outputs
	output ZERO;
	// End of port declaration
	
	// Wires for outputs of the distinct functional units
	wire [7:0] Forward_Out, Add_Out, And_Out, Or_Out;
	
	
	// Instantiation of modules
	FORWARD forward1(DATA2, Forward_Out); // Instantiate a FORWARD object
	ADD add1(DATA1, DATA2, Add_Out); // Instantiate an ADD object
	AND and1(DATA1, DATA2, And_Out); // Instantiate an AND object
	OR or1(DATA1, DATA2, Or_Out); // Instantiate an OR object
	
	
	// A MUX to pick one of the functional units, outputs and send it to RESULT based on the SELECT value
	always @ (Forward_Out, Add_Out, And_Out, Or_Out, SELECT)	
	begin

		case (SELECT)	
			3'b000 :	RESULT = Forward_Out;	//SELECT = 0 : FORWARD
			3'b001 :	RESULT = Add_Out;		//SELECT = 1 : ADD
			3'b010 :	RESULT = And_Out;		//SELECT = 2 : AND
			3'b011 :	RESULT = Or_Out;		//SELECT = 3 : OR
			3'b1xx :	RESULT = 8'bxxxxxxxx;	//SELECT = 1xx : x
		endcase

	end
	// Combinational logic for check the equality of compared operands in beq instructions
	assign ZERO = ~( RESULT[0] | RESULT[1] | RESULT[2] | RESULT[3] | RESULT[4] | RESULT[5] | RESULT[6] | RESULT[7] );

endmodule