/*
CO224: Computer Architecture 
Lab 05: Part-2				 
Register File				 
Group - 12					 
*/

// Definition of the register file
module reg_file(IN,OUT1,OUT2,INADDRESS,OUT1ADDRESS,OUT2ADDRESS, WRITE, CLK, RESET);

	// Begin port declaration
	input [7:0] IN; // 8-bit input for input the data
	input [2:0] INADDRESS, OUT1ADDRESS, OUT2ADDRESS; // To store the register numbers of input & output data
	
	input WRITE, CLK, RESET; // Inputs for WRITEENABLE CLOCK and RESET signals
	
	output [7:0] OUT1, OUT2; // 8-bit outputs for output the data(Should be read asynchronously)
	// End of port declaration
	
	// An array of 8*8-bit registers
	reg [7:0] REGISTER [7:0];

	integer i; // This variable will used to iterate throught the foor loop
	
	//Reads data from registers asynchronously
	// Using continuous assignment assign OUT1 and OUT2 for OUT1ADRESS and OUT2ADDRESS registers respectively (Unit's delay = #2)
	assign #2 OUT1 = REGISTER[OUT1ADDRESS];		
	assign #2 OUT2 = REGISTER[OUT2ADDRESS];		
	
	// Write and Reset registers synchronously

	always @ (posedge CLK)
	begin

		if (RESET == 1'b1) // If the RESET signal is HIGH, registers must be cleared
		begin
		
			#1 for (i = 0; i < 8; i = i + 1) // Iterating through the register file
			begin
				REGISTER[i] = 8'b00000000; // Clearing each element in register array
			end
			
		end

		else if (WRITE == 1'b1)	// If the RESET signal is LOW, write to the registers if WRITE signal is HIGH
		begin
		
			#1 REGISTER[INADDRESS] = IN; // Assigns the input value IN to relevant register address after a delay of 1
			
		end
		
	end
	
	initial begin
			$monitor($time, "\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d", REGISTER[0], REGISTER[1],REGISTER[2],REGISTER[3],REGISTER[4],REGISTER[5],REGISTER[6],REGISTER[7]);
	end

endmodule