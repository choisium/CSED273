/* CSED273 lab6 experiment 3 */
/* lab6_3.v */

`timescale 1ps / 1fs

/* Implement 369 game counter (3, 6, 9, 13, 6, 9, 13, 6 ...)
 * You must first implement D flip-flop in lab6_ff.v
 * then you use D flip-flop of lab6_ff.v */
module counter_369(input reset_n, input clk, output [3:0] count);

    wire[3:0] d;
    wire[3:0] count_;
    wire q2q1, q3q2, q3_q2_, q3q2_;
    wire reset;

    and(q2q1, count[2], count[1]);
    and(q3q2, count[3], count[2]);
    and(q3_q2_, count_[3], count_[2]);
    and(q3q2_, count[3], count_[2]);

    or(d[3], q2q1, q3q2_);
    assign d[2] = count[0];
    or(d[1], q3q2, q3_q2_);
    or(d[0], count_[0], q3q2_);

    edge_trigger_D_FF DFF0(
        .reset_n(reset_n),
        .d(d[0]),
        .clk(clk),
        .q(count[0]),
        .q_(count_[0])
    );

    edge_trigger_D_FF DFF1(
        .reset_n(reset_n),
        .d(d[1]),
        .clk(clk),
        .q(count[1]),
        .q_(count_[1])
    );

    edge_trigger_D_FF DFF2(
        .reset_n(reset_n),
        .d(d[2]),
        .clk(clk),
        .q(count[2]),
        .q_(count_[2])
    );

    edge_trigger_D_FF DFF3(
        .reset_n(reset_n),
        .d(d[3]),
        .clk(clk),
        .q(count[3]),
        .q_(count_[3])
    );
	
endmodule
