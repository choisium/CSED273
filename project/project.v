`timescale 1ns / 1ps

module elevator(
    reset_n, clk, button_up, button_down, button_in,
    position, open, direction
    );

	input reset_n;
	input clk;
	input [2:0] button_up;
	input [2:0] button_down;
	input [3:0] button_in;
	output [2:0] position;
	output open;
	output [1:0] direction;

	

	wire [2:0] pos_cur, pos_nxt;
	wire open_cur, open_nxt;
	wire [1:0] dir_cur, dir_nxt;

	dLatch pos0(clk, reset_n, pos_nxt[0], pos_cur[0], );
	dLatch pos1(clk, reset_n, pos_nxt[1], pos_cur[1], );
	dLatch pos2(clk, reset_n, pos_nxt[2], pos_cur[2], );
	dLatch open0(clk, reset_n, open_nxt, open_cur, );
	dLatch dir0(clk, reset_n, dir_nxt[0], dir_cur[0], );
	dLatch dir1(clk, reset_n, dir_nxt[1], dir_cur[1], );

	assign position = pos_nxt;
	assign open = open_nxt;
	assign direction = dir_nxt;

	controller Controller(button_up, button_down, button_in, pos_cur, pos_nxt, open_cur, open_nxt, dir_cur, dir_nxt);

endmodule

module dLatch(
	input clk, reset_n, d,
	output q, q_
);
	wire p, p_;
	wire d_, reset;

	not(d_, d);
	not(reset, reset_n);

	wire reset_d, reset_d_;
	and(reset_d, reset_n, d);
	or(reset_d_, reset, d_);

	nand(p, clk, reset_d);
	nand(p_, clk, reset_d_);

	wire reset_p, reset_p_;
	or(reset_p, reset, p);
	and(reset_p_, reset_, p_);

	nand(q, reset_p, q_);
	nand(q_, reset_p_, q);

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

	output [2:0] pos_nxt;
	output open_nxt;
	output [1:0] dir_nxt;

	wire [2:0] pos_cur_;
	wire pos_open_;
	wire [1:0] dir_cur_;

	not(pos_cur_[0], pos_cur_[0]); not(pos_cur_[1], pos_cur_[1]); not(pos_cur_[2], pos_cur_[2]);
	not(open_cur_, open_cur);
	not(dir_cur_[0], dir_cur[0]); not(dir_cur_[1], dir_cur[1]);

	assign pos_nxt = pos_cur;
	assign open_nxt = open_cur;
	assign dir_nxt = dir_cur;
	
endmodule