`timescale 1ns / 1ps

module elevator(
    reset_n, clk, button_up, button_down, button_in,
    position, open, direction
    );

	input reset_n;
	input clk;
	input [2:0] button_up;		// [0]: 1st floor, [1]: 2nd floor, [2]: 3rd floor
	input [2:0] button_down;	// [0]: 2nd floor, [1]: 3rd floor, [2]: 4th floor
	input [3:0] button_in;		// [0]: 1st floor, [1]: 2nd floor, [2]: 3rd floor, [3]: 4th floor
	output [2:0] position;		// 1st floor: 000, between 1 and 2: 001, 2nd floor: 010, between 2 and 3: 011, ...
	output open;				// close: 0, open: 1
	output [1:0] direction;		// stop: 00, up: 01, down: 10

	edge_trigger_D_FF DFF_pos0(reset_n, pos_nxt[0], clk, position[0], );
	edge_trigger_D_FF DFF_pos1(reset_n, pos_nxt[1], clk, position[1], );
	edge_trigger_D_FF DFF_pos2(reset_n, pos_nxt[2], clk, position[2], );
	edge_trigger_D_FF DFF_open0(reset_n, open_nxt, clk, open, );
	edge_trigger_D_FF DFF_dir0(reset_n, dir_nxt[0], clk, direction[0], );
	edge_trigger_D_FF DFF_dir1(reset_n, dir_nxt[1], clk, direction[1], );

	wire [2:0] ctrl_button_up;		// [0]: i, [1]: >i, [2]: <i
	wire [2:0] ctrl_button_down;	// [0]: i, [1]: >i, [2]: <i
	wire [2:0] ctrl_button_in;		// [0]: i, [1]: >i, [2]: <i

	wire [2:0] ctrl_position;		// stay: 00, move up: 01, move down: 10

	button_module ButtonModule(button_up, button_down, button_in, position[2:1], ctrl_button_up, ctrl_button_down, ctrl_button_in);

	// calculate next states from each states
	wire [1:0] fsc_pos_nxt, fsc_dir_nxt;
	wire fsc_open_nxt;
	full_stop_close_controller FSC(ctrl_button_up, ctrl_button_down, ctrl_button_in, open, fsc_pos_nxt, fsc_open_nxt, fsc_dir_nxt);

	wire [1:0] fso_pos_nxt, fso_dir_nxt;
	wire fso_open_nxt;
	full_stop_open_controller FSO(ctrl_button_up, ctrl_button_down, ctrl_button_in, open, fso_pos_nxt, fso_open_nxt, fso_dir_nxt);

	wire [1:0] fuc_pos_nxt, fuc_dir_nxt;
	wire fuc_open_nxt;
	full_up_close_controller FUC(ctrl_button_up, ctrl_button_down, ctrl_button_in, open, fuc_pos_nxt, fuc_open_nxt, fuc_dir_nxt);

	wire [1:0] fuo_pos_nxt, fuo_dir_nxt;
	wire fuo_open_nxt;
	full_up_open_controller FUO(ctrl_button_up, ctrl_button_down, ctrl_button_in, open, fuo_pos_nxt, fuo_open_nxt, fuo_dir_nxt);

	wire [1:0] fdc_pos_nxt, fdc_dir_nxt;
	wire fdc_open_nxt;
	full_down_close_controller FDC(ctrl_button_up, ctrl_button_down, ctrl_button_in, open, fdc_pos_nxt, fdc_open_nxt, fdc_dir_nxt);

	wire [1:0] fdo_pos_nxt, fdo_dir_nxt;
	wire fdo_open_nxt;
	full_down_open_controller FDO(ctrl_button_up, ctrl_button_down, ctrl_button_in, open, fdo_pos_nxt, fdo_open_nxt, fdo_dir_nxt);

	wire [1:0] h_pos_nxt, h_dir_nxt;
	wire h_open_nxt;
	half_controller HC(ctrl_button_up, ctrl_button_down, ctrl_button_in, direction, h_pos_nxt, h_open_nxt, h_dir_nxt);

	// select next state using mux
	wire [1:0] fs_pos_nxt, fs_dir_nxt;
	wire fs_open_nxt;
	mux2to1 MUX_full_stop_pos0({fso_pos_nxt[0], fsc_pos_nxt[0]}, open, fs_pos_nxt[0]);
	mux2to1 MUX_full_stop_pos1({fso_pos_nxt[1], fsc_pos_nxt[1]}, open, fs_pos_nxt[1]);
	mux2to1 MUX_full_stop_dir0({fso_dir_nxt[0], fsc_dir_nxt[0]}, open, fs_dir_nxt[0]);
	mux2to1 MUX_full_stop_dir1({fso_dir_nxt[1], fsc_dir_nxt[1]}, open, fs_dir_nxt[1]);
	mux2to1 MUX_full_stop_open({fso_open_nxt, fsc_open_nxt}, open, fs_open_nxt);

	wire [1:0] fu_pos_nxt, fu_dir_nxt;
	wire fu_open_nxt;
	mux2to1 MUX_full_up_pos0({fuo_pos_nxt[0], fuc_pos_nxt[0]}, open, fu_pos_nxt[0]);
	mux2to1 MUX_full_up_pos1({fuo_pos_nxt[1], fuc_pos_nxt[1]}, open, fu_pos_nxt[1]);
	mux2to1 MUX_full_up_dir0({fuo_dir_nxt[0], fuc_dir_nxt[0]}, open, fu_dir_nxt[0]);
	mux2to1 MUX_full_up_dir1({fuo_dir_nxt[1], fuc_dir_nxt[1]}, open, fu_dir_nxt[1]);
	mux2to1 MUX_full_up_open({fuo_open_nxt, fuc_open_nxt}, open, fu_open_nxt);

	wire [1:0] fd_pos_nxt, fd_dir_nxt;
	wire fd_open_nxt;
	mux2to1 MUX_full_down_pos0({fdo_pos_nxt[0], fdc_pos_nxt[0]}, open, fd_pos_nxt[0]);
	mux2to1 MUX_full_down_pos1({fdo_pos_nxt[1], fdc_pos_nxt[1]}, open, fd_pos_nxt[1]);
	mux2to1 MUX_full_down_dir0({fdo_dir_nxt[0], fdc_dir_nxt[0]}, open, fd_dir_nxt[0]);
	mux2to1 MUX_full_down_dir1({fdo_dir_nxt[1], fdc_dir_nxt[1]}, open, fd_dir_nxt[1]);
	mux2to1 MUX_full_down_open({fdo_open_nxt, fdc_open_nxt}, open, fd_open_nxt);

	wire [1:0] sel_state, ctrl_pos_nxt, dir_nxt;
	wire open_nxt;
	or(sel_state[0], direction[0], position[0]);
	or(sel_state[1], direction[1], position[0]);
	mux4to1 MUX_dir_nxt0({h_dir_nxt[0], fd_dir_nxt[0], fu_dir_nxt[0], fs_dir_nxt[0]}, sel_state, dir_nxt[0]);
	mux4to1 MUX_dir_nxt1({h_dir_nxt[1], fd_dir_nxt[1], fu_dir_nxt[1], fs_dir_nxt[1]}, sel_state, dir_nxt[1]);
	mux4to1 MUX_pos_nxt0({h_pos_nxt[0], fd_pos_nxt[0], fu_pos_nxt[0], fs_pos_nxt[0]}, sel_state, ctrl_pos_nxt[0]);
	mux4to1 MUX_pos_nxt1({h_pos_nxt[1], fd_pos_nxt[1], fu_pos_nxt[1], fs_pos_nxt[1]}, sel_state, ctrl_pos_nxt[1]);
	mux4to1 MUX_open({h_open_nxt, fd_open_nxt, fu_open_nxt, fs_open_nxt}, sel_state, open_nxt);

	wire[2:0] pos_nxt;
	adder Adder_direction(position, {3{ctrl_pos_nxt[1]}}, ctrl_pos_nxt[0], pos_nxt, );

endmodule


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

	or(button_down_23, button_down[1], button_down[2]);
	or(button_down_34, button_down[2], button_down[3]);
	or(button_down_234, button_down_34, button_down[1]);

	or(button_in_12, button_in[0], button_in[1]);
	or(button_in_123, button_in_12, button_in[2]);
	or(button_in_34, button_in[2], button_in[3]);
	or(button_in_234, button_in_34, button_in[1]);

	mux4to1 MUX_UP0({1'b0, button_up}, position, ctrl_button_up[0]);
	mux4to1 MUX_UP1({1'b0, 1'b0, button_up[1], button_up_23}, position, ctrl_button_up[1]);
	mux4to1 MUX_UP2({button_up_123, button_up_12, button_up[0], 1'b0}, position, ctrl_button_up[2]);

	mux4to1 MUX_DOWN0({button_down, 1'b0}, position, ctrl_button_down[0]);
	mux4to1 MUX_DOWN1({button_down_234, button_down_34, button_down[3], 1'b0}, position, ctrl_button_down[1]);
	mux4to1 MUX_DOWN2({button_down_23, button_down[1], 1'b0, 1'b0}, position, ctrl_button_down[2]);

	mux4to1 MUX_IN0(button_in, position, ctrl_button_in[0]);
	mux4to1 MUX_IN1({1'b0, button_in[3], button_in_34, button_in_234}, position, ctrl_button_in[1]);
	mux4to1 MUX_IN2({button_in_123, button_in_12, button_in[0], 1'b0}, position, ctrl_button_in[2]);

endmodule
