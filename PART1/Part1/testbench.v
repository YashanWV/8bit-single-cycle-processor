/*
CO224: Computer Architecture 
Lab 05: Part-1				 
The testbench module			 
Group - 12					 
*/

// Importing modules
`include "Alu.v"

// Definition of testbench module
module testbench;

	// Input ports for ALU
	reg [7:0] OPERAND1, OPERAND2;
	reg [2:0] ALUOP;
	
	// Output port of ALU
	wire [7:0] ALURESULT;
	
	// Instantiate an ALU instance
	alu ALU1(OPERAND1, OPERAND2, ALURESULT, ALUOP);
	
	//Simulation

	initial begin

		OPERAND1 = 0;	
		OPERAND2 = 0;
		
		#5

		// The FORWARD operation
		OPERAND1 = 10;	
		OPERAND2 = 20;
		ALUOP = 0;

		#5
		
		// The ADD operation
		OPERAND2 = 15;
		ALUOP = 1;
		
		#5
		
		// The AND operation
		OPERAND1 = 7;
		OPERAND2 = 14;
		ALUOP = 2;
		
		#5
		
		// The OR operation
		OPERAND2 = 30;
		ALUOP = 3;
		
	end
	
	// Monitoring the changes and dumping the wave data into a vcd file
	initial begin
		$dumpfile("wavedata.vcd");
		$dumpvars(0, ALU1);
		$monitor($time, " OPERAND1 = %d OPERAND2 = %d ALUOP = %b ALURESULT = %d", OPERAND1, OPERAND2, ALUOP, ALURESULT);
		#30 $finish;
	end

endmodule
