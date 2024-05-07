/*
CO224: Computer Architecture 
Lab 05: Part-5				 
The Sub Module SHIFT_ROTATE			 
Group - 12					 
*/

`include "LshiftComb.v"
`include "RshiftComb.v"

// SHIFT module definition
module SHIFT_ROTATE(OPERAND1 , OPERAND2 , RESULT);

	// Begin port declaration
    input [7:0] OPERAND1, OPERAND2;     // Declare inputs
	
    output reg [7:0] RESULT;              // Declare output
    // End of port declaration
    
	// Intermediate connections between Steps 
    wire [7:0] Intermediate1 [2:0];
    wire [7:0] Intermediate2 [2:0];
    wire [7:0] Intermediate3 [2:0];
    wire [7:0] Intermediate4 [2:0];

    /* Changing the operation by 2 most significand bits of the immediate value.
       Because we can use only the 3 lsbs of immediate value for the shift & rotate operations.
        if
        00 -> sll
        01 -> srl
        10 -> sra
        11 -> ror
    */

    /* Logical Shift left operation */

    // sllstep0
    LshiftComb sllstep00(Intermediate1[0][0], OPERAND2[0], 1'b0, OPERAND1[0]);
    LshiftComb sllstep01(Intermediate1[0][1], OPERAND2[0], OPERAND1[0], OPERAND1[1]);
    LshiftComb sllstep02(Intermediate1[0][2], OPERAND2[0], OPERAND1[1], OPERAND1[2]);
    LshiftComb sllstep03(Intermediate1[0][3], OPERAND2[0], OPERAND1[2], OPERAND1[3]);
    LshiftComb sllstep04(Intermediate1[0][4], OPERAND2[0], OPERAND1[3], OPERAND1[4]);
    LshiftComb sllstep05(Intermediate1[0][5], OPERAND2[0], OPERAND1[4], OPERAND1[5]);
    LshiftComb sllstep06(Intermediate1[0][6], OPERAND2[0], OPERAND1[5], OPERAND1[6]);
    LshiftComb sllstep07(Intermediate1[0][7], OPERAND2[0], OPERAND1[6], OPERAND1[7]);
    
    // sllstep 1
    LshiftComb sllstep10(Intermediate1[1][0], OPERAND2[1], 1'b0, Intermediate1[0][0]);    
    LshiftComb sllstep11(Intermediate1[1][1], OPERAND2[1], 1'b0, Intermediate1[0][1]);
    LshiftComb sllstep12(Intermediate1[1][2], OPERAND2[1], Intermediate1[0][0], Intermediate1[0][2]);
    LshiftComb sllstep13(Intermediate1[1][3], OPERAND2[1], Intermediate1[0][1], Intermediate1[0][3]);
    LshiftComb sllstep14(Intermediate1[1][4], OPERAND2[1], Intermediate1[0][2], Intermediate1[0][4]);
    LshiftComb sllstep15(Intermediate1[1][5], OPERAND2[1], Intermediate1[0][3], Intermediate1[0][5]);
    LshiftComb sllstep16(Intermediate1[1][6], OPERAND2[1], Intermediate1[0][4], Intermediate1[0][6]);
    LshiftComb sllstep17(Intermediate1[1][7], OPERAND2[1], Intermediate1[0][5], Intermediate1[0][7]);
    
    // sllstep 2
    LshiftComb sllstep20(Intermediate1[2][0], OPERAND2[2], 1'b0,Intermediate1[1][0]);    
    LshiftComb sllstep21(Intermediate1[2][1], OPERAND2[2], 1'b0,Intermediate1[1][1]);
    LshiftComb sllstep22(Intermediate1[2][2], OPERAND2[2], 1'b0,Intermediate1[1][2]);
    LshiftComb sllstep23(Intermediate1[2][3], OPERAND2[2], 1'b0,Intermediate1[1][3]);
    LshiftComb sllstep24(Intermediate1[2][4], OPERAND2[2],Intermediate1[1][0], Intermediate1[1][4]);
    LshiftComb sllstep25(Intermediate1[2][5], OPERAND2[2],Intermediate1[1][1], Intermediate1[1][5]);
    LshiftComb sllstep26(Intermediate1[2][6], OPERAND2[2],Intermediate1[1][2], Intermediate1[1][6]);
    LshiftComb sllstep27(Intermediate1[2][7], OPERAND2[2],Intermediate1[1][3], Intermediate1[1][7]);

    /* Logical Shift Right Operation */

    // srlstep0
    RshiftComb srlstep00(Intermediate2[0][0], OPERAND2[0], OPERAND1[0], OPERAND1[1]);
    RshiftComb srlstep01(Intermediate2[0][1], OPERAND2[0], OPERAND1[1], OPERAND1[2]);
    RshiftComb srlstep02(Intermediate2[0][2], OPERAND2[0], OPERAND1[2], OPERAND1[3]);
    RshiftComb srlstep03(Intermediate2[0][3], OPERAND2[0], OPERAND1[3], OPERAND1[4]);
    RshiftComb srlstep04(Intermediate2[0][4], OPERAND2[0], OPERAND1[4], OPERAND1[5]);
    RshiftComb srlstep05(Intermediate2[0][5], OPERAND2[0], OPERAND1[5], OPERAND1[6]);
    RshiftComb srlstep06(Intermediate2[0][6], OPERAND2[0], OPERAND1[6], OPERAND1[7]);
    RshiftComb srlstep07(Intermediate2[0][7], OPERAND2[0], OPERAND1[7], 1'b0);
    
    // srlstep 1
    RshiftComb srlstep10(Intermediate2[1][0], OPERAND2[1], Intermediate2[0][0], Intermediate2[0][2]);    
    RshiftComb srlstep11(Intermediate2[1][1], OPERAND2[1], Intermediate2[0][1], Intermediate2[0][3]);
    RshiftComb srlstep12(Intermediate2[1][2], OPERAND2[1], Intermediate2[0][2], Intermediate2[0][4]);
    RshiftComb srlstep13(Intermediate2[1][3], OPERAND2[1], Intermediate2[0][3], Intermediate2[0][5]);
    RshiftComb srlstep14(Intermediate2[1][4], OPERAND2[1], Intermediate2[0][4], Intermediate2[0][6]);
    RshiftComb srlstep15(Intermediate2[1][5], OPERAND2[1], Intermediate2[0][5], Intermediate2[0][7]);
    RshiftComb srlstep16(Intermediate2[1][6], OPERAND2[1], Intermediate2[0][6], 1'b0);
    RshiftComb srlstep17(Intermediate2[1][7], OPERAND2[1], Intermediate2[0][2], 1'b0);
    
    // srlstep 2
    RshiftComb srlstep20(Intermediate2[2][0], OPERAND2[2], Intermediate2[1][0], Intermediate2[1][4]);    
    RshiftComb srlstep21(Intermediate2[2][1], OPERAND2[2], Intermediate2[1][1], Intermediate2[1][5]);
    RshiftComb srlstep22(Intermediate2[2][2], OPERAND2[2], Intermediate2[1][2], Intermediate2[1][6]);
    RshiftComb srlstep23(Intermediate2[2][3], OPERAND2[2], Intermediate2[1][3], Intermediate2[1][7]);
    RshiftComb srlstep24(Intermediate2[2][4], OPERAND2[2], Intermediate2[1][4], 1'b0);
    RshiftComb srlstep25(Intermediate2[2][5], OPERAND2[2], Intermediate2[1][5], 1'b0);
    RshiftComb srlstep26(Intermediate2[2][6], OPERAND2[2], Intermediate2[1][6], 1'b0);
    RshiftComb srlstep27(Intermediate2[2][7], OPERAND2[2], Intermediate2[1][7], 1'b0);

    /* Arithmetic Shift Right Operation */

    // srastep0
    RshiftComb srastep00(Intermediate3[0][0], OPERAND2[0], OPERAND1[0], OPERAND1[1]);
    RshiftComb srastep01(Intermediate3[0][1], OPERAND2[0], OPERAND1[1], OPERAND1[2]);
    RshiftComb srastep02(Intermediate3[0][2], OPERAND2[0], OPERAND1[2], OPERAND1[3]);
    RshiftComb srastep03(Intermediate3[0][3], OPERAND2[0], OPERAND1[3], OPERAND1[4]);
    RshiftComb srastep04(Intermediate3[0][4], OPERAND2[0], OPERAND1[4], OPERAND1[5]);
    RshiftComb srastep05(Intermediate3[0][5], OPERAND2[0], OPERAND1[5], OPERAND1[6]);
    RshiftComb srastep06(Intermediate3[0][6], OPERAND2[0], OPERAND1[6], OPERAND1[7]);
    RshiftComb srastep07(Intermediate3[0][7], OPERAND2[0], OPERAND1[7], OPERAND1[7]);
    
    // srastep 1
    RshiftComb srastep10(Intermediate3[1][0], OPERAND2[1], Intermediate3[0][0], Intermediate3[0][2]);    
    RshiftComb srastep11(Intermediate3[1][1], OPERAND2[1], Intermediate3[0][1], Intermediate3[0][3]);
    RshiftComb srastep12(Intermediate3[1][2], OPERAND2[1], Intermediate3[0][2], Intermediate3[0][4]);
    RshiftComb srastep13(Intermediate3[1][3], OPERAND2[1], Intermediate3[0][3], Intermediate3[0][5]);
    RshiftComb srastep14(Intermediate3[1][4], OPERAND2[1], Intermediate3[0][4], Intermediate3[0][6]);
    RshiftComb srastep15(Intermediate3[1][5], OPERAND2[1], Intermediate3[0][5], Intermediate3[0][7]);
    RshiftComb srastep16(Intermediate3[1][6], OPERAND2[1], Intermediate3[0][6], OPERAND1[7]);
    RshiftComb srastep17(Intermediate3[1][7], OPERAND2[1], Intermediate3[0][2], OPERAND1[7]);
    
    // srastep 2
    RshiftComb srastep20(Intermediate3[2][0], OPERAND2[2], Intermediate3[1][0], Intermediate3[1][4]);    
    RshiftComb srastep21(Intermediate3[2][1], OPERAND2[2], Intermediate3[1][1], Intermediate3[1][5]);
    RshiftComb srastep22(Intermediate3[2][2], OPERAND2[2], Intermediate3[1][2], Intermediate3[1][6]);
    RshiftComb srastep23(Intermediate3[2][3], OPERAND2[2], Intermediate3[1][3], Intermediate3[1][7]);
    RshiftComb srastep24(Intermediate3[2][4], OPERAND2[2], Intermediate3[1][4], OPERAND1[7]);
    RshiftComb srastep25(Intermediate3[2][5], OPERAND2[2], Intermediate3[1][5], OPERAND1[7]);
    RshiftComb srastep26(Intermediate3[2][6], OPERAND2[2], Intermediate3[1][6], OPERAND1[7]);
    RshiftComb srastep27(Intermediate3[2][7], OPERAND2[2], Intermediate3[1][7], OPERAND1[7]);

    /* Rotate Right operation */

    // rorstep0
    RshiftComb rorstep00(Intermediate4[0][0], OPERAND2[0], OPERAND1[0], OPERAND1[1]);
    RshiftComb rorstep01(Intermediate4[0][1], OPERAND2[0], OPERAND1[1], OPERAND1[2]);
    RshiftComb rorstep02(Intermediate4[0][2], OPERAND2[0], OPERAND1[2], OPERAND1[3]);
    RshiftComb rorstep03(Intermediate4[0][3], OPERAND2[0], OPERAND1[3], OPERAND1[4]);
    RshiftComb rorstep04(Intermediate4[0][4], OPERAND2[0], OPERAND1[4], OPERAND1[5]);
    RshiftComb rorstep05(Intermediate4[0][5], OPERAND2[0], OPERAND1[5], OPERAND1[6]);
    RshiftComb rorstep06(Intermediate4[0][6], OPERAND2[0], OPERAND1[6], OPERAND1[7]);
    RshiftComb rorstep07(Intermediate4[0][7], OPERAND2[0], OPERAND1[7], OPERAND1[0]);
    
    // rorstep 1
    RshiftComb rorstep10(Intermediate4[1][0], OPERAND2[1], Intermediate4[0][0], Intermediate4[0][2]);    
    RshiftComb rorstep11(Intermediate4[1][1], OPERAND2[1], Intermediate4[0][1], Intermediate4[0][3]);
    RshiftComb rorstep12(Intermediate4[1][2], OPERAND2[1], Intermediate4[0][2], Intermediate4[0][4]);
    RshiftComb rorstep13(Intermediate4[1][3], OPERAND2[1], Intermediate4[0][3], Intermediate4[0][5]);
    RshiftComb rorstep14(Intermediate4[1][4], OPERAND2[1], Intermediate4[0][4], Intermediate4[0][6]);
    RshiftComb rorstep15(Intermediate4[1][5], OPERAND2[1], Intermediate4[0][5], Intermediate4[0][7]);
    RshiftComb rorstep16(Intermediate4[1][6], OPERAND2[1], Intermediate4[0][6], Intermediate4[0][0]);
    RshiftComb rorstep17(Intermediate4[1][7], OPERAND2[1], Intermediate4[0][2], Intermediate4[0][1]);
    
    // rorstep 2
    RshiftComb rorstep20(Intermediate4[2][0], OPERAND2[2], Intermediate4[1][0], Intermediate4[1][4]);    
    RshiftComb rorstep21(Intermediate4[2][1], OPERAND2[2], Intermediate4[1][1], Intermediate4[1][5]);
    RshiftComb rorstep22(Intermediate4[2][2], OPERAND2[2], Intermediate4[1][2], Intermediate4[1][6]);
    RshiftComb rorstep23(Intermediate4[2][3], OPERAND2[2], Intermediate4[1][3], Intermediate4[1][7]);
    RshiftComb rorstep24(Intermediate4[2][4], OPERAND2[2], Intermediate4[1][4], Intermediate4[1][0]);
    RshiftComb rorstep25(Intermediate4[2][5], OPERAND2[2], Intermediate4[1][5], Intermediate4[1][1]);
    RshiftComb rorstep26(Intermediate4[2][6], OPERAND2[2], Intermediate4[1][6], Intermediate4[1][2]);
    RshiftComb rorstep27(Intermediate4[2][7], OPERAND2[2], Intermediate4[1][7], Intermediate4[1][3]);
    
    always @*
    begin
        if (OPERAND2[7:6] == 2'b00)
        begin
        if (OPERAND2[5:0] > 6'd7)
            #2 RESULT <= 8'd0;
        else
            #2 RESULT <= Intermediate1[2];
        end
        else if (OPERAND2[7:6] == 2'b01)
        begin
        if (OPERAND2[5:0] > 6'd7)
            #2 RESULT <= 8'd0;
        else
            #2 RESULT <= Intermediate2[2];
        end
        else if (OPERAND2[7:6] == 2'b10)
        begin
        if (OPERAND2[5:0] > 6'd7)
            #2 RESULT <= {8{OPERAND1[7]}};
        else
            #2 RESULT <= Intermediate3[2];
        end
        else if (OPERAND2[7:6] == 2'b11)
        begin
            #2 RESULT <= Intermediate4[2];
        end
    end
    
endmodule


        
            