/* CSED273 lab1 experiment 1 */
/* lab1_1_tb.v */

`timescale 1ns / 1ps

module lab1_2_tb();
    wire and3, or3, not3;
    reg A, B;
    
//    lab1_2_ii OR(or3, A, B);
    lab1_2_iv NOR(and3, or3, not3, A, B);
    
	/* Initialize A and B */
    initial begin
        A = 0;
        B = 0;
        #10 $finish;
    end
	
	/* Flip A every 1ns */
    always begin
		#1 A <= !A;
    end
	
	/* Flip B every 2ns */
    always begin
        #2 B <= !B;
    end

endmodule
