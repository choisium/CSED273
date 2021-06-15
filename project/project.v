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

	// states
	wire[2:0] pos_cur, pos_nxt;
	wire open_cur, open_nxt;
	wire [1:0] dir_cur, dir_nxt;

	// update position, open, direction
	assign position = pos_cur;
	assign open = open_cur;
	assign direction = dir_cur;

	edge_trigger_D_FF DFF_pos0(reset_n, pos_nxt[0], ~clk, pos_cur[0], );
	edge_trigger_D_FF DFF_pos1(reset_n, pos_nxt[1], ~clk, pos_cur[1], );
	edge_trigger_D_FF DFF_pos2(reset_n, pos_nxt[2], ~clk, pos_cur[2], );
	edge_trigger_D_FF DFF_open0(reset_n, open_nxt, ~clk, open_cur, );
	edge_trigger_D_FF DFF_dir0(reset_n, dir_nxt[0], ~clk, dir_cur[0], );
	edge_trigger_D_FF DFF_dir1(reset_n, dir_nxt[1], ~clk, dir_cur[1], );

	// compute button for convenience
	wire [3:0] reg_button_in;
	reg_button_in_module RegButtonInModule(reset_n, button_in, pos_cur[2:1], open_cur, reg_button_in);


	wire [2:0] ctrl_button_up;		// [0]: i, [1]: >i, [2]: <i
	wire [2:0] ctrl_button_down;	// [0]: i, [1]: >i, [2]: <i
	wire [2:0] ctrl_button_in;		// [0]: i, [1]: >i, [2]: <i
	wire [2:0] ctrl_position;		// stay: 00, move up: 01, move down: 10
	button_module ButtonModule(button_up, button_down, reg_button_in, pos_cur[2:1], ctrl_button_up, ctrl_button_down, ctrl_button_in);

	// calculate next states from each states
	wire [1:0] fsc_ctrl_pos_nxt, fsc_dir_nxt;
	wire fsc_open_nxt;
	full_stop_close_controller FSC(ctrl_button_up, ctrl_button_down, ctrl_button_in, fsc_ctrl_pos_nxt, fsc_open_nxt, fsc_dir_nxt);

	wire [1:0] fso_ctrl_pos_nxt, fso_dir_nxt;
	wire fso_open_nxt;
	full_stop_open_controller FSO(ctrl_button_up, ctrl_button_down, ctrl_button_in, fso_ctrl_pos_nxt, fso_open_nxt, fso_dir_nxt);

	wire [1:0] fuc_ctrl_pos_nxt, fuc_dir_nxt;
	wire fuc_open_nxt;
	full_up_close_controller FUC(ctrl_button_up, ctrl_button_down, ctrl_button_in, fuc_ctrl_pos_nxt, fuc_open_nxt, fuc_dir_nxt);

	wire [1:0] fuo_ctrl_pos_nxt, fuo_dir_nxt;
	wire fuo_open_nxt;
	full_up_open_controller FUO(ctrl_button_up, ctrl_button_down, ctrl_button_in, fuo_ctrl_pos_nxt, fuo_open_nxt, fuo_dir_nxt);

	wire [1:0] fdc_ctrl_pos_nxt, fdc_dir_nxt;
	wire fdc_open_nxt;
	full_down_close_controller FDC(ctrl_button_up, ctrl_button_down, ctrl_button_in, fdc_ctrl_pos_nxt, fdc_open_nxt, fdc_dir_nxt);

	wire [1:0] fdo_ctrl_pos_nxt, fdo_dir_nxt;
	wire fdo_open_nxt;
	full_down_open_controller FDO(ctrl_button_up, ctrl_button_down, ctrl_button_in, fdo_ctrl_pos_nxt, fdo_open_nxt, fdo_dir_nxt);

	wire [1:0] h_ctrl_pos_nxt, h_dir_nxt;
	wire h_open_nxt;
	half_controller HC(ctrl_button_up, ctrl_button_down, ctrl_button_in, dir_cur, h_ctrl_pos_nxt, h_open_nxt, h_dir_nxt);

	// select next state using mux
	wire [1:0] fs_ctrl_pos_nxt, fs_dir_nxt;
	wire fs_open_nxt;
	mux2to1 MUX_full_stop_pos0({fso_ctrl_pos_nxt[0], fsc_ctrl_pos_nxt[0]}, open_cur, fs_ctrl_pos_nxt[0]);
	mux2to1 MUX_full_stop_pos1({fso_ctrl_pos_nxt[1], fsc_ctrl_pos_nxt[1]}, open_cur, fs_ctrl_pos_nxt[1]);
	mux2to1 MUX_full_stop_dir0({fso_dir_nxt[0], fsc_dir_nxt[0]}, open_cur, fs_dir_nxt[0]);
	mux2to1 MUX_full_stop_dir1({fso_dir_nxt[1], fsc_dir_nxt[1]}, open_cur, fs_dir_nxt[1]);
	mux2to1 MUX_full_stop_open({fso_open_nxt, fsc_open_nxt}, open_cur, fs_open_nxt);

	wire [1:0] fu_ctrl_pos_nxt, fu_dir_nxt;
	wire fu_open_nxt;
	mux2to1 MUX_full_up_pos0({fuo_ctrl_pos_nxt[0], fuc_ctrl_pos_nxt[0]}, open_cur, fu_ctrl_pos_nxt[0]);
	mux2to1 MUX_full_up_pos1({fuo_ctrl_pos_nxt[1], fuc_ctrl_pos_nxt[1]}, open_cur, fu_ctrl_pos_nxt[1]);
	mux2to1 MUX_full_up_dir0({fuo_dir_nxt[0], fuc_dir_nxt[0]}, open_cur, fu_dir_nxt[0]);
	mux2to1 MUX_full_up_dir1({fuo_dir_nxt[1], fuc_dir_nxt[1]}, open_cur, fu_dir_nxt[1]);
	mux2to1 MUX_full_up_open({fuo_open_nxt, fuc_open_nxt}, open_cur, fu_open_nxt);

	wire [1:0] fd_ctrl_pos_nxt, fd_dir_nxt;
	wire fd_open_nxt;
	mux2to1 MUX_full_down_pos0({fdo_ctrl_pos_nxt[0], fdc_ctrl_pos_nxt[0]}, open_cur, fd_ctrl_pos_nxt[0]);
	mux2to1 MUX_full_down_pos1({fdo_ctrl_pos_nxt[1], fdc_ctrl_pos_nxt[1]}, open_cur, fd_ctrl_pos_nxt[1]);
	mux2to1 MUX_full_down_dir0({fdo_dir_nxt[0], fdc_dir_nxt[0]}, open_cur, fd_dir_nxt[0]);
	mux2to1 MUX_full_down_dir1({fdo_dir_nxt[1], fdc_dir_nxt[1]}, open_cur, fd_dir_nxt[1]);
	mux2to1 MUX_full_down_open({fdo_open_nxt, fdc_open_nxt}, open_cur, fd_open_nxt);

	wire [1:0] sel_state, ctrl_pos_nxt;
	or(sel_state[0], dir_cur[0], pos_cur[0]);
	or(sel_state[1], dir_cur[1], pos_cur[0]);
	mux4to1 MUX_dir_nxt0({h_dir_nxt[0], fd_dir_nxt[0], fu_dir_nxt[0], fs_dir_nxt[0]}, sel_state, dir_nxt[0]);
	mux4to1 MUX_dir_nxt1({h_dir_nxt[1], fd_dir_nxt[1], fu_dir_nxt[1], fs_dir_nxt[1]}, sel_state, dir_nxt[1]);
	mux4to1 MUX_pos_nxt0({h_ctrl_pos_nxt[0], fd_ctrl_pos_nxt[0], fu_ctrl_pos_nxt[0], fs_ctrl_pos_nxt[0]}, sel_state, ctrl_pos_nxt[0]);
	mux4to1 MUX_pos_nxt1({h_ctrl_pos_nxt[1], fd_ctrl_pos_nxt[1], fu_ctrl_pos_nxt[1], fs_ctrl_pos_nxt[1]}, sel_state, ctrl_pos_nxt[1]);
	mux4to1 MUX_open({h_open_nxt, fd_open_nxt, fu_open_nxt, fs_open_nxt}, sel_state, open_nxt);

	// calculate next position from ctrl_pos_nxt value
	adder Adder_position(pos_cur, {3{ctrl_pos_nxt[1]}}, ctrl_pos_nxt[0], pos_nxt, );

endmodule

