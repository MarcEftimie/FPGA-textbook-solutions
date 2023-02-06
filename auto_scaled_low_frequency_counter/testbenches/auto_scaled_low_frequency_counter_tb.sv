`timescale 1ns/1ps
`default_nettype none

module auto_scaled_low_frequency_counter_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter DELAY_NS = 10;
    logic clk_i, reset_i;
    logic btn_i;
    wire [3:0] an_o;
    wire [6:0] seven_segment_o;
    wire dp_o;
    wire [15:0] test_o;

    auto_scaled_low_frequency_counter #(
        .DELAY_NS(DELAY_NS)
        ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("auto_scaled_low_frequency_counter.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        reset_i = 1;
        btn_i = 0;
        repeat(8) @(negedge clk_i);
        reset_i = 0;
        repeat(2) @(negedge clk_i);
        btn_i = 1;
        repeat(2) @(negedge clk_i);
        btn_i = 0;
        repeat(500000) @(negedge clk_i);
        btn_i = 1;
        repeat(500) @(negedge clk_i);
        repeat(2) @(negedge clk_i);
        btn_i = 0;
        repeat(2) @(negedge clk_i);
        btn_i = 1;
        repeat(2) @(negedge clk_i);
        btn_i = 0;
        // repeat(40050) @(negedge clk_i);
        // btn_i = 1;
        // repeat(5000) @(negedge clk_i);
        $finish;
    end

endmodule
