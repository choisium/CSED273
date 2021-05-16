/* CSED273 lab6 experiment 1 */
/* lab6_1.v */

`timescale 1ps / 1fs

/* Implement synchronous BCD decade counter (0-9)
 * You must use JK flip-flop of lab6_ff.v */
module decade_counter(input reset_n, input clk, output [3:0] count);

    wire[3:0] count_;
    wire[3:0] j, k;
    wire reset;

    and(j[3], count[2], count[1], count[0]);
    assign k[3] = count[0];
    and(j[2], count[1], count[0]);
    and(k[2], count[1], count[0]);
    and(j[1], count_[3], count[0]);
    assign k[1] = count[0];
    assign j[0] = 1;
    assign k[0] = 1;

    edge_trigger_JKFF JKFF0(
        .reset_n(reset_n),
        .j(j[0]),
        .k(k[0]),
        .clk(clk),
        .q(count[0]),
        .q_(count_[0])
    );

    edge_trigger_JKFF JKFF1(
        .reset_n(reset_n),
        .j(j[1]),
        .k(k[1]),
        .clk(clk),
        .q(count[1]),
        .q_(count_[1])
    );

    edge_trigger_JKFF JKFF2(
        .reset_n(reset_n),
        .j(j[2]),
        .k(k[2]),
        .clk(clk),
        .q(count[2]),
        .q_(count_[2])
    );

    edge_trigger_JKFF JKFF3(
        .reset_n(reset_n),
        .j(j[3]),
        .k(k[3]),
        .clk(clk),
        .q(count[3]),
        .q_(count_[3])
    );
	
endmodule