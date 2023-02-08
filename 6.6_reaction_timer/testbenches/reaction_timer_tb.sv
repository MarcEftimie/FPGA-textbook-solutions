`timescale 1ns/1ps
`default_nettype none

module reaction_timer_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter DELAY_NS = 20;
    parameter BIN_N = 16;
    parameter BCD_N = 20;
    parameter TICK_N = 14;
    logic clk_i, reset_i;
    logic clear_i, start_i, stop_i;
    wire [3:0] an_o;
    wire [6:0] seven_segment_o;
    wire dp_o;

    reaction_timer #(
        .DELAY_NS(DELAY_NS),
        .BIN_N(BIN_N),
        .BCD_N(BCD_N),
        .TICK_N(TICK_N)
        ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("reaction_timer.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        reset_i = 1;
        repeat(2) @(negedge clk_i);
        reset_i = 0;
        repeat(2) @(negedge clk_i);
        clear_i = 1;
        stop_i = 0;
        repeat(2) @(negedge clk_i);
        clear_i = 0;
        repeat(2) @(negedge clk_i);
        start_i = 1;
        repeat(2) @(negedge clk_i);
        start_i = 0;
        repeat(12000) @(negedge clk_i);
        stop_i = 1;
        repeat(2) @(negedge clk_i);
        stop_i = 0;
        repeat(1000) @(negedge clk_i);
        repeat(2) @(negedge clk_i);
        clear_i = 1;
        stop_i = 0;
        repeat(2) @(negedge clk_i);
        clear_i = 0;
        repeat(10) @(negedge clk_i);
        start_i = 1;
        repeat(2) @(negedge clk_i);
        start_i = 0;
        repeat(12000) @(negedge clk_i);
        stop_i = 1;
        repeat(2) @(negedge clk_i);
        stop_i = 0;
        repeat(1000) @(negedge clk_i);
        $finish;
    end

endmodule
