/* Negative edge triggered JK flip-flop */
module edge_trigger_JKFF(input reset_n, input j, input k, input clk, output reg q, output reg q_);  
    initial begin
      q = 0;
      q_ = ~q;
    end
    
    always @(negedge clk) begin
        q = reset_n & (j&~q | ~k&q);
        q_ = ~reset_n | ~q;
    end

endmodule

/* Negative edge triggered D flip-flop with edge_trigger_JKFF module */
module edge_trigger_D_FF(input reset_n, input d, input clk, output q, output q_);   

    wire d_;
    not(d_, d);

    edge_trigger_JKFF JKFF(
        .reset_n(reset_n),
        .j(d),
        .k(d_),
        .clk(clk),
        .q(q),
        .q_(q_)
    );
 
endmodule

/* 2:1 mux */
module mux2to1(
    input [1:0] in,
    input select,
    output out
);

    wire i0, i1;
    and(i0, ~select, in[0]);
    and(i1, select, in[1]);
    or(out, i0, i1);

endmodule

/* 4:1 mux */
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

/* 3-bit adder */
module adder(
    input [2:0] x,
    input [2:0] y,
    input c_in,             // Carry in
    output [2:0] out,
    output c_out            // Carry out
); 

    wire [2:0] p, g;
    wire [3:0] mid_c;
    wire mid0; wire [1:0] mid1; wire [2:0] mid2;

    // calculate p_i and g_i
    xor(p[0], x[0], y[0]);
    xor(p[1], x[1], y[1]);
    xor(p[2], x[2], y[2]);

    and(g[0], x[0], y[0]);
    and(g[1], x[1], y[1]);
    and(g[2], x[2], y[2]);

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
    or(c_out, mid2[0], mid2[1], mid2[2], g[2]);

    // calculate out_0 to out_2 and c_out
    xor(out[0], p[0], c_in);
    xor(out[1], p[1], mid_c[0]);
    xor(out[2], p[2], mid_c[1]);

endmodule