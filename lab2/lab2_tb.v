/* CSED273 lab1 experiment 1 */
/* lab1_1_tb.v */

`timescale 1ns / 1ps

module lab1_2_tb();
    wire outGT, outEQ, outLT;
    reg[1:0] A, B;

    wire expectedGT, expectedEQ, expectedLT;

    assign expectedGT = A > B;
    assign expectedEQ = A == B;
    assign expectedLT = A < B;
    
    lab2_1 MC(outGT, outEQ, outLT, A, B);
    
	/* Initialize A and B */
    initial begin
        A = 0;
        B = 0;
        #30 $finish;
    end
	
    always @(*) begin
		#1 A <= A + 1;
        if ((outGT == expectedGT) && (outEQ == expectedEQ) && (outLT == expectedLT)) begin
            $display("pass");
        end
        else begin
            $display("A: %d, B: %d", A, B);
            $display("outGT: %d / %d, outEQ: %d / %d, outLT: %d / %d", outGT, expectedGT, outEQ, expectedEQ, outLT, expectedLT);
        end
    end

    always @(*) begin
        #4 B <= B + 1;
    end

endmodule
