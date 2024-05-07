/*
CO224: Computer Architecture 
Lab 05: Part-5				 
The Sub Module RshiftComb			 
Group - 12					 
*/

// RshiftComb module definition
module RshiftComb(out, a, b, c);

    // Begin port declaration
    input a, b, c;      // Declare inputs

    output out;         // Declare output
    // End of port declaration

    // Wires for intermediate outputs
    wire in1, in2;

    // Getting result using gate level modeling
    and (in1, !a, b);
    and (in2, a, c);
    or (out, in1, in2);

endmodule
