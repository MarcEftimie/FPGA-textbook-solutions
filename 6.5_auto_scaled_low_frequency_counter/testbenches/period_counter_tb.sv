`timescale 1ns/1ps
`default_nettype none

module period_counter_tb;

    parameter CLK_PERIOD_NS = 10;
    logic clk_i, reset_i;
    logic tick_i;
    wire [31:0] period_count_o;
    wire done_o;

    period_counter UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("period_counter.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        reset_i = 1;
        tick_i = 0;
        repeat(8) @(negedge clk_i);
        reset_i = 0;
        repeat(2) @(negedge clk_i);
        tick_i = 1;
        repeat(1) @(negedge clk_i);
        tick_i = 0;
        repeat(4) @(negedge clk_i);
        tick_i = 1;
        repeat(1) @(negedge clk_i);
        tick_i = 0;
        repeat(2) @(negedge clk_i);
        tick_i = 1;
        repeat(1) @(negedge clk_i);
        tick_i = 0;
        repeat(250) @(negedge clk_i);
        tick_i = 1;
        repeat(1) @(negedge clk_i);
        tick_i = 0;
        repeat(50) @(negedge clk_i);
        $finish;
    end

endmodule
