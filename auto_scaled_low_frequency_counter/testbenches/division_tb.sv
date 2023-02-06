`timescale 1ns/1ps
`default_nettype none

module division_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter N = 32;
    logic clk_i, reset_i;
    logic start_i;
    logic [N-1:0] dividend_i, divisor_i;
    wire [N-1:0] quotient_o, remainder_o; 
    wire done_o;

    division UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("division.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        reset_i = 1;
        start_i = 0;
        // dividend_i = 32'h10000007;
        // divisor_i = 32'h00000001;
        dividend_i = 1000000;
        divisor_i = 2000000;
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
