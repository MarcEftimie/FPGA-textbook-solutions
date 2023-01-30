`timescale 1ns/1ps
`default_nettype none

module stopwatch_tb;

    localparam CLK_PERIOD_NS = 10;
    localparam TICK_NS = 10; //10000000
    logic clk_i;
    logic rst_i;
    logic start_i;
    logic stop_i;
    wire [3:0] an_o;
    wire [6:0] sseg_o;
    wire dp_o;

    stopwatch #(
        .TICK_NS(TICK_NS)
        ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("stopwatch.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        rst_i = 1;
        repeat(4) @(negedge clk_i);
        rst_i = 0;
        repeat(4) @(negedge clk_i);
        for (int i=0; i < 2 ** TICK_NS; i++) begin
            repeat(50) @(negedge clk_i);
        end
        $finish;
    end

endmodule