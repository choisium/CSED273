`timescale 1ns / 1ps

`define PERIOD 100
`define NUM_TEST 60
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
    initial #(`PERIOD*10000) -> testbench_finish; // Only 10,000 cycles are allowed.

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

    reg [`TESTID_SIZE*8-1:0] TestID [`NUM_TEST-1:0];
    reg [2:0] TestBU [`NUM_TEST-1:0];
    reg [2:0] TestBD [`NUM_TEST-1:0];
    reg [3:0] TestBI [`NUM_TEST-1:0];
    
    reg [15:0] TestClk [`NUM_TEST-1:0];
    reg [2:0] TestAnsPos [`NUM_TEST-1:0];
    reg TestAnsOpen [`NUM_TEST-1:0];
    reg [1:0] TestAnsDir [`NUM_TEST-1:0];
	reg TestPassed [`NUM_TEST-1:0];

    initial begin
        TestID[0] <= "1-0";   TestBU[0] <= 3'b001;      TestBD[0] <= 3'b000;    TestBI[0] <= 4'b0000;
        TestID[1] <= "1-1";   TestBU[1] <= 3'b000;      TestBD[1] <= 3'b000;    TestBI[1] <= 4'b1000;
        TestID[2] <= "1-2";   TestBU[2] <= 3'b010;      TestBD[2] <= 3'b000;    TestBI[2] <= 4'b0000;
        TestID[3] <= "1-3";   TestBU[3] <= 3'b010;      TestBD[3] <= 3'b000;    TestBI[3] <= 4'b0000;
        TestID[4] <= "1-4";   TestBU[4] <= 3'b010;      TestBD[4] <= 3'b010;    TestBI[4] <= 4'b0000;
        TestID[5] <= "1-5";   TestBU[5] <= 3'b000;      TestBD[5] <= 3'b010;    TestBI[5] <= 4'b1000;
        TestID[6] <= "1-6";   TestBU[6] <= 3'b000;      TestBD[6] <= 3'b010;    TestBI[6] <= 4'b0000;
        TestID[7] <= "1-7";   TestBU[7] <= 3'b000;      TestBD[7] <= 3'b010;    TestBI[7] <= 4'b0000;
        TestID[8] <= "1-8";   TestBU[8] <= 3'b000;      TestBD[8] <= 3'b010;    TestBI[8] <= 4'b0000;
        TestID[9] <= "1-9";   TestBU[9] <= 3'b000;      TestBD[9] <= 3'b010;    TestBI[9] <= 4'b0000;
        TestID[10] <= "1-10";   TestBU[10] <= 3'b000;      TestBD[10] <= 3'b010;    TestBI[10] <= 4'b0000;
        TestID[11] <= "1-11";   TestBU[11] <= 3'b000;      TestBD[11] <= 3'b010;    TestBI[11] <= 4'b0000;
        TestID[12] <= "1-12";   TestBU[12] <= 3'b000;      TestBD[12] <= 3'b010;    TestBI[12] <= 4'b0000;
        TestID[13] <= "1-13";   TestBU[13] <= 3'b000;      TestBD[13] <= 3'b010;    TestBI[13] <= 4'b0000;
        TestID[14] <= "1-14";   TestBU[14] <= 3'b000;      TestBD[14] <= 3'b010;    TestBI[14] <= 4'b0000;
        TestID[15] <= "1-15";   TestBU[15] <= 3'b000;      TestBD[15] <= 3'b000;    TestBI[15] <= 4'b0010;
        TestID[16] <= "1-16";   TestBU[16] <= 3'b000;      TestBD[16] <= 3'b000;    TestBI[16] <= 4'b0000;
        TestID[17] <= "1-17";   TestBU[17] <= 3'b000;      TestBD[17] <= 3'b000;    TestBI[17] <= 4'b0000;
        TestID[18] <= "1-18";   TestBU[18] <= 3'b000;      TestBD[18] <= 3'b000;    TestBI[18] <= 4'b0000;
        TestID[19] <= "1-19";   TestBU[19] <= 3'b000;      TestBD[19] <= 3'b000;    TestBI[19] <= 4'b0000;
        TestID[20] <= "1-20";   TestBU[20] <= 3'b000;      TestBD[20] <= 3'b000;    TestBI[20] <= 4'b0000;
        TestID[21] <= "1-21";   TestBU[21] <= 3'b000;      TestBD[21] <= 3'b000;    TestBI[21] <= 4'b0000;

        TestID[22] <= "2-22";   TestBU[22] <= 3'b000;      TestBD[22] <= 3'b010;    TestBI[22] <= 4'b0000;
        TestID[23] <= "2-23";   TestBU[23] <= 3'b000;      TestBD[23] <= 3'b110;    TestBI[23] <= 4'b0000;
        TestID[24] <= "2-24";   TestBU[24] <= 3'b000;      TestBD[24] <= 3'b110;    TestBI[24] <= 4'b0000;
        TestID[25] <= "2-25";   TestBU[25] <= 3'b000;      TestBD[25] <= 3'b110;    TestBI[25] <= 4'b0000;
        TestID[26] <= "2-26";   TestBU[26] <= 3'b000;      TestBD[26] <= 3'b110;    TestBI[26] <= 4'b0000;
        TestID[27] <= "2-27";   TestBU[27] <= 3'b000;      TestBD[27] <= 3'b010;    TestBI[27] <= 4'b0001;
        TestID[28] <= "2-28";   TestBU[28] <= 3'b000;      TestBD[28] <= 3'b010;    TestBI[28] <= 4'b0000;
        TestID[29] <= "2-29";   TestBU[29] <= 3'b000;      TestBD[29] <= 3'b010;    TestBI[29] <= 4'b0000;
        TestID[30] <= "2-30";   TestBU[30] <= 3'b000;      TestBD[30] <= 3'b010;    TestBI[30] <= 4'b0000;
        TestID[31] <= "2-31";   TestBU[31] <= 3'b000;      TestBD[31] <= 3'b000;    TestBI[31] <= 4'b0001;
        TestID[32] <= "2-32";   TestBU[32] <= 3'b000;      TestBD[32] <= 3'b000;    TestBI[32] <= 4'b0000;
        TestID[33] <= "2-33";   TestBU[33] <= 3'b000;      TestBD[33] <= 3'b000;    TestBI[33] <= 4'b0000;
        TestID[34] <= "2-34";   TestBU[34] <= 3'b000;      TestBD[34] <= 3'b000;    TestBI[34] <= 4'b0000;
        TestID[35] <= "2-35";   TestBU[35] <= 3'b000;      TestBD[35] <= 3'b000;    TestBI[35] <= 4'b0000;
        TestID[36] <= "2-36";   TestBU[36] <= 3'b000;      TestBD[36] <= 3'b000;    TestBI[36] <= 4'b0000;
        TestID[37] <= "2-37";   TestBU[37] <= 3'b000;      TestBD[37] <= 3'b000;    TestBI[37] <= 4'b0000;
        TestID[38] <= "2-38";   TestBU[38] <= 3'b000;      TestBD[38] <= 3'b000;    TestBI[38] <= 4'b0000;

        TestID[39] <= "3-39";   TestBU[39] <= 3'b000;      TestBD[39] <= 3'b001;    TestBI[39] <= 4'b0000;
        TestID[40] <= "3-40";   TestBU[40] <= 3'b000;      TestBD[40] <= 3'b001;    TestBI[40] <= 4'b0000;
        TestID[41] <= "3-41";   TestBU[41] <= 3'b000;      TestBD[41] <= 3'b001;    TestBI[41] <= 4'b0000;
        TestID[42] <= "3-42";   TestBU[42] <= 3'b100;      TestBD[42] <= 3'b000;    TestBI[42] <= 4'b0001;
        TestID[43] <= "3-43";   TestBU[43] <= 3'b100;      TestBD[43] <= 3'b000;    TestBI[43] <= 4'b0000;
        TestID[44] <= "3-44";   TestBU[44] <= 3'b100;      TestBD[44] <= 3'b000;    TestBI[44] <= 4'b0000;
        TestID[45] <= "3-45";   TestBU[45] <= 3'b100;      TestBD[45] <= 3'b000;    TestBI[45] <= 4'b0000;
        TestID[46] <= "3-46";   TestBU[46] <= 3'b100;      TestBD[46] <= 3'b000;    TestBI[46] <= 4'b0000;
        TestID[47] <= "3-47";   TestBU[47] <= 3'b100;      TestBD[47] <= 3'b000;    TestBI[47] <= 4'b0000;
        TestID[48] <= "3-48";   TestBU[48] <= 3'b100;      TestBD[48] <= 3'b000;    TestBI[48] <= 4'b0000;
        TestID[49] <= "3-49";   TestBU[49] <= 3'b100;      TestBD[49] <= 3'b000;    TestBI[49] <= 4'b0000;
        TestID[50] <= "3-50";   TestBU[50] <= 3'b100;      TestBD[50] <= 3'b000;    TestBI[50] <= 4'b0000;
        TestID[51] <= "3-51";   TestBU[51] <= 3'b100;      TestBD[51] <= 3'b000;    TestBI[51] <= 4'b0000;
        TestID[52] <= "3-52";   TestBU[52] <= 3'b000;      TestBD[52] <= 3'b000;    TestBI[52] <= 4'b1000;
        TestID[53] <= "3-53";   TestBU[53] <= 3'b100;      TestBD[53] <= 3'b000;    TestBI[53] <= 4'b0000;
        TestID[54] <= "3-54";   TestBU[54] <= 3'b000;      TestBD[54] <= 3'b000;    TestBI[54] <= 4'b1000;
        TestID[55] <= "3-55";   TestBU[55] <= 3'b000;      TestBD[55] <= 3'b000;    TestBI[55] <= 4'b0000;
        TestID[56] <= "3-56";   TestBU[56] <= 3'b000;      TestBD[56] <= 3'b000;    TestBI[56] <= 4'b0000;
        TestID[57] <= "3-57";   TestBU[57] <= 3'b000;      TestBD[57] <= 3'b000;    TestBI[57] <= 4'b0000;
        TestID[58] <= "3-58";   TestBU[58] <= 3'b000;      TestBD[58] <= 3'b000;    TestBI[58] <= 4'b0000;
        TestID[59] <= "3-59";   TestBU[59] <= 3'b000;      TestBD[59] <= 3'b000;    TestBI[59] <= 4'b0000;
    end

    initial begin
        TestClk[0] <= 16'd0;  TestAnsPos[0] <= 3'b000;  TestAnsOpen[0] <= 0;    TestAnsDir[0] <= 2'b00; TestPassed[0] <= 1'bx;
        TestClk[1] <= 16'd1;  TestAnsPos[1] <= 3'b000;  TestAnsOpen[1] <= 1;    TestAnsDir[1] <= 2'b00; TestPassed[1] <= 1'bx;
        TestClk[2] <= 16'd2;  TestAnsPos[2] <= 3'b000;  TestAnsOpen[2] <= 0;    TestAnsDir[2] <= 2'b01; TestPassed[2] <= 1'bx;
        TestClk[3] <= 16'd3;  TestAnsPos[3] <= 3'b001;  TestAnsOpen[3] <= 0;    TestAnsDir[3] <= 2'b01; TestPassed[3] <= 1'bx;
        TestClk[4] <= 16'd4;  TestAnsPos[4] <= 3'b010;  TestAnsOpen[4] <= 0;    TestAnsDir[4] <= 2'b01; TestPassed[4] <= 1'bx;
        TestClk[5] <= 16'd5;  TestAnsPos[5] <= 3'b010;  TestAnsOpen[5] <= 1;    TestAnsDir[5] <= 2'b01; TestPassed[5] <= 1'bx;
        TestClk[6] <= 16'd6;  TestAnsPos[6] <= 3'b010;  TestAnsOpen[6] <= 0;    TestAnsDir[6] <= 2'b01; TestPassed[6] <= 1'bx;
        TestClk[7] <= 16'd7;  TestAnsPos[7] <= 3'b011;  TestAnsOpen[7] <= 0;    TestAnsDir[7] <= 2'b01; TestPassed[7] <= 1'bx;
        TestClk[8] <= 16'd8;  TestAnsPos[8] <= 3'b100;  TestAnsOpen[8] <= 0;    TestAnsDir[8] <= 2'b01; TestPassed[8] <= 1'bx;
        TestClk[9] <= 16'd9;  TestAnsPos[9] <= 3'b101;  TestAnsOpen[9] <= 0;    TestAnsDir[9] <= 2'b01; TestPassed[9] <= 1'bx;
        TestClk[10] <= 16'd10;  TestAnsPos[10] <= 3'b110;  TestAnsOpen[10] <= 0;    TestAnsDir[10] <= 2'b01; TestPassed[10] <= 1'bx;
        TestClk[11] <= 16'd11;  TestAnsPos[11] <= 3'b110;  TestAnsOpen[11] <= 1;    TestAnsDir[11] <= 2'b01; TestPassed[11] <= 1'bx;
        TestClk[12] <= 16'd12;  TestAnsPos[12] <= 3'b110;  TestAnsOpen[12] <= 0;    TestAnsDir[12] <= 2'b10; TestPassed[12] <= 1'bx;
        TestClk[13] <= 16'd13;  TestAnsPos[13] <= 3'b101;  TestAnsOpen[13] <= 0;    TestAnsDir[13] <= 2'b10; TestPassed[13] <= 1'bx;
        TestClk[14] <= 16'd14;  TestAnsPos[14] <= 3'b100;  TestAnsOpen[14] <= 0;    TestAnsDir[14] <= 2'b10; TestPassed[14] <= 1'bx;
        TestClk[15] <= 16'd15;  TestAnsPos[15] <= 3'b100;  TestAnsOpen[15] <= 1;    TestAnsDir[15] <= 2'b10; TestPassed[15] <= 1'bx;
        TestClk[16] <= 16'd16;  TestAnsPos[16] <= 3'b100;  TestAnsOpen[16] <= 0;    TestAnsDir[16] <= 2'b10; TestPassed[16] <= 1'bx;
        TestClk[17] <= 16'd17;  TestAnsPos[17] <= 3'b011;  TestAnsOpen[17] <= 0;    TestAnsDir[17] <= 2'b10; TestPassed[17] <= 1'bx;
        TestClk[18] <= 16'd18;  TestAnsPos[18] <= 3'b010;  TestAnsOpen[18] <= 0;    TestAnsDir[18] <= 2'b10; TestPassed[18] <= 1'bx;
        TestClk[19] <= 16'd19;  TestAnsPos[19] <= 3'b010;  TestAnsOpen[19] <= 1;    TestAnsDir[19] <= 2'b10; TestPassed[19] <= 1'bx;
        TestClk[20] <= 16'd20;  TestAnsPos[20] <= 3'b010;  TestAnsOpen[20] <= 0;    TestAnsDir[20] <= 2'b00; TestPassed[20] <= 1'bx;
        TestClk[21] <= 16'd21;  TestAnsPos[21] <= 3'b010;  TestAnsOpen[21] <= 0;    TestAnsDir[21] <= 2'b00; TestPassed[21] <= 1'bx;

        TestClk[22] <= 16'd22;  TestAnsPos[22] <= 3'b010;  TestAnsOpen[22] <= 0;    TestAnsDir[22] <= 2'b00; TestPassed[22] <= 1'bx;
        TestClk[23] <= 16'd23;  TestAnsPos[23] <= 3'b011;  TestAnsOpen[23] <= 0;    TestAnsDir[23] <= 2'b01; TestPassed[23] <= 1'bx;
        TestClk[24] <= 16'd24;  TestAnsPos[24] <= 3'b100;  TestAnsOpen[24] <= 0;    TestAnsDir[24] <= 2'b01; TestPassed[24] <= 1'bx;
        TestClk[25] <= 16'd25;  TestAnsPos[25] <= 3'b101;  TestAnsOpen[25] <= 0;    TestAnsDir[25] <= 2'b01; TestPassed[25] <= 1'bx;
        TestClk[26] <= 16'd26;  TestAnsPos[26] <= 3'b110;  TestAnsOpen[26] <= 0;    TestAnsDir[26] <= 2'b01; TestPassed[26] <= 1'bx;
        TestClk[27] <= 16'd27;  TestAnsPos[27] <= 3'b110;  TestAnsOpen[27] <= 1;    TestAnsDir[27] <= 2'b01; TestPassed[27] <= 1'bx;
        TestClk[28] <= 16'd28;  TestAnsPos[28] <= 3'b110;  TestAnsOpen[28] <= 0;    TestAnsDir[28] <= 2'b10; TestPassed[28] <= 1'bx;
        TestClk[29] <= 16'd29;  TestAnsPos[29] <= 3'b101;  TestAnsOpen[29] <= 0;    TestAnsDir[29] <= 2'b10; TestPassed[29] <= 1'bx;
        TestClk[30] <= 16'd30;  TestAnsPos[30] <= 3'b100;  TestAnsOpen[30] <= 0;    TestAnsDir[30] <= 2'b10; TestPassed[30] <= 1'bx;
        TestClk[31] <= 16'd31;  TestAnsPos[31] <= 3'b100;  TestAnsOpen[31] <= 1;    TestAnsDir[31] <= 2'b10; TestPassed[31] <= 1'bx;
        TestClk[32] <= 16'd32;  TestAnsPos[32] <= 3'b100;  TestAnsOpen[32] <= 0;    TestAnsDir[32] <= 2'b10; TestPassed[32] <= 1'bx;
        TestClk[33] <= 16'd33;  TestAnsPos[33] <= 3'b011;  TestAnsOpen[33] <= 0;    TestAnsDir[33] <= 2'b10; TestPassed[33] <= 1'bx;
        TestClk[34] <= 16'd34;  TestAnsPos[34] <= 3'b010;  TestAnsOpen[34] <= 0;    TestAnsDir[34] <= 2'b10; TestPassed[34] <= 1'bx;
        TestClk[35] <= 16'd35;  TestAnsPos[35] <= 3'b001;  TestAnsOpen[35] <= 0;    TestAnsDir[35] <= 2'b10; TestPassed[35] <= 1'bx;
        TestClk[36] <= 16'd36;  TestAnsPos[36] <= 3'b000;  TestAnsOpen[36] <= 0;    TestAnsDir[36] <= 2'b10; TestPassed[36] <= 1'bx;
        TestClk[37] <= 16'd37;  TestAnsPos[37] <= 3'b000;  TestAnsOpen[37] <= 1;    TestAnsDir[37] <= 2'b10; TestPassed[37] <= 1'bx;
        TestClk[38] <= 16'd38;  TestAnsPos[38] <= 3'b000;  TestAnsOpen[38] <= 0;    TestAnsDir[38] <= 2'b00; TestPassed[38] <= 1'bx;

        TestClk[39] <= 16'd39;  TestAnsPos[39] <= 3'b000;  TestAnsOpen[39] <= 0;    TestAnsDir[39] <= 2'b00; TestPassed[39] <= 1'bx;
        TestClk[40] <= 16'd40;  TestAnsPos[40] <= 3'b001;  TestAnsOpen[40] <= 0;    TestAnsDir[40] <= 2'b01; TestPassed[40] <= 1'bx;
        TestClk[41] <= 16'd41;  TestAnsPos[41] <= 3'b010;  TestAnsOpen[41] <= 0;    TestAnsDir[41] <= 2'b01; TestPassed[41] <= 1'bx;
        TestClk[42] <= 16'd42;  TestAnsPos[42] <= 3'b010;  TestAnsOpen[42] <= 1;    TestAnsDir[42] <= 2'b01; TestPassed[42] <= 1'bx;
        TestClk[43] <= 16'd43;  TestAnsPos[43] <= 3'b010;  TestAnsOpen[43] <= 0;    TestAnsDir[43] <= 2'b10; TestPassed[43] <= 1'bx;
        TestClk[44] <= 16'd44;  TestAnsPos[44] <= 3'b001;  TestAnsOpen[44] <= 0;    TestAnsDir[44] <= 2'b10; TestPassed[44] <= 1'bx;
        TestClk[45] <= 16'd45;  TestAnsPos[45] <= 3'b000;  TestAnsOpen[45] <= 0;    TestAnsDir[45] <= 2'b10; TestPassed[45] <= 1'bx;
        TestClk[46] <= 16'd46;  TestAnsPos[46] <= 3'b000;  TestAnsOpen[46] <= 1;    TestAnsDir[46] <= 2'b10; TestPassed[46] <= 1'bx;
        TestClk[47] <= 16'd47;  TestAnsPos[47] <= 3'b000;  TestAnsOpen[47] <= 0;    TestAnsDir[47] <= 2'b01; TestPassed[47] <= 1'bx;
        TestClk[48] <= 16'd48;  TestAnsPos[48] <= 3'b001;  TestAnsOpen[48] <= 0;    TestAnsDir[48] <= 2'b01; TestPassed[48] <= 1'bx;
        TestClk[49] <= 16'd49;  TestAnsPos[49] <= 3'b010;  TestAnsOpen[49] <= 0;    TestAnsDir[49] <= 2'b01; TestPassed[49] <= 1'bx;
        TestClk[50] <= 16'd50;  TestAnsPos[50] <= 3'b011;  TestAnsOpen[50] <= 0;    TestAnsDir[50] <= 2'b01; TestPassed[50] <= 1'bx;
        TestClk[51] <= 16'd51;  TestAnsPos[51] <= 3'b100;  TestAnsOpen[51] <= 0;    TestAnsDir[51] <= 2'b01; TestPassed[51] <= 1'bx;
        TestClk[52] <= 16'd52;  TestAnsPos[52] <= 3'b100;  TestAnsOpen[52] <= 1;    TestAnsDir[52] <= 2'b01; TestPassed[52] <= 1'bx;
        TestClk[53] <= 16'd53;  TestAnsPos[53] <= 3'b100;  TestAnsOpen[53] <= 0;    TestAnsDir[53] <= 2'b01; TestPassed[53] <= 1'bx;
        TestClk[54] <= 16'd54;  TestAnsPos[54] <= 3'b100;  TestAnsOpen[54] <= 1;    TestAnsDir[54] <= 2'b01; TestPassed[54] <= 1'bx;
        TestClk[55] <= 16'd55;  TestAnsPos[55] <= 3'b100;  TestAnsOpen[55] <= 0;    TestAnsDir[55] <= 2'b01; TestPassed[55] <= 1'bx;
        TestClk[56] <= 16'd56;  TestAnsPos[56] <= 3'b101;  TestAnsOpen[56] <= 0;    TestAnsDir[56] <= 2'b01; TestPassed[56] <= 1'bx;
        TestClk[57] <= 16'd57;  TestAnsPos[57] <= 3'b110;  TestAnsOpen[57] <= 0;    TestAnsDir[57] <= 2'b01; TestPassed[57] <= 1'bx;
        TestClk[58] <= 16'd58;  TestAnsPos[58] <= 3'b110;  TestAnsOpen[58] <= 1;    TestAnsDir[58] <= 2'b01; TestPassed[58] <= 1'bx;
        TestClk[59] <= 16'd59;  TestAnsPos[59] <= 3'b110;  TestAnsOpen[59] <= 0;    TestAnsDir[59] <= 2'b00; TestPassed[59] <= 1'bx;
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
                $display("Test finished!");
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
