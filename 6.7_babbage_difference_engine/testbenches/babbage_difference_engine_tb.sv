`timescale 1ns/1ps
`default_nettype none

module babbage_difference_engine_tb;

    parameter CLK_PERIOD_NS = 10;
    logic clk_i, reset_i;
    logic compute_i;
    logic [5:0] n;
    wire [15:0] f_of_n_o;

    babbage_difference_engine UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("babbage_difference_engine.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        reset_i = 1;
        compute_i = 0;
        repeat(2) @(negedge clk_i);
        reset_i = 0;
        repeat(2) @(negedge clk_i);
        n = 13;
        repeat(2) @(negedge clk_i);
        compute_i = 1;
        repeat(2) @(negedge clk_i);
        compute_i = 0;
        repeat(30) @(negedge clk_i);
        $finish;
    end

endmodule
