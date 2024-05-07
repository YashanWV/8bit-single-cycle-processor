/*
Module  : Data Cache 
Author  : Isuru Nawinne, Kisaru Liyanage
Date    : 25/05/2020

Description	:

This file presents a skeleton implementation of the cache controller using a Finite State Machine model. Note that this code is not complete.
*/

`timescale 1ns/100ps

// cache_memory module definition
module instruction_cache (clock, reset, cpuBUSYWAIT, cpuREADINSTR, cpuADDRESS, imemBUSYWAIT, imemREAD, imemREADINSTRBLCK, imemADDRESS);

    // Begin the port declaration

    // Declaring clock and reset
    input clock, reset;

    // Declaring ports connects with the cpu
    input [9:0] cpuADDRESS;
    output reg [31:0] cpuREADINSTR;
    output reg cpuBUSYWAIT;

    // Declaring ports connects with the data memory
    input imemBUSYWAIT;
    input [127:0] imemREADINSTRBLCK;
    output reg imemREAD;
    output reg [5:0] imemADDRESS;

    /* Because of using an 8 bit memory address to access to the memeory
        offset = 2 bits (Because a block has 4 words(4 Bytes))
        index = 3 bits (Because the cache memory should be able to store 8 blocks)
        tag = 3 bits (8-2-3 = 3)
    */
    wire [1:0] Offset;                  // 2 bit bus for offset
    wire [2:0] Tag, Index;              // 3 bit busses for tag of address & index
    reg [2:0]cacheTag;                  // 3 bit bus for tag of cache block
    reg hit;                            // reg for hit deciding (1 if a hit and 0 if a miss)
    reg tagMatch;                       // A register for check weather tag is matching or not (1 if tag is match and 0 if not match)
    reg valid;                          // reg for store the valid bit
    reg update;                         // reg for store the update soignal
    reg readFromCache;                  // reg for  readFromCache signal
    reg hit_or_miss;                    // reg for hit or miss signal
    reg [31:0] words [3:0];              // A bus for store words

    // Data storing in the cache
    reg [7:0] cacheValid ;              // 8 bit valid bit array
    reg [7:0] cacheDirty ;              // 8 bit dirty bit array
    reg [2:0] cacheTags [7:0];          // 3*8 bit cache tag array
    reg [127:0] cacheData [7:0];         // 32*8 bit cache data array      

    /*
    Combinational part for indexing, tag comparison for hit deciding, etc.
    ...
    ...
    */

    // Splitting the 8 bit address into parts 
    // Add #1 time unit artificial latency for indexing
    assign  #1 Index = cpuADDRESS[6:4];
    assign  #1 Tag = cpuADDRESS[9:7];
    assign  #1 Offset = cpuADDRESS[3:2];

    // Asserting the cpuBUSYWAIT signal when a cpuREAD or a cpuWRITE signal is detected and deciding weather write to the cache or read to the cache
    always @(cpuADDRESS)
    begin 
        cpuBUSYWAIT = 1;
        #1
        readFromCache = 1;
    end

    // Set comparison signals
    always @(cacheValid, cacheDirty, Tag[Index], Index, posedge readFromCache)
    begin
        if (readFromCache)
        begin
            #1
            cacheTag = cacheTags[Index];
            valid = cacheValid[Index];
            hit_or_miss = 1;
        end
    end

    // Load the relavant data word according to the offset by overlapping with tag comparison
    // Add #1 time unit artificial latency for read operation
    always @(posedge readFromCache, cacheData[Index], Index, Offset)
    begin
        #1
        case ( Offset )
            2'b00:  cpuREADINSTR = cacheData[Index][31:0];
            2'b01:  cpuREADINSTR = cacheData[Index][63:32];
            2'b10:  cpuREADINSTR = cacheData[Index][95:64];
            2'b11:  cpuREADINSTR = cacheData[Index][127:96];
        endcase
    end

    // Resolving weather a hit or a miss
    always @(cacheTag, Tag, valid, posedge hit_or_miss) 
    begin
        hit_or_miss = 0;
        if (valid && (Tag == cacheTag))     // A hit
        begin
            #0.9 hit = 1;                   // make signal hit to 1
            cpuBUSYWAIT = 0;                // deassert the bussywait
            readFromCache = 0;              // deassert read from cache if a hit because they were overlapped (Reading already completed) 
        end
        else if (!valid || (Tag != cacheTag))       // Not a hit
        begin
            #0.9 hit = 0;                           // Make signal hit to zero
            imemREAD = 1;                               // If not dirty
            imemADDRESS = {Tag, Index};                 // Read from memory (assigning the block address)
        end
    end

    // update signal is used in FSM to indicate that the cache to be updated
    // when update signal changing from 1 to 0 cache is updating
    always @(negedge update) 
    begin
        #1 cacheData[Index] = imemREADINSTRBLCK;	// writing readed data from the memory to correct cache entry
        cacheValid[Index] = 1;	            // setting valid bit high
        cacheTags[Index] = Tag;		        // updating tag of cache entry
            
    end
        
    /* Cache Controller FSM Start */

    parameter IDLE = 3'b000, MEM_READ = 3'b001;
    reg [2:0] state, next_state;

    // combinational next state logic
    always @(hit,imemBUSYWAIT)
    begin
        case (state)
            IDLE:
                if (!hit)   
                    next_state = MEM_READ;
                else
                    next_state = IDLE;
            
            MEM_READ:
                if (!imemBUSYWAIT)
                    next_state = IDLE;
                else    
                    next_state = MEM_READ;
            
        endcase
    end

    // combinational output logic
    always @(state)
    begin
        case(state)
            IDLE:
            begin
                imemREAD = 0;
                imemADDRESS = 6'dx;
                cpuBUSYWAIT = 0;
                update = 0;
            end
         
            MEM_READ: 
            begin
                imemREAD = 1;
                imemADDRESS = {Tag, Index};
                cpuBUSYWAIT = 1;
                update = 1;
            end

        endcase
    end

    // sequential logic for state transitioning 
    integer i;
    always @(posedge clock, reset)
    begin
        if(reset)
        begin
            state = IDLE;
            for (i=0 ; i<7 ; i=i+1)
            begin
                cacheValid[i] = 0;
            end
        end
        else
            state = next_state;
    end

    /* Cache Controller FSM End */

endmodule