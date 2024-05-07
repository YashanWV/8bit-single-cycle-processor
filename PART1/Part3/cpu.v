/*
CO224: Computer Architecture 
Lab 05: Part-3				 
The CPU module			 
Group - 12					 
*/

`include "Alu.v"
`include "Reg_file.v"
`include "2sComp.v"
`include "Mux.v"


// cpu module definition
module cpu(PC, INSTRUCTION, CLK, RESET);

	// Begin port declaration
	input [31:0] INSTRUCTION;   // Declare inputs
	input CLK, RESET;           
	
	output reg [31:0] PC;       // Declare output
    // End of port declaration

	// Connections for Register File
	wire [2:0] READREG1, READREG2, WRITEREG;
	wire [7:0] REGOUT1, REGOUT2;
	reg WRITEENABLE;
	
	// Connections for ALU
	wire [7:0] OPERAND1, OPERAND2, ALURESULT;
	reg [2:0] ALUOP;
	
	// Connections for 2's Complemented MUX
	wire [7:0] TwosCompMuxOut;
	wire [7:0] TwosCompOperand;
	reg PositiveOrNegative;
	
	// Connections for immediate value MUX
	wire [7:0] IMMEDIATE;
	reg ImmOrRegistered;
	
	// PC value (Next instruction to be executed)
	reg [31:0] PC_Reg;
	
	// OPCODE stored in CPU
	reg [7:0] OPCODE;
	
    // Instantiation of modules
	reg_file MyRegFile(ALURESULT, REGOUT1, REGOUT2, WRITEREG, READREG1, READREG2, WRITEENABLE, CLK, RESET);
    TwosComp MyTwosComp(REGOUT2, TwosCompOperand);
    mux TwosCompMux(REGOUT2, TwosCompOperand, PositiveOrNegative, TwosCompMuxOut);
    mux ImmediateMux(TwosCompMuxOut, IMMEDIATE, ImmOrRegistered, OPERAND2);
	alu MyAlu(REGOUT1, OPERAND2, ALURESULT, ALUOP);

	/*
    Control Logic to The CPU
    */

	// PC Update
	always @ ( posedge CLK )
	begin
		if (RESET == 1'b1) 
		begin
			#1
			PC = 0;		// If RESET signal is HIGH, set PC to zero (Reset the program)
			PC_Reg = 0;
		end
		else 
        begin
            #1 
            PC = PC_Reg;		// Else, write new PC value (Write to PC)
        end 
	end
	
	
	// Update PC Register
	always @ ( PC )
	begin
		#1 PC_Reg = PC_Reg + 4;   // PC = PC+4
	end
	
	
	// The Instruction Format
	
	/****************************************************************
	*    OP-CODE    *      RD       *       RT      *     RS/IMM    *
	*    [31:24]    *    [23:16]    *     [15:8]    *      [7:0]    *
	*****************************************************************
	*               *               *                *              *
	*    OPCODE     *    WRITEREG   *    READREG1   *    READREG2   *
	*               *               *               *   IMMEDIATE   *
	****************************************************************/
	
	assign IMMEDIATE = INSTRUCTION[7:0];
	assign READREG2 = INSTRUCTION[7:0];
	assign READREG1 = INSTRUCTION[15:8];
	assign WRITEREG = INSTRUCTION[23:16];
	
	//Decoding the instruction
	always @ ( INSTRUCTION )
	begin
	
		OPCODE = INSTRUCTION[31:24];	// Mapping the opcode field of the instruction to OPCODE
		
		#1			// 1 Time Unit Delay for Decoding process
		
		case ( OPCODE )
		
			// loadi instruction
			8'b00000000:	begin
								PositiveOrNegative = 1'b0;		// Set sign select MUX to positive sign
								ImmOrRegistered = 1'b1;			// Set immediate select MUX to select immediate value
								ALUOP = 3'b000;					// Set ALU to forward
								WRITEENABLE = 1'b1;				// Enable writing to register
							end
		
			// mov instruction
			8'b00000001:	begin
								PositiveOrNegative = 1'b0;		// Set sign select MUX to positive sign
								ImmOrRegistered = 1'b0;			// Set immediate select MUX to select register input
								ALUOP = 3'b000;					// Set ALU to FORWARD
								WRITEENABLE = 1'b1;				// Enable writing to register
							end
			
			// add instruction
			8'b00000010:	begin
								PositiveOrNegative = 1'b0;		// Set sign select MUX to positive sign
								ImmOrRegistered = 1'b0;			// Set immediate select MUX to select register input
								ALUOP = 3'b001;					// Set ALU to ADD
								WRITEENABLE = 1'b1;				// Enable writing to register
							end	
		
			// sub instruction
			8'b00000011:	begin
								PositiveOrNegative = 1'b1;		// Set sign select MUX to negative sign
								ImmOrRegistered = 1'b0;			// Set immediate select MUX to select register input
								ALUOP = 3'b001;					// Set ALU to ADD
								WRITEENABLE = 1'b1;				// Enable writing to register
							end

			// and instruction
			8'b00000100:	begin
								PositiveOrNegative = 1'b0;		// Set sign select MUX to positive sign
								ImmOrRegistered = 1'b0;			// Set immediate select MUX to select register input
								ALUOP = 3'b010;					// Set ALU to AND
								WRITEENABLE = 1'b1;				// Enable writing to register
							end
							
			// or operation
			8'b00000101:	begin
								PositiveOrNegative = 1'b0;		// Set sign select MUX to positive sign
								ImmOrRegistered = 1'b0;			// Set immediate select MUX to select register input
								ALUOP = 3'b011;					// Set ALU to OR
								WRITEENABLE = 1'b1;				// Enable writing to register
							end

			// Don't Cares as default values
            default:	begin
							PositiveOrNegative = 1'bx;
							ImmOrRegistered = 1'bx;				
							ALUOP = 3'bxxx;			
							WRITEENABLE = 1'bx;		
						end

		endcase
		
	end
	
endmodule


