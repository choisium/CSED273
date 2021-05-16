/* CSED273 lab6 experiments */
/* lab6_tb.v */

`timescale 1ps / 1fs

module lab6_tb();

    integer Passed;
    integer Failed;

    /* Define input, output and instantiate module */
    reg reset_n, clk;
    wire[3:0] out1;
    wire[7:0] out2;
    wire[3:0] out3;

    decade_counter DC(
        .reset_n(reset_n),
        .clk(clk),
        .count(out1)
    );

    decade_counter_2digits DC_2digits(
        .reset_n(reset_n),
        .clk(clk),
        .count(out2)
    );

    counter_369 Counter369(
        .reset_n(reset_n),
        .clk(clk),
        .count(out3)
    );

    always begin
        clk = !clk; #5;
    end

    initial begin
        Passed = 0;
        Failed = 0;

        reset_n = 1;
        clk = 0;

        lab6_1_test;
        lab6_2_test;
        lab6_3_test;

        $display("Lab6 Passed = %0d, Failed = %0d", Passed, Failed);
        $finish;
    end

    /* Implement test task for lab6_1 */
    task lab6_1_test;
        integer i;
        reg[3:0] out_expected;

        begin
            reset_n = 0;
            #10 reset_n = 1;

            for (i = 0; i < 15; i = i + 1) begin
                out_expected = i % 10;

                if (out1 == out_expected) begin
                    Passed = Passed + 1;
                end
                else begin
                    $display("Failed) i = %0b, out: %0b (Ans: %0b)", i, out1, out_expected);
                    Failed = Failed + 1;
                end

                #10;
            end
        end
    endtask

    /* Implement test task for lab6_2 */
    task lab6_2_test;
        integer i;
        reg[3:0] lower_out_expected;
        reg[3:0] upper_out_expected;

        begin
            lower_out_expected = 0;
            upper_out_expected = 0;

            reset_n = 0;
            #15 reset_n = 1;

            for (i = 0; i < 110; i = i + 1) begin
                if (out2 == {upper_out_expected, lower_out_expected}) begin
                    Passed = Passed + 1;
                end
                else begin
                    $display("Failed) i = %0b, out: %0b (Ans: %0b)", i, out2, {upper_out_expected, lower_out_expected});
                    Failed = Failed + 1;
                end

                if (lower_out_expected == 4'd9) begin
                    if (upper_out_expected == 4'd9) begin
                        upper_out_expected = 0;
                    end else begin
                        upper_out_expected = upper_out_expected + 1;
                    end
                    lower_out_expected = 0;
                end else begin
                    lower_out_expected = lower_out_expected + 1;
                end

                #10;
            end
        end
    endtask

    // /* Implement test task for lab6_3 */
    task lab6_3_test;
        integer i;
        reg[3:0] out_expected;

        begin
            out_expected = 0;
            reset_n = 0;
            #15 reset_n = 1;

            for (i = 0; i < 10; i = i + 1) begin
                if (out3 == out_expected) begin
                    Passed = Passed + 1;
                end
                else begin
                    $display("Failed) i = %0b, out: %0b (Ans: %0b)", i, out3, out_expected);
                    Failed = Failed + 1;
                end

                #10;

                case(out_expected)
                    4'd0: out_expected = 3;
                    4'd3: out_expected = 6;
                    4'd6: out_expected = 9;
                    4'd9: out_expected = 13;
                    4'd13: out_expected = 6;
                endcase
            end
        end
    endtask

endmodule