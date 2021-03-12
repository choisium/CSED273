/* CSED273 lab1 experiment 1 */
/* lab1_1_tb.v */

`timescale 1ns / 1ps

module lab1_1_tb();
    wire out;
    reg A, B;
    integer count;
    
    lab1_1 AND(out, A,B);
    
	/* Initialize A and B */
    initial begin
        A = 1;
        B = 1;
		count = 0;
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

    always @(*) begin
        count = count + 1;
        if(out === A & B) $display("Count %d: Pass",count);
        else $display("Count %d: Fail (out: %b, expected: %b)", count, out, A&B);
    end

endmodule
