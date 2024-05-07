/*
CO224: Computer Architecture 
Lab 05: Part-4				 
The Sub Module target_address			 
Group - 12					 
*/

`timescale 1ns/100ps

// tyarget_address module definition
module target_address(PC,OFFSET,TARGET_ADDR);

    // Begin port declaration
    input [7:0] OFFSET;     // Declare inputs
    input [31:0] PC;

    output [31:0] TARGET_ADDR;      // Declare output
    // End of port declaration

    wire [21:0] extend_bits;    // Sign bit can be usede to extend a bit word

    assign extend_bits = {22{OFFSET[7]}};   // Assign MSD of OFFSET to extend TARGET_ADDR to 32-bits

    assign #2 TARGET_ADDR = PC + {extend_bits,OFFSET,2'b00};    // Making Target address by sum of PC and OFFSET*4

endmodule