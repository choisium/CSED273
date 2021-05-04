/* CSED273 lab5 experiment 2 */
/* lab5_2.v */

`timescale 1ns / 1ps

/* Implement srLatch */
module srLatch(
    input s, r,
    output q, q_
    );

    nor(q, r, q_);
    nor(q_, s, q);

endmodule

/* Implement master-slave JK flip-flop with srLatch module */
module lab5_2(
    input reset_n, j, k, clk,
    output q, q_
    );

    wire clk_, reset;
    wire j1, k1, j2, k2;

    wire s_master, r_master, p, p_;

    not(clk_, clk);
    not(reset, reset_n);

    and(s_master, j, q_, clk);
    and(r_master, k, q, clk);

    and(j1, reset_n, s_master);
    or(k1, reset, r_master);

    and(j2, p, clk_);
    and(k2, p_, clk_);

    srLatch MasterLatch(
        .s(j1),
        .r(k1),
        .q(p),
        .q_(p_)
    );

    srLatch slaveLatch(
        .s(j2),
        .r(k2),
        .q(q),
        .q_(q_)
    );
    
endmodule