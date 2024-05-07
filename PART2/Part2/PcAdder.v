/*
CO224: Computer Architecture 
Lab 05: Part-4				 
The Sub Module PCadder			 
Group - 12					 
*/

`timescale 1ns/100ps

// PCadder module definition
module PCadder(PC,IncrementedPC);

    // Begin port declaration
    input [31:0] PC;    // Declare input
	output [31:0] IncrementedPC;    // Declare output
    // End of port declaration

    assign #1 IncrementedPC = PC + 4;   // Incrementing program counter's value by 4

endmodule