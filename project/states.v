module full_stop_close_controller(
	button_up, button_down, button_in, open_cur,
	pos_nxt, open_nxt, dir_nxt
);
	input [2:0] button_up;
	input [2:0] button_down;
	input [2:0] button_in;
	input open_cur;

	output [1:0] pos_nxt;
	output open_nxt;
	output [1:0] dir_nxt;

	wire stay, up, down;
	wire stay_n, up_n, down_n;

	// not values
	not(stay_n, stay);
	not(up_n, up);
	not(down_n, down);
	
	// check the branching conditions
	or(stay, button_up[0], button_down[0]);
	or(up, button_up[1], button_down[1]);
	or(down, button_up[2], button_down[2]);

	// compute next states
	assign open_nxt = stay;
	and(pos_nxt[1], down, stay_n, up_n);
	and(pos_nxt[0], up, stay_n);
	and(dir_nxt[1], down, stay_n, up_n);
	and(dir_nxt[0], up, stay_n);

endmodule

module full_stop_open_controller(
	button_up, button_down, button_in, open_cur,
	pos_nxt, open_nxt, dir_nxt
);
	input [2:0] button_up;
	input [2:0] button_down;
	input [2:0] button_in;
	input open_cur;

	output [1:0] pos_nxt;
	output open_nxt;
	output [1:0] dir_nxt;

	wire up, down;
	wire up_n, down_n;

	// not values
	not(up_n, up);
	not(down_n, down);
	
	// check the branching conditions
	or(up, button_in[1]);
	or(down, button_in[2]);

	// compute next states
	assign open_nxt = 1'b0;
    assign pos_nxt = 2'b00;
	and(dir_nxt[1], down);
	and(dir_nxt[0], up);

endmodule

module full_up_close_controller(
	button_up, button_down, button_in, open_cur,
	pos_nxt, open_nxt, dir_nxt
);
	input [2:0] button_up;
	input [2:0] button_down;
	input [2:0] button_in;
	input open_cur;

	output [1:0] pos_nxt;
	output open_nxt;
	output [1:0] dir_nxt;

    wire open, open_down, up, up_or;

    wire [2:0] button_in_n, button_up_n;
    wire button_down_1_n;

	// not values
    not(button_in_n[0], button_in[0]);
    not(button_in_n[1], button_in[1]);
    not(button_in_n[2], button_in[2]);
    not(button_up_n[0], button_up[0]);
    not(button_up_n[1], button_up[1]);
    not(button_up_n[2], button_up[2]);
    not(button_down_1_n, button_down[1]);
	
	// check the branching conditions
    and(open_down, button_in_n[0], button_in_n[1], button_up_n[0], button_up_n[1], button_down_1_n, button_down[0]);
    or(open, button_in[0], button_up[0], open_down);

    or(up_or, button_in[1], button_up[1], button_down[1]);
    and(up, button_in_n[0], button_up_n[0]);

	// compute next states
	assign open_nxt = open;
    assign pos_nxt[1] = 1'b0;
	and(pos_nxt[0], up);
    assign dir_nxt = 2'b01;

endmodule


module full_up_open_controller(
	button_up, button_down, button_in, open_cur,
	pos_nxt, open_nxt, dir_nxt
);
	input [2:0] button_up;
	input [2:0] button_down;
	input [2:0] button_in;
	input open_cur;

	output [1:0] pos_nxt;
	output open_nxt;
	output [1:0] dir_nxt;

    wire up, down, down_or;
    wire up_n;

	// not values
	not(up_n, up);
	
	// check the branching conditions
    or(up, button_in[1], button_up[1], button_down[1]);
    or(down_or, button_in[2], button_up[2], button_down[2]);
    and(down, up_n, down_or);

	// compute next states
	assign open_nxt = 1'b0;
    assign pos_nxt = 2'b00;
	and(dir_nxt[1], down, up_n);
	and(dir_nxt[0], up);

endmodule


module full_down_close_controller(
	button_up, button_down, button_in, open_cur,
	pos_nxt, open_nxt, dir_nxt
);
	input [2:0] button_up;
	input [2:0] button_down;
	input [2:0] button_in;
	input open_cur;

	output [1:0] pos_nxt;
	output open_nxt;
	output [1:0] dir_nxt;

    wire open, open_up, up, up_or;

    wire [2:0] button_in_n, button_down_n;
    wire button_up_2_n;

	// not values
    not(button_in_n[0], button_in[0]);
    not(button_in_n[1], button_in[1]);
    not(button_in_n[2], button_in[2]);
    not(button_down_n[0], button_down[0]);
    not(button_down_n[1], button_down[1]);
    not(button_down_n[2], button_down[2]);
    not(button_up_2_n, button_up[2]);
	
	// check the branching conditions
    and(open_up, button_in_n[0], button_in_n[2], button_down_n[0], button_down_n[2], button_up_2_n, button_up[0]);
    or(open, button_in[0], button_down[0], open_up);

    or(down_or, button_in[2], button_up[2], button_down[2]);
    and(down, button_in_n[0], button_down_n[0]);

	// compute next states
	assign open_nxt = open;
    assign pos_nxt[0] = 1'b0;
	and(pos_nxt[1], down);
    assign dir_nxt = 2'b10;

endmodule


module full_down_open_controller(
	button_up, button_down, button_in, open_cur,
	pos_nxt, open_nxt, dir_nxt
);
	input [2:0] button_up;
	input [2:0] button_down;
	input [2:0] button_in;
	input open_cur;

	output [1:0] pos_nxt;
	output open_nxt;
	output [1:0] dir_nxt;

    wire down, up, up_or;
    wire down_n;

	// not values
	not(down_n, down);
	
	// check the branching conditions
    or(down, button_in[2], button_up[2], button_down[2]);
    or(up_or, button_in[1], button_up[1], button_down[1]);
    and(up, down_n, up_or);

	// compute next states
	assign open_nxt = 1'b0;
    assign pos_nxt = 2'b00;
	and(dir_nxt[0], up, down_n);
	and(dir_nxt[1], down);

endmodule


module half_controller(
	button_up, button_down, button_in, dir_cur,
	pos_nxt, open_nxt, dir_nxt
);
	input [2:0] button_up;
	input [2:0] button_down;
	input [2:0] button_in;
	input [1:0] dir_cur;

	output [1:0] pos_nxt;
	output open_nxt;
	output [1:0] dir_nxt;

	// compute next states
	assign open_nxt = 1'b0;

    assign pos_nxt = dir_cur;
    assign dir_nxt = dir_cur;

endmodule
