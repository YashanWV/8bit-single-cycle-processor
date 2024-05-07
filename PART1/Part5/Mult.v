/*
CO224: Computer Architecture 
Lab 05: Part-5				 
The Sub Module MULT			 
Group - 12					 
*/

`include "FullAdder.v"

// MULT module definition
module MULT(OPERAND1, OPERAND2, RESULT);

	// Begin port declaration
	input [7:0] OPERAND1, OPERAND2;     // Declare inputs

	output [7:0] RESULT;                 // Declare output
    // End of port declaration
	
	// Carry bits for Intermediate Sums
	wire Carry0 [5:0];
	wire Carry1 [4:0];
	wire Carry2 [3:0];
	wire Carry3 [2:0];
	wire Carry4 [1:0];
	wire Carry5;
	
	// Intermediate Sums
	wire Sum0 [5:0];
	wire Sum1 [4:0];
	wire Sum2 [3:0];
	wire Sum3 [2:0];
	wire Sum4 [1:0];
	wire Sum5;
	
	// A Bus to store Intermediate Results
	wire [7:0] Intermediate;
	
	// Setting first bit of the RESULT
	assign Intermediate[0] = OPERAND2[0] & OPERAND1[0];	
	
	
	/* Calculating the multiplication
                        10110101
                      * 11000001
              -------------------  
                        10110101
               +       00000000
               +      00000000
               +     00000000
               +    00000000
               +   00000000
               +  10110101
               + 10110101 
    */
        
	FullAdder FA0_0(OPERAND2[0] & OPERAND1[1], OPERAND2[1] & OPERAND1[0], 1'b0, Intermediate[1], Carry0[0]);
	FullAdder FA0_1(OPERAND2[0] & OPERAND1[2], OPERAND2[1] & OPERAND1[1], Carry0[0], Sum0[0], Carry0[1]);
	FullAdder FA0_2(OPERAND2[0] & OPERAND1[3], OPERAND2[1] & OPERAND1[2], Carry0[1], Sum0[1], Carry0[2]);
	FullAdder FA0_3(OPERAND2[0] & OPERAND1[4], OPERAND2[1] & OPERAND1[3], Carry0[2], Sum0[2], Carry0[3]);
	FullAdder FA0_4(OPERAND2[0] & OPERAND1[5], OPERAND2[1] & OPERAND1[4], Carry0[3], Sum0[3], Carry0[4]);
	FullAdder FA0_5(OPERAND2[0] & OPERAND1[6], OPERAND2[1] & OPERAND1[5], Carry0[4], Sum0[4], Carry0[5]);
	FullAdder FA0_6(OPERAND2[0] & OPERAND1[7], OPERAND2[1] & OPERAND1[6], Carry0[5], Sum0[5], );
	
	FullAdder FA1_0(Sum0[0], OPERAND2[2] & OPERAND1[0], 1'b0, Intermediate[2], Carry1[0]);
	FullAdder FA1_1(Sum0[1], OPERAND2[2] & OPERAND1[1], Carry1[0], Sum1[0], Carry1[1]);
	FullAdder FA1_2(Sum0[2], OPERAND2[2] & OPERAND1[2], Carry1[1], Sum1[1], Carry1[2]);
	FullAdder FA1_3(Sum0[3], OPERAND2[2] & OPERAND1[3], Carry1[2], Sum1[2], Carry1[3]);
	FullAdder FA1_4(Sum0[4], OPERAND2[2] & OPERAND1[4], Carry1[3], Sum1[3], Carry1[4]);
	FullAdder FA1_5(Sum0[5], OPERAND2[2] & OPERAND1[5], Carry1[4], Sum1[4], );
	
	FullAdder FA2_0(Sum1[0], OPERAND2[3] & OPERAND1[0], 1'b0, Intermediate[3], Carry2[0]);
	FullAdder FA2_1(Sum1[1], OPERAND2[3] & OPERAND1[1], Carry2[0], Sum2[0], Carry2[1]);
	FullAdder FA2_2(Sum1[2], OPERAND2[3] & OPERAND1[2], Carry2[1], Sum2[1], Carry2[2]);
	FullAdder FA2_3(Sum1[3], OPERAND2[3] & OPERAND1[3], Carry2[2], Sum2[2], Carry2[3]);
	FullAdder FA2_4(Sum1[4], OPERAND2[3] & OPERAND1[4], Carry2[3], Sum2[3], );
	
	FullAdder FA3_0(Sum2[0], OPERAND2[4] & OPERAND1[0], 1'b0, Intermediate[4], Carry3[0]);
	FullAdder FA3_1(Sum2[1], OPERAND2[4] & OPERAND1[1], Carry3[0], Sum3[0], Carry3[1]);
	FullAdder FA3_2(Sum2[2], OPERAND2[4] & OPERAND1[2], Carry3[1], Sum3[1], Carry3[2]);
	FullAdder FA3_3(Sum2[3], OPERAND2[4] & OPERAND1[3], Carry3[2], Sum3[2], );
	
	FullAdder FA4_0(Sum3[0], OPERAND2[5] & OPERAND1[0], 1'b0, Intermediate[5], Carry4[0]);
	FullAdder FA4_1(Sum3[1], OPERAND2[5] & OPERAND1[1], Carry4[0], Sum4[0], Carry4[1]);
	FullAdder FA4_2(Sum3[2], OPERAND2[5] & OPERAND1[2], Carry4[1], Sum4[1], );
	
	FullAdder FA5_0(Sum4[0], OPERAND2[6] & OPERAND1[0], 1'b0, Intermediate[6], Carry5);
	FullAdder FA5_1(Sum4[1], OPERAND2[6] & OPERAND1[1], Carry5, Sum5, );
	
	FullAdder FA6_0(Sum5, OPERAND2[7] & OPERAND1[0], 1'b0, Intermediate[7], );
	
	// Assigning the result after #3 time units delay
	assign #3 RESULT = Intermediate;

endmodule

