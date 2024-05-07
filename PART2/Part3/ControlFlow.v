/*
CO224: Computer Architecture 
Lab 05: Part-4				 
The Sub Module PCadder			 
Group - 12					 
*/

`timescale 1ns/100ps

// control_flow module definition
module control_flow(BRANCH, ZERO, JUMP, FLOW_SELECT);

    // Begin port declaration
    input BRANCH, ZERO, JUMP;      // Declare input
    output FLOW_SELECT;            // Declare output
    // End of port declaration

    assign FLOW_SELECT = JUMP | (BRANCH & ZERO);    // A combinational logic to select the branch or jump insteructions to 1

endmodule