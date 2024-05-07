/*
CO224: Computer Architecture 
Lab 05: Part-4				 
The CPU module			 
Group - 12					 
*/

`include "Alu.v"
`include "Reg_file.v"
`include "2sComp.v"
`include "Mux.v"
`include "PcAdder.v"
`include "TargetAddress.v"
`include "ControlFlow.v"
`include "FlowControlMux.v"

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
	wire ZERO;
	
	// Connections for 2's Complemented MUX
	wire [7:0] TwosCompMuxOut;
	wire [7:0] TwosCompOperand;
	reg PositiveOrNegative;
	
	// Connections for immediate value MUX
	wire [7:0] IMMEDIATE;
	reg ImmOrRegistered;
	
	// PC value (Next instruction to be executed)
	wire [31:0] PC_inc;
	wire [31:0] PC_new;

	// Connections for Target address adder
	wire [31:0] TARGET_ADDR;
	wire [7:0] OFFSET;

	// Connections for flow control slect Combinational logic unit
	reg [1:0] BRANCH_SELECT;

	// connections for flow control select MUX
	wire FlowSelect;
	
	// OPCODE stored in CPU
	reg [7:0] OPCODE;
	
    // Instantiation of modules
	reg_file MyRegFile(ALURESULT, REGOUT1, REGOUT2, WRITEREG, READREG1, READREG2, WRITEENABLE, CLK, RESET);
    TwosComp MyTwosComp(REGOUT2, TwosCompOperand);
    mux TwosCompMux(REGOUT2, TwosCompOperand, PositiveOrNegative, TwosCompMuxOut);
    mux ImmediateMux(TwosCompMuxOut, IMMEDIATE, ImmOrRegistered, OPERAND2);
	alu MyAlu(REGOUT1, OPERAND2, ALURESULT, ALUOP, ZERO);
	PCadder MyPcAdder(PC,PC_inc);
	target_address MyTargetAddress(PC_inc,OFFSET,TARGET_ADDR);
	control_flow MyControlFlow(BRANCH_SELECT, ZERO, FlowSelect);
	flowMUX FlowControlMux(PC_inc, TARGET_ADDR, FlowSelect, PC_new);

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
		end
		else 
        begin
            #1 
            PC = PC_new;		// Else, write new PC value (Write to PC)
        end 
	end
	
	// The Instruction Format
	
	/****************************************************************
	*    OP-CODE    *      RD       *       RT      *     RS/IMM    *
	*    [31:24]    *    [23:16]    *     [15:8]    *      [7:0]    *
	*****************************************************************
	*               *               *               *               *
	*    OPCODE     *    WRITEREG   *    READREG1   *    READREG2   *
	*               *    OFFSET     *               *   IMMEDIATE   *
	****************************************************************/
	
	assign IMMEDIATE = INSTRUCTION[7:0];
	assign READREG2 = INSTRUCTION[7:0];
	assign READREG1 = INSTRUCTION[15:8];
	assign WRITEREG = INSTRUCTION[23:16];
	assign OFFSET = INSTRUCTION[23:16];
	
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
								BRANCH_SELECT = 2'b00;			// Not a Branch instruction
								WRITEENABLE = 1'b1;				// Enable writing to register
							end
		
			// mov instruction
			8'b00000001:	begin
								PositiveOrNegative = 1'b0;		// Set sign select MUX to positive sign
								ImmOrRegistered = 1'b0;			// Set immediate select MUX to select register input
								ALUOP = 3'b000;					// Set ALU to FORWARD
								BRANCH_SELECT = 2'b00;			// Not a Branch instruction
								WRITEENABLE = 1'b1;				// Enable writing to register
							end
			
			// add instruction
			8'b00000010:	begin
								PositiveOrNegative = 1'b0;		// Set sign select MUX to positive sign
								ImmOrRegistered = 1'b0;			// Set immediate select MUX to select register input
								ALUOP = 3'b001;					// Set ALU to ADD
								BRANCH_SELECT = 2'b00;			// Not a Branch instruction
								WRITEENABLE = 1'b1;				// Enable writing to register
							end	
		
			// sub instruction
			8'b00000011:	begin
								PositiveOrNegative = 1'b1;		// Set sign select MUX to negative sign
								ImmOrRegistered = 1'b0;			// Set immediate select MUX to select register input
								ALUOP = 3'b001;					// Set ALU to ADD	
								BRANCH_SELECT = 2'b00;			// Not a Branch instruction
								WRITEENABLE = 1'b1;				// Enable writing to register
							end

			// and instruction
			8'b00000100:	begin
								PositiveOrNegative = 1'b0;		// Set sign select MUX to positive sign
								ImmOrRegistered = 1'b0;			// Set immediate select MUX to select register input
								ALUOP = 3'b010;					// Set ALU to AND
								BRANCH_SELECT = 2'b00;			// Not a Branch instruction
								WRITEENABLE = 1'b1;				// Enable writing to register
							end
							
			// or operation
			8'b00000101:	begin
								PositiveOrNegative = 1'b0;		// Set sign select MUX to positive sign
								ImmOrRegistered = 1'b0;			// Set immediate select MUX to select register input
								ALUOP = 3'b011;					// Set ALU to OR
								BRANCH_SELECT = 2'b00;			// Not a Branch instruction
								WRITEENABLE = 1'b1;				// Enable writing to register
							end

			// jump instruction
			8'b00000110:	begin
								BRANCH_SELECT = 2'b01;			// A Jump instruction
								WRITEENABLE = 1'b0;				// Disable writing to register
							end

			// branch instruction
			8'b00000111:	begin
								PositiveOrNegative = 1'b1;		// Set sign select MUX to  negative sign
								ImmOrRegistered = 1'b0; 		// Set immediate select MUX to select negative input
								ALUOP = 3'b001; 				// Set ALU to ADD
								BRANCH_SELECT = 2'b10;			// A beq instruction
								WRITEENABLE = 1'b0;				// Disable writing to register
							end

			// bne instruction
			8'b00001000:	begin
								PositiveOrNegative = 1'b1;		// Set sign select MUX to  negative sign
								ImmOrRegistered = 1'b0; 		// Set immediate select MUX to select negative input
								ALUOP = 3'b001; 				// Set ALU to ADD
								BRANCH_SELECT = 2'b11;			// A bne instruction
								WRITEENABLE = 1'b0;				// Disable writing to register
							end

			// mult instruction
			8'b00001001:	begin
								PositiveOrNegative = 1'b0;		// Set sign select MUX to positive sign
								ImmOrRegistered = 1'b0;			// Set immediate select MUX to select register input
								ALUOP = 3'b100;					// Set ALU to MULT
								BRANCH_SELECT = 2'b00;			// Not a Branch instruction
								WRITEENABLE = 1'b1;				// Enable writing to register
							end

			// shift or rotate
			8'b00001010:	begin
								PositiveOrNegative = 1'b0;		// Set sign select MUX to positive sign
								ImmOrRegistered = 1'b1;			// Set immediate select MUX to select immediate value
								ALUOP = 3'b101;					// Set ALU to SHIFT_ROTATE
								BRANCH_SELECT = 2'b00;			// Not a Branch instruction
								WRITEENABLE = 1'b1;				// Enable writing to register
							end

			// Don't Cares as default values
            default:	begin
							PositiveOrNegative = 1'bx;
							ImmOrRegistered = 1'bx;				
							ALUOP = 3'bxxx;	
							BRANCH_SELECT = 2'bxx;			
							WRITEENABLE = 1'bx;		
						end

		endcase
		
	end
	
endmodule


