`timescale 1ns/1ps
`default_nettype none

module stopwatch_tb;

    localparam CLK_PERIOD_NS = 10;
    localparam N = 12;
    logic clk_i;
    logic rst_i;
    wire [3:0] an_o;
    wire [6:0] sseg_o;

    stopwatch #(
        .N(N)
        ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("stopwatch.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        rst_i = 1;
        repeat(4) @(negedge clk_i)
        rst_i = 0;
        repeat(4) @(negedge clk_i)
        for (int i=0; i < 2 ** N; i++) begin
            repeat(50) @(negedge clk_i);
        end
        $finish;
    end

endmodule