/*
Module  : Data Cache 
Author  : Isuru Nawinne, Kisaru Liyanage
Date    : 25/05/2020

Description	:

This file presents a skeleton implementation of the cache controller using a Finite State Machine model. Note that this code is not complete.
*/

`timescale 1ns/100ps

// cache_memory module definition
module data_cache (clock, reset, cpuBUSYWAIT, cpuREAD, cpuWRITE, cpuWRITEDATA, cpuREADDATA, cpuADDRESS, dmemBUSYWAIT, dmemREAD, dmemWRITE, dmemWRITEDATA, dmemREADDATA, dmemADDRESS);

    // Begin the port declaration

    // Declaring clock and reset
    input clock, reset;

    // Declaring ports connects with the cpu
    input cpuREAD, cpuWRITE;
    input [7:0] cpuWRITEDATA, cpuADDRESS;
    output reg [7:0] cpuREADDATA;
    output reg cpuBUSYWAIT;

    // Declaring ports connects with the data memory
    input dmemBUSYWAIT;
    input [31:0] dmemREADDATA;
    output reg dmemREAD, dmemWRITE;
    output reg [31:0] dmemWRITEDATA;
    output reg [5:0] dmemADDRESS;

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
    reg dirty;                          // wire for dirty bit (1 for set the dirty bit)
    reg writeToCache;                   // A register for set the condition for write data to cache
    reg valid;                          // reg for store the valid bit
    reg update;                         // reg for store the update soignal
    reg readFromCache;                  // reg for  readFromCache signal
    reg hit_or_miss;                    // reg for hit or miss signal
    reg [7:0] words [3:0];              // A bus for store words

    // Data storing in the cache
    reg [7:0] cacheValid ;              // 8 bit valid bit array
    reg [7:0] cacheDirty ;              // 8 bit dirty bit array
    reg [2:0] cacheTags [7:0];          // 3*8 bit cache tag array
    reg [31:0] cacheData [7:0];         // 32*8 bit cache data array      

    /*
    Combinational part for indexing, tag comparison for hit deciding, etc.
    ...
    ...
    */

    // Splitting the 8 bit address into parts 
    // Add #1 time unit artificial latency for indexing
    assign  #1 Index = cpuADDRESS[4:2];
    assign  #1 Tag = cpuADDRESS[7:5];
    assign  #1 Offset = cpuADDRESS[1:0];

    // Asserting the cpuBUSYWAIT signal when a cpuREAD or a cpuWRITE signal is detected and deciding weather write to the cache or read to the cache
    always @(posedge cpuREAD, posedge cpuWRITE)
    begin 
        cpuBUSYWAIT = 1;
        #1
        readFromCache = (cpuREAD && !cpuWRITE) ? 1 : 0;
        writeToCache = (!cpuREAD && cpuWRITE) ? 1 : 0;
    end

    // Set comparison signals
    always @(cacheValid, cacheDirty, Tag[Index], Index, posedge readFromCache, posedge writeToCache)
    begin
        if (readFromCache || writeToCache)
        begin
            #1
            cacheTag = cacheTags[Index];
            valid = cacheValid[Index];
            dirty = cacheDirty[Index];
            hit_or_miss = 1;
        end
    end

    // Load the relavant data word according to the offset by overlapping with tag comparison
    // Add #1 time unit artificial latency for read operation
    always @(posedge readFromCache, cacheData[Index], Index, Offset)
    begin
        #1
        case ( Offset )
            2'b00:  cpuREADDATA = cacheData[Index][7:0];
            2'b01:  cpuREADDATA = cacheData[Index][15:8];
            2'b10:  cpuREADDATA = cacheData[Index][23:16];
            2'b11:  cpuREADDATA = cacheData[Index][31:24];
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
            if (dirty)                                      // If dirty
            begin
                dmemWRITE = 1;                              // Write from memory
                dmemADDRESS = {cacheTag, Index};            // assigning the block address for memory read
                dmemWRITEDATA = cacheData[Index];           // assignig the data wich writng
            end
            else
            begin
                dmemREAD = 1;                               // If not dirty
                dmemADDRESS = {Tag, Index};                 // Read from memory (assigning the block address)
            end
        end
    end

    // Write data to relavant word of the relavant block in cache at the next positive clock edge according to the offset
    // Add #1 time unit artificial latency for the writing operation 
    always @(posedge clock) 
    begin
        if (hit && writeToCache)
        begin
            #1
            case ( Offset )
                2'b00 : cacheData[Index][7:0] = cpuWRITEDATA;
                2'b01 : cacheData[Index][15:8] = cpuWRITEDATA;
                2'b10 : cacheData[Index][23:16] = cpuWRITEDATA;
                2'b11 : cacheData[Index][31:24] = cpuWRITEDATA;
            endcase
            writeToCache = 0;           // Deassert write to cache signal after writing
            cacheDirty[Index] = 1;      // Set the dirty bit
        end
    end

    // update signal is used in FSM to indicate that the cache to be updated
    // when update signal changing from 1 to 0 cache is updating
    always @(negedge update) 
    begin
        #1 cacheData[Index] = dmemREADDATA;	// writing readed data from the memory to correct cache entry
        cacheValid[Index] = 1;	            // setting valid bit high
        cacheDirty[Index] = 0;	            // cache data is consistant with memory, make dirtybit low
        cacheTags[Index] = Tag;		        // updating tag of cache entry
            
    end
        
    /* Cache Controller FSM Start */

    parameter IDLE = 3'b000, MEM_READ = 3'b001, MEM_WRITE=3'b010;
    reg [2:0] state, next_state;

    // combinational next state logic
    always @(cpuREAD,cpuWRITE,dirty,hit,dmemBUSYWAIT)
    begin
        case (state)
            IDLE:
                if ((cpuREAD || cpuWRITE) && !dirty && !hit)   
                    next_state = MEM_READ;
                else if ((cpuREAD || cpuWRITE) && dirty && !hit)
                    next_state = MEM_WRITE;
                else
                    next_state = IDLE;
            
            MEM_READ:
                if (!dmemBUSYWAIT)
                    next_state = IDLE;
                else    
                    next_state = MEM_READ;

            MEM_WRITE:
                if (!dmemBUSYWAIT)
                    next_state = MEM_READ;
                else
                    next_state = MEM_WRITE; 
            
        endcase
    end

    // combinational output logic
    always @(state)
    begin
        case(state)
            IDLE:
            begin
                dmemREAD = 0;
                dmemWRITE = 0;
                dmemADDRESS = 6'dx;
                dmemWRITEDATA = 32'dx;
                cpuBUSYWAIT = 0;
                update = 0;
            end
         
            MEM_READ: 
            begin
                dmemREAD = 1;
                dmemWRITE = 0;
                dmemADDRESS = {Tag, Index};
                dmemWRITEDATA = 32'dx;
                cpuBUSYWAIT = 1;
                update = 1;
            end

            MEM_WRITE:
            begin
                dmemREAD = 0;
                dmemWRITE = 1;
                dmemADDRESS = {cacheTag, Index};
                dmemWRITEDATA = cacheData[Index];
                cpuBUSYWAIT = 1;
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
                cacheDirty[i] = 0;
            end
        end
        else
            state = next_state;
    end

    /* Cache Controller FSM End */

endmodule