/* CSED273 lab5 experiment 1 */
/* lab5_1.v */

`timescale 1ps / 1fs

/* Implement adder 
 * You must not use Verilog arithmetic operators */
module adder(
    input [3:0] x,
    input [3:0] y,
    input c_in,             // Carry in
    output [3:0] out,
    output c_out            // Carry out
); 

    wire [3:0] p, g;
    wire [4:0] mid_c;
    wire mid0; wire [1:0] mid1; wire [2:0] mid2; wire [3:0] mid3;

    // calculate p_i and g_i
    xor(p[0], x[0], y[0]);
    xor(p[1], x[1], y[1]);
    xor(p[2], x[2], y[2]);
    xor(p[3], x[3], y[3]);

    and(g[0], x[0], y[0]);
    and(g[1], x[1], y[1]);
    and(g[2], x[2], y[2]);
    and(g[3], x[3], y[3]);

    // calculate c_1
    and(mid0, p[0], c_in);
    or(mid_c[0], mid0, g[0]);

    // calculate c_2
    and(mid1[0], p[1], p[0], c_in);
    and(mid1[1], p[1], g[0]);
    or(mid_c[1], mid1[0], mid1[1], g[1]);

    // calculate c_3
    and(mid2[0], p[2], p[1], p[0], c_in);
    and(mid2[1], p[2], p[1], g[0]);
    and(mid2[2], p[2], g[1]);
    or(mid_c[2], mid2[0], mid2[1], mid2[2], g[2]);

    // calculate c_4
    and(mid3[0], p[3], p[2], p[1], p[0], c_in);
    and(mid3[1], p[3], p[2], p[1], g[0]);
    and(mid3[2], p[3], p[2], g[1]);
    and(mid3[3], p[3], g[2]);
    or(c_out, mid3[0], mid3[1], mid3[2], mid3[3], g[3]);

    // calculate out_0 to out_3 and c_out
    xor(out[0], p[0], c_in);
    xor(out[1], p[1], mid_c[0]);
    xor(out[2], p[2], mid_c[1]);
    xor(out[3], p[3], mid_c[2]);

endmodule

/* Implement arithmeticUnit with adder module
 * You must not use Verilog arithmetic operators */
module arithmeticUnit(
    input [3:0] x,
    input [3:0] y,
    input [2:0] select,
    output [3:0] out,
    output c_out            // Carry out
);

    wire [3:0] not_y, s2noty, s1y, a;
    not(not_y[0], y[0]);
    not(not_y[1], y[1]);
    not(not_y[2], y[2]);
    not(not_y[3], y[3]);

    and(s1y[0], select[1], y[0]);
    and(s1y[1], select[1], y[1]);
    and(s1y[2], select[1], y[2]);
    and(s1y[3], select[1], y[3]);
    and(s2noty[0], select[2], not_y[0]);
    and(s2noty[1], select[2], not_y[1]);
    and(s2noty[2], select[2], not_y[2]);
    and(s2noty[3], select[2], not_y[3]);

    or(a[0], s2noty[0], s1y[0]);
    or(a[1], s2noty[1], s1y[1]);
    or(a[2], s2noty[2], s1y[2]);
    or(a[3], s2noty[3], s1y[3]);

    adder Adder(
        .x(a),
        .y(x),
        .c_in(select[0]),
        .out(out),
        .c_out(c_out)
    );

endmodule

/* Implement 4:1 mux */
module mux4to1(
    input [3:0] in,
    input [1:0] select,
    output out
);

    wire i0, i1, i2, i3;
    and(i0, ~select[1], ~select[0], in[0]);
    and(i1, ~select[1],  select[0], in[1]);
    and(i2, select[1], ~select[0], in[2]);
    and(i3, select[1],  select[0], in[3]);
    or(out, i0, i1, i2, i3);

endmodule

/* Implement logicUnit with mux4to1 */
module logicUnit(
    input [3:0] x,
    input [3:0] y,
    input [1:0] select,
    output [3:0] out
);

    wire [3:0] out_and, out_or, out_xor, out_not;

    and(out_and[0], x[0], y[0]);
    and(out_and[1], x[1], y[1]);
    and(out_and[2], x[2], y[2]);
    and(out_and[3], x[3], y[3]);

    or(out_or[0], x[0], y[0]);
    or(out_or[1], x[1], y[1]);
    or(out_or[2], x[2], y[2]);
    or(out_or[3], x[3], y[3]);

    xor(out_xor[0], x[0], y[0]);
    xor(out_xor[1], x[1], y[1]);
    xor(out_xor[2], x[2], y[2]);
    xor(out_xor[3], x[3], y[3]);

    not(out_not[0], x[0]);
    not(out_not[1], x[1]);
    not(out_not[2], x[2]);
    not(out_not[3], x[3]);

    mux4to1 Mux0(
        .in({out_not[0], out_xor[0], out_or[0], out_and[0]}),
        .select(select),
        .out(out[0])
    );

    mux4to1 Mux1(
        .in({out_not[1], out_xor[1], out_or[1], out_and[1]}),
        .select(select),
        .out(out[1])
    );

    mux4to1 Mux2(
        .in({out_not[2], out_xor[2], out_or[2], out_and[2]}),
        .select(select),
        .out(out[2])
    );

    mux4to1 Mux3(
        .in({out_not[3], out_xor[3], out_or[3], out_and[3]}),
        .select(select),
        .out(out[3])
    );

endmodule

/* Implement 2:1 mux */
module mux2to1(
    input [1:0] in,
    input  select,
    output out
);

    wire i0, i1;
    and(i0, ~select, in[0]);
    and(i1, select, in[1]);
    or(out, i0, i1);

endmodule

/* Implement ALU with mux2to1 */
module lab5_1(
    input [3:0] x,
    input [3:0] y,
    input [3:0] select,
    output [3:0] out,
    output c_out            // Carry out
);

    wire [3:0] logic_out, arith_out;

    logicUnit LogicUnit(
        .x(x),
        .y(y),
        .select(select[1:0]),
        .out(logic_out)
    );

    arithmeticUnit ArithmeticUnit(
        .x(x),
        .y(y),
        .select(select[2:0]),
        .c_out(c_out),
        .out(arith_out)
    );

    mux2to1 MUX0(
        .in({logic_out[0], arith_out[0]}),
        .select(select[3]),
        .out(out[0])
    );

    mux2to1 MUX1(
        .in({logic_out[1], arith_out[1]}),
        .select(select[3]),
        .out(out[1])
    );

    mux2to1 MUX2(
        .in({logic_out[2], arith_out[2]}),
        .select(select[3]),
        .out(out[2])
    );

    mux2to1 MUX3(
        .in({logic_out[3], arith_out[3]}),
        .select(select[3]),
        .out(out[3])
    );

endmodule
