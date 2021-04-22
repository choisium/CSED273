/* CSED273 lab4 experiment 1 */
/* lab4_1.v */


/* Implement Half Adder
 * You may use keword "assign" and operator "&","|","~",
 * or just implement with gate-level modeling (and, or, not) */
module halfAdder(
    input in_a,
    input in_b,
    output out_s,
    output out_c
    );

//    assign out_c = in_a & in_b;
//    assign out_s = (~in_a & in_b) | (in_a & ~in_b);
    and(out_c, in_a, in_b);
    xor(out_s, in_a, in_b);

endmodule

/* Implement Full Adder
 * You must use halfAdder module
 * You may use keword "assign" and operator "&","|","~",
 * or just implement with gate-level modeling (and, or, not) */
module fullAdder(
    input in_a,
    input in_b,
    input in_c,
    output out_s,
    output out_c
    );

    wire a_xor_b, a_and_b, a_xor_b_and_c;

    assign out_c = a_xor_b_and_c | a_and_b;

    halfAdder HA1(
        .in_a(in_a),
        .in_b(in_b),
        .out_s(a_xor_b),
        .out_c(a_and_b)
    );

    halfAdder HA2(
        .in_a(a_xor_b),
        .in_b(in_c),
        .out_s(out_s),
        .out_c(a_xor_b_and_c)
    );

endmodule