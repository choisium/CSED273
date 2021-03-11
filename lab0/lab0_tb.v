`timescale 1ns / 1ps

module lab0_tb();
    wire out;
    reg A, B;
    integer count;
    
    lab0 or_gate(out, A, B);
    
    initial begin
        A = 0;
        B = 0;
        count = 0;
        #10 $finish;
    end
    always @(*) begin
        count = count + 1;
        if(out === B) $display("Count %d: Pass",count);
        else $display("Count %d: Fail", count);
    end
    always begin
        #1 A <= !A;
    end
endmodule

