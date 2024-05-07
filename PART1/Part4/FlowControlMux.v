/*
CO224: Computer Architecture 
Lab 05: Part-4				 
The Sub Module Mux			 
Group - 12					 
*/

// mux module definition
module flowMUX(IN1, IN2, SELECT, OUT);

	// Begin port declaration
	input [31:0] IN1, IN2;   // Declare inputs
	input SELECT;
	output reg [31:0] OUT;   // Declare output
    // End of port declaration
	
	// Mux should update output value if any changes happened in inputs
	always @ (IN1, IN2, SELECT)
	begin
		if (SELECT == 1'b0)		//If SELECT is Law, switch to 1st input
		begin
			OUT = IN1;
		end
		else					//If SELECT is High, switch to 2nd input
		begin
			OUT = IN2;
		end
	end

endmodule