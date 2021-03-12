/* CSED273 lab1 experiment 1 */
/* lab1_1_tb.v */

`timescale 1ns / 1ps

module lab1_2_tb();
    wire and1;
    wire or2;
    wire and3, or3, not3;
    wire and4, or4, not4;
    reg A, B;
    integer count;
    
    lab1_2_i AND2(and1, A, B);
    lab1_2_ii OR2(or2, A, B);
    lab1_2_iii NAND(and3, or3, not3, A, B);
    lab1_2_iv NOR(and4, or4, not4, A, B);
    
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
