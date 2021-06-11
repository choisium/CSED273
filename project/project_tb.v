`timescale 1ns / 1ps

`define PERIOD 100
`define NUM_TEST 15
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

        // Initialize input signals
        button_up = 0;
        button_down = 0;
        button_in = 0;

        // Reset the device
        reset_n = 1;
        #(`PERIOD/4) reset_n = 0;
        #(`PERIOD + `PERIOD/2) reset_n = 1;
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
        TestID[4] <= "1-5";   TestBU[4] <= 3'b010;      TestBD[4] <= 3'b000;    TestBI[4] <= 4'b0000;
        TestClk[4] <= 16'd4;  TestAnsPos[4] <= 3'b010;  TestAnsOpen[4] <= 0;    TestAnsDir[4] <= 2'b01; TestPassed[4] <= 1'bx;
        TestID[5] <= "1-6";   TestBU[5] <= 3'b000;      TestBD[5] <= 3'b000;    TestBI[5] <= 4'b1000;
        TestClk[5] <= 16'd5;  TestAnsPos[5] <= 3'b010;  TestAnsOpen[5] <= 1;    TestAnsDir[5] <= 2'b01; TestPassed[5] <= 1'bx;
        TestID[6] <= "1-7";   TestBU[6] <= 3'b000;      TestBD[6] <= 3'b000;    TestBI[6] <= 4'b0000;
        TestClk[6] <= 16'd6;  TestAnsPos[6] <= 3'b010;  TestAnsOpen[6] <= 0;    TestAnsDir[6] <= 2'b01; TestPassed[6] <= 1'bx;
        TestID[7] <= "1-8";   TestBU[7] <= 3'b000;      TestBD[7] <= 3'b000;    TestBI[7] <= 4'b0000;
        TestClk[7] <= 16'd7;  TestAnsPos[7] <= 3'b011;  TestAnsOpen[7] <= 0;    TestAnsDir[7] <= 2'b01; TestPassed[7] <= 1'bx;
        TestID[8] <= "1-9";   TestBU[8] <= 3'b000;      TestBD[8] <= 3'b000;    TestBI[8] <= 4'b0000;
        TestClk[8] <= 16'd8;  TestAnsPos[8] <= 3'b100;  TestAnsOpen[8] <= 0;    TestAnsDir[8] <= 2'b01; TestPassed[8] <= 1'bx;
        TestID[9] <= "1-10";   TestBU[9] <= 3'b000;      TestBD[9] <= 3'b000;    TestBI[9] <= 4'b0000;
        TestClk[9] <= 16'd9;  TestAnsPos[9] <= 3'b100;  TestAnsOpen[9] <= 1;    TestAnsDir[9] <= 2'b01; TestPassed[9] <= 1'bx;
        TestID[10] <= "1-11";   TestBU[10] <= 3'b000;      TestBD[10] <= 3'b000;    TestBI[10] <= 4'b0000;
        TestClk[10] <= 16'd10;  TestAnsPos[10] <= 3'b100;  TestAnsOpen[10] <= 0;    TestAnsDir[10] <= 2'b01; TestPassed[10] <= 1'bx;
        TestID[11] <= "1-12";   TestBU[11] <= 3'b000;      TestBD[11] <= 3'b000;    TestBI[11] <= 4'b0000;
        TestClk[11] <= 16'd11;  TestAnsPos[11] <= 3'b101;  TestAnsOpen[11] <= 0;    TestAnsDir[11] <= 2'b01; TestPassed[11] <= 1'bx;
        TestID[12] <= "1-13";   TestBU[12] <= 3'b000;      TestBD[12] <= 3'b000;    TestBI[12] <= 4'b0000;
        TestClk[12] <= 16'd12;  TestAnsPos[12] <= 3'b110;  TestAnsOpen[12] <= 0;    TestAnsDir[12] <= 2'b01; TestPassed[12] <= 1'bx;
        TestID[13] <= "1-14";   TestBU[13] <= 3'b000;      TestBD[13] <= 3'b000;    TestBI[13] <= 4'b0000;
        TestClk[13] <= 16'd13;  TestAnsPos[13] <= 3'b110;  TestAnsOpen[13] <= 1;    TestAnsDir[13] <= 2'b01; TestPassed[13] <= 1'bx;
        TestID[14] <= "1-14";   TestBU[14] <= 3'b000;      TestBD[14] <= 3'b000;    TestBI[14] <= 4'b0000;
        TestClk[14] <= 16'd14;  TestAnsPos[14] <= 3'b110;  TestAnsOpen[14] <= 0;    TestAnsDir[14] <= 2'b00; TestPassed[14] <= 1'bx;
    end

	integer i;
	integer num_clock;
		
	always @(posedge clk) begin
        if (!reset_n) begin
            num_clock = 0;
        end else begin
			num_clock <= num_clock + 1;

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
