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

	wire [2:0] pos_cur, pos_nxt;
	wire open_cur, open_nxt;
	wire [1:0] dir_cur, dir_nxt;

	edge_trigger_D_FF latch_pos0(reset_n, pos_nxt[0], clk, pos_cur[0], );
	edge_trigger_D_FF latch_pos1(reset_n, pos_nxt[1], clk, pos_cur[1], );
	edge_trigger_D_FF latch_pos2(reset_n, pos_nxt[2], clk, pos_cur[2], );
	edge_trigger_D_FF latch_open0(reset_n, open_nxt, clk, open_cur, );
	edge_trigger_D_FF latch_dir0(reset_n, dir_nxt[0], clk, dir_cur[0], );
	edge_trigger_D_FF latch_dir1(reset_n, dir_nxt[1], clk, dir_cur[1], );

	assign position = pos_cur;
	assign open = open_cur;
	assign direction = dir_cur;

	wire [2:0] ctrl_button_up;		// [0]: i, [1]: >i, [2]: <i
	wire [2:0] ctrl_button_down;	// [0]: i, [1]: >i, [2]: <i
	wire [2:0] ctrl_button_in;		// [0]: i, [1]: >i, [2]: <i

	wire [2:0] ctrl_position;		// stay: 00, move up: 01, move down: 10

	button_module ButtonModule(button_up, button_down, button_in, position[2:1], ctrl_button_up, ctrl_button_down, ctrl_button_in);

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


	controller Controller(button_up, button_down, button_in, pos_cur, pos_nxt, open_cur, open_nxt, dir_cur, dir_nxt);

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

module controller(
	button_up, button_down, button_in,
	pos_cur, pos_nxt, open_cur, open_nxt, dir_cur, dir_nxt
);
	input [2:0] button_up;
	input [2:0] button_down;
	input [3:0] button_in;
	input [2:0] pos_cur;
	input open_cur;
	input [1:0] dir_cur;

	output reg [2:0] pos_nxt;
	output reg open_nxt;
	output reg [1:0] dir_nxt;

	wire [2:0] pos_cur_;
	wire pos_open_;
	wire [1:0] dir_cur_;

	// not(pos_cur_[0], pos_cur_[0]); not(pos_cur_[1], pos_cur_[1]); not(pos_cur_[2], pos_cur_[2]);
	// not(open_cur_, open_cur);
	// not(dir_cur_[0], dir_cur[0]); not(dir_cur_[1], dir_cur[1]);

	// assign pos_nxt = pos_cur;
	// assign open_nxt = open_cur;
	// assign dir_nxt = dir_cur;

	always @(*) begin
		if (pos_cur[0] == 0 && open_cur == 0 && dir_cur == 0) begin
			if (button_up[0] == 1 || button_down[0] == 1) begin
				pos_nxt = pos_cur;
				open_nxt = 1;
				dir_nxt = dir_cur;
			end else begin
				pos_nxt = pos_cur;
				open_nxt = open_cur;
				dir_nxt = dir_cur;
			end
		end else begin
			pos_nxt = pos_cur;
			open_nxt = open_cur;
			dir_nxt = dir_cur;
		end
	end

	
	// select between half floor and full floor
	
endmodule
