`timescale 1ns/1ps
`default_nettype none

module BCD_normalizer_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter N = 32;
    logic clk_i, reset_i;
    logic start_i;
    logic [N-1:0] BCD_i;
    wire done_o;
    wire [N-1:0] BCD_o; 
    wire power_o;

    BCD_normalizer UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("BCD_normalizer.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        reset_i = 1;
        BCD_i = 32'h00000007;
        repeat(8) @(negedge clk_i);
        reset_i = 0;
        repeat(2) @(negedge clk_i);
        start_i = 1;
        repeat(2) @(negedge clk_i);
        start_i = 0;
        repeat(50) @(negedge clk_i);
        $finish;
    end

endmodule
