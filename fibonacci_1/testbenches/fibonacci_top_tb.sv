`timescale 1ns/1ps
`default_nettype none

module fibonacci_top_tb;

    parameter CLK_PERIOD_NS = 10;
    logic clk_i, reset_i;
    logic start_i;
    logic [7:0] iterations_bcd_i;
    wire [6:0] seven_segment_o;
    wire [15:0] fibonacci_num_BCD_reg;
    wire [3:0] an_o;
    wire [6:0] iter_o;
    wire dp_o;  

    fibonacci_top UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("fibonacci_top.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        reset_i = 1;
        start_i = 0;
        repeat(2) @(negedge clk_i);
        reset_i = 0;
        iterations_bcd_i = 8'b00000001;
        repeat(2) @(negedge clk_i);
        start_i = 1;
        repeat(4) @(negedge clk_i);
        start_i = 0;
        repeat(100) @(negedge clk_i);
        start_i = 1;
        repeat(4) @(negedge clk_i);
        start_i = 0;
        repeat(100) @(negedge clk_i);
        start_i = 1;
        repeat(4) @(negedge clk_i);
        start_i = 0;
        repeat(100) @(negedge clk_i);
        start_i = 1;
        repeat(4) @(negedge clk_i);
        start_i = 0;
        repeat(100) @(negedge clk_i);

        $finish;
    end

endmodule
