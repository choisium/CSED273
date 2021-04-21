/* CSED273 lab4 experiment 4 */
/* lab4_4.v */

/* Implement 5x3 Binary Mutliplier
 * You must use lab4_2 module in lab4_2.v
 * You cannot use fullAdder or halfAdder module directly
 * You may use keword "assign" and operator "&","|","~",
 * or just implement with gate-level modeling (and, or, not) */
module lab4_4(
    input [4:0]in_a,
    input [2:0]in_b,
    output [7:0]out_m
    );

    wire[4:0] pp0, pp1, pp2, mid_m;
    wire mid_c;

    // partial product
    assign pp0 = {in_a[4]&in_b[0], in_a[3]&in_b[0], in_a[2]&in_b[0], in_a[1]&in_b[0], in_a[0]&in_b[0]};
    assign pp1 = {in_a[4]&in_b[1], in_a[3]&in_b[1], in_a[2]&in_b[1], in_a[1]&in_b[1], in_a[0]&in_b[1]};
    assign pp2 = {in_a[4]&in_b[2], in_a[3]&in_b[2], in_a[2]&in_b[2], in_a[1]&in_b[2], in_a[0]&in_b[2]};
    
    // get m1
    assign out_m[0] = pp0[0];
    assign out_m[1] = mid_m[0];

    lab4_2 RippleAdder1(
        .in_a({1'b0, pp0[4:1]}),
        .in_b(pp1),
        .in_c(1'b0),
        .out_c(mid_c),
        .out_s(mid_m)
    );
    lab4_2 RippleAdder2(
        .in_a({mid_c, mid_m[4:1]}),
        .in_b(pp2),
        .in_c(1'b0),
        .out_c(out_m[7]),
        .out_s(out_m[6:2])
    );
    
endmodule