`timescale 1ns / 1ps

`define PERIOD 100
`define NUM_TEST 4
`define TESTID_SIZE 5

module project_tb;
	
    //Internal signals declarations:
    reg clk;
    reg reset_n;

    reg [2:0] button_up;
    reg [2:0] button_down;
    reg [3:0] button_in;
    wire [2:0] position;
    wire open;
    wire [1:0] direction;

    event testbench_finish;
    initial #(`PERIOD*50) -> testbench_finish; // Only 10,000 cycles are allowed.

    elevator Elevator(
        .clk(clk),
        .reset_n(reset_n),
        .button_up(button_up),
        .button_down(button_down),
        .button_in(button_in),
        .position(position),
        .open(open),
        .direction(direction)
    );

    // clock signal
    initial clk <= 0;
    always #(`PERIOD/2) clk <= ~clk; // a clock cycle: # 100, a half cycle: # 50
        
    initial begin
		$dumpfile("wave.vcd");
        $dumpvars(0, project_tb);

        // Reset the device
        reset_n = 1;
        #(`PERIOD/4) reset_n = 0;
        #(`PERIOD + `PERIOD/2) reset_n = 1;
        
        // Initialize input signals
        button_up = 0;
        button_down = 0;
        button_in = 0;
    end

    reg [2:0] TestBU [`NUM_TEST-1:0];
    reg [2:0] TestBD [`NUM_TEST-1:0];
    reg [3:0] TestBI [`NUM_TEST-1:0];
    reg [`TESTID_SIZE*8-1:0] TestID [`NUM_TEST-1:0];
    reg [15:0] TestClk [`NUM_TEST-1:0];
    reg [2:0] TestAnsPos [`NUM_TEST-1:0];
    reg TestAnsOpen [`NUM_TEST-1:0];
    reg [1:0] TestAnsDir [`NUM_TEST-1:0];
	reg TestPassed [`NUM_TEST-1:0];	


    initial begin
        TestID[0] <= "1-1";   TestBU[0] <= 3'b001;      TestBD[0] <= 3'b000;    TestBI[0] <= 4'b0000;
        TestClk[0] <= 16'd0;  TestAnsPos[0] <= 3'b000;  TestAnsOpen[0] <= 0;    TestAnsDir[0] <= 2'b00; TestPassed[0] <= 1'bx;
        TestID[1] <= "1-2";   TestBU[1] <= 3'b000;      TestBD[1] <= 3'b000;    TestBI[1] <= 4'b0100;
        TestClk[1] <= 16'd1;  TestAnsPos[1] <= 3'b000;  TestAnsOpen[1] <= 1;    TestAnsDir[1] <= 2'b00; TestPassed[1] <= 1'bx;
        TestID[2] <= "1-3";   TestBU[2] <= 3'b010;      TestBD[2] <= 3'b000;    TestBI[2] <= 4'b0000;
        TestClk[2] <= 16'd2;  TestAnsPos[2] <= 3'b000;  TestAnsOpen[2] <= 0;    TestAnsDir[2] <= 2'b01; TestPassed[2] <= 1'bx;
        TestID[3] <= "1-4";   TestBU[3] <= 3'b010;      TestBD[3] <= 3'b000;    TestBI[3] <= 4'b0000;
        TestClk[3] <= 16'd3;  TestAnsPos[3] <= 3'b001;  TestAnsOpen[3] <= 0;    TestAnsDir[3] <= 2'b01; TestPassed[3] <= 1'bx;
    end

	integer i;
	integer num_clock;
		
	always @(posedge clk) begin
        if (!reset_n) begin
            num_clock = 0;
        end else begin
			num_clock <= num_clock + 1;

            $display("num_clock: %d, i: %d, bu: %b, bd: %b, bi: %b", num_clock, i, TestBU[i], TestBD[i], TestBI[i]);
            button_up <= TestBU[num_clock];
            button_down <= TestBD[num_clock];
            button_in <= TestBI[num_clock];


            for(i = 0; i<`NUM_TEST; i = i+1) begin
				if (num_clock == TestClk[i]) begin
					if (position == TestAnsPos[i] && open == TestAnsOpen[i] && direction == TestAnsDir[i]) begin
						TestPassed[i] <= 1'b1;
					end
					else begin
						TestPassed[i] <= 1'b0;
						$display("Test #%s has been failed!", TestID[i]);
						$display("position = 0x%0x (Ans : 0x%0x), open = 0x%0x (Ans : 0x%0x), direction = 0x%0x (Ans : 0x%0x)", position, TestAnsPos[i], open, TestAnsOpen[i], direction, TestAnsDir[i]);
						-> testbench_finish;
					end
				end
			end
            if (num_clock == `NUM_TEST) begin
                -> testbench_finish;
            end
		end
	end

    reg [15:0] Passed;
    initial Passed <= 0;

    always @(testbench_finish) begin
		$display("Clock #%d", num_clock);
		$display("The testbench is finished. Summarizing...");
		for(i=0; i<`NUM_TEST; i=i+1) begin
			if (TestPassed[i] == 1)
				Passed=Passed+1;
			else									   
				$display("Test #%s : %s", TestID[i], (TestPassed[i] === 0)?"Wrong" : "No Result");
		end
		if (Passed == `NUM_TEST)
			$display("All Pass!");
		else
			$display("Pass : %0d/%0d", Passed, `NUM_TEST);
		$finish;
	end


endmodule
