
module button_module(
	button_up, button_down, button_in, position,
	ctrl_button_up, ctrl_button_down, ctrl_button_in
);

	input [2:0] button_up;
	input [2:0] button_down;
	input [3:0] button_in;
	input [1:0] position;

	output wire [2:0] ctrl_button_up;
	output wire [2:0] ctrl_button_down;
	output wire [2:0] ctrl_button_in;

	wire button_up_12;
	wire button_up_123;
	wire button_up_23;
	wire button_down_23;
	wire button_down_34;
	wire button_down_234;
	wire button_in_12;
	wire button_in_123;
	wire button_in_34;
	wire button_in_234;

	or(button_up_12, button_up[0], button_up[1]);
	or(button_up_123, button_up_12, button_up[2]);
	or(button_up_23, button_up[2], button_up[1]);

	or(button_down_23, button_down[0], button_down[1]);
	or(button_down_34, button_down[1], button_down[2]);
	or(button_down_234, button_down_34, button_down[0]);

	or(button_in_12, button_in[0], button_in[1]);
	or(button_in_123, button_in_12, button_in[2]);
	or(button_in_34, button_in[2], button_in[3]);
	or(button_in_234, button_in_34, button_in[1]);

	mux4to1 MUX_UP0({1'b0, button_up}, position, ctrl_button_up[0]);
	mux4to1 MUX_UP1({1'b0, 1'b0, button_up[2], button_up_23}, position, ctrl_button_up[1]);
	mux4to1 MUX_UP2({button_up_123, button_up_12, button_up[0], 1'b0}, position, ctrl_button_up[2]);

	mux4to1 MUX_DOWN0({button_down, 1'b0}, position, ctrl_button_down[0]);
	mux4to1 MUX_DOWN1({1'b0, button_down[2], button_down_34, button_down_234}, position, ctrl_button_down[1]);
	mux4to1 MUX_DOWN2({button_down_23, button_down[0], 1'b0, 1'b0}, position, ctrl_button_down[2]);

	mux4to1 MUX_IN0(button_in, position, ctrl_button_in[0]);
	mux4to1 MUX_IN1({1'b0, button_in[3], button_in_34, button_in_234}, position, ctrl_button_in[1]);
	mux4to1 MUX_IN2({button_in_123, button_in_12, button_in[0], 1'b0}, position, ctrl_button_in[2]);

endmodule

module reg_button_in_module(
    reset_n, button_in, pos, open,
    reg_button_in
);
    input reset_n;
    input [3:0] button_in;
    input [1:0] pos;
    input open;

    output [3:0] reg_button_in;

    wire [3:0] k;
    wire [1:0] pos_n;

    not(pos_n[0], pos[0]);
    not(pos_n[1], pos[1]);

    and(k[0], open, pos_n[1], pos_n[0]);
    and(k[1], open, pos_n[1], pos[0]);
    and(k[2], open, pos[1], pos_n[0]);
    and(k[3], open, pos[1], pos[0]);

    JKLatch JKL0(reset_n, button_in[0], k[0], reg_button_in[0], );
    JKLatch JKL1(reset_n, button_in[1], k[1], reg_button_in[1], );
    JKLatch JKL2(reset_n, button_in[2], k[2], reg_button_in[2], );
    JKLatch JKL3(reset_n, button_in[3], k[3], reg_button_in[3], );

endmodule