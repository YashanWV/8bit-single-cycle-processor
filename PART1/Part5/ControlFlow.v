/*
CO224: Computer Architecture 
Lab 05: Part-4				 
The Sub Module PCadder			 
Group - 12					 
*/

// control_flow module definition
module control_flow(BRANCH_SELECT, ZERO, FLOW_SELECT);

    // Begin port declaration
    input ZERO;      // Declare inputs
    input [1:0] BRANCH_SELECT;
    output FLOW_SELECT;            // Declare output
    // End of port declaration

    assign FLOW_SELECT = ((~BRANCH_SELECT[1]) & BRANCH_SELECT[0]) | (BRANCH_SELECT[1] & (BRANCH_SELECT[0] ^ ZERO));     // A combinational logic to select the branch or jump insteructions to 1

endmodule