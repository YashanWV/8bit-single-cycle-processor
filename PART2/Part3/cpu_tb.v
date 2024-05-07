// Computer Architecture (CO224) - Lab 05
// Design: Testbench of Integrated CPU of Simple Processor
// Author: Isuru Nawinne

`timescale 1ns/100ps

`include "cpu.v"
`include "data_memory.v"
`include "data_cache.v"
`include "instruction_memory.v"
`include "instruction_cache.v"


module cpu_tb;

    reg CLK, RESET;
    wire [31:0] PC;
    wire [31:0] INSTRUCTION;
    
    wire cpuREAD, cpuWRITE, cpuBUSYWAIT;
    wire dmemREAD, dmemWRITE, dmemBUSYWAIT;

    wire [7:0] cpuADDRESS, cpuREADDATA, cpuWRITEDATA;
    wire [31:0] dmemREADDATA, dmemWRITEDATA;
    wire [5:0] dmemADDRESS;

    wire imemREAD, imemBUSYWAIT;
    wire [5:0] imemADDRESS;
    wire [127:0] imemREADINSTR;

    wire instrBUSYWAIT;
    
    /* 
    ------------------------
     SIMPLE INSTRUCTION MEM
    ------------------------
    */
    
    // TODO: Initialize an array of registers (8x1024) named 'instr_mem' to be used as instruction memory
    // reg [7:0] instr_mem [1023:0];
    
    // TODO: Create combinational logic to support CPU instruction fetching, given the Program Counter(PC) value 
    //       (make sure you include the delay for instruction fetching here)
    // assign #2 INSTRUCTION = {instr_mem[PC+3], instr_mem[PC+2], instr_mem[PC+1], instr_mem[PC]};

    // initial
    // begin
        // Initialize instruction memory with the set of instructions you need execute on CPU
        
        // METHOD 1: manually loading instructions to instr_mem
        //{instr_mem[10'd3], instr_mem[10'd2], instr_mem[10'd1], instr_mem[10'd0]} = 32'b00000000000001000000000000000101;
        //{instr_mem[10'd7], instr_mem[10'd6], instr_mem[10'd5], instr_mem[10'd4]} = 32'b00000000000000100000000000001001;
        //{instr_mem[10'd11], instr_mem[10'd10], instr_mem[10'd9], instr_mem[10'd8]} = 32'b00000010000001100000010000000010;
        
        // METHOD 2: loading instr_mem content from instr_mem.mem file
        //$readmemb("instr_mem.mem", instr_mem);
    // end
    
    /*
	------------
	DATA MEMORY
	------------
    */
	data_memory my_data_memory(CLK, RESET, dmemREAD, dmemWRITE, dmemADDRESS, dmemWRITEDATA, dmemREADDATA, dmemBUSYWAIT);

    /*
	----------
	DATA CACHE
	----------
    */
    data_cache my_data_cache(CLK, RESET, cpuBUSYWAIT, cpuREAD, cpuWRITE, cpuWRITEDATA, cpuREADDATA, cpuADDRESS, dmemBUSYWAIT, dmemREAD, dmemWRITE, dmemWRITEDATA, dmemREADDATA, dmemADDRESS);

    /*
	------------------
	INSTRUCTION MEMORY
	------------------
    */
    instruction_memory my_instruction_memory(CLK, imemREAD, imemADDRESS, imemREADINSTR, imemBUSYWAIT);

    /*
	-----------------
	INSTRUCTION CACHE
	-----------------
    */
    instruction_cache myicache(CLK, RESET, instrBUSYWAIT, INSTRUCTION, PC[9:0], imemBUSYWAIT, imemREAD, imemREADINSTR, imemADDRESS);

    /* 
    -----
     CPU
    -----
    */
    cpu mycpu(PC, INSTRUCTION, CLK, RESET, cpuREAD, cpuWRITE, cpuADDRESS, cpuWRITEDATA, cpuREADDATA, cpuBUSYWAIT, instrBUSYWAIT);

    initial
    begin
    
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("cpu_wavedata.vcd");
		$dumpvars(0, cpu_tb);
        CLK = 1'b0;
        RESET = 1'b0;
        
        // TODO: Reset the CPU (by giving a pulse to RESET signal) to start the program execution
        RESET = 1'b1;
		#5
		RESET = 1'b0;
        
        // finish simulation after some time
        #5000
        $finish;
        
    end
    
    // clock signal generation
    always
        #4 CLK = ~CLK;
        

endmodule