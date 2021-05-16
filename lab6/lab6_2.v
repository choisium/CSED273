/* CSED273 lab6 experiment 2 */
/* lab6_2.v */

`timescale 1ps / 1fs

/* Implement 2-decade BCD counter (0-99)
 * You must use decade BCD counter of lab6_1.v */
module decade_counter_2digits(input reset_n, input clk, output [7:0] count);

    wire reset, reset_clk, clk2;
    not(reset, reset_n);
    and(reset_clk, reset, clk);
    or(clk2, reset_clk, count[3]);

    decade_counter DC0(
        .reset_n(reset_n),
        .clk(clk),
        .count(count[3:0])
    );

    decade_counter DC1(
        .reset_n(reset_n),
        .clk(clk2),
        .count(count[7:4])
    );
	
endmodule
