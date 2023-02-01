`timescale 1ns/1ps
`default_nettype none

module dual_edge_detector_moore_tb;

    localparam CLK_PERIOD_NS = 10;
    logic clk_i;
    logic signal_i;
    wire pulse_o;

    dual_edge_detector_moore UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("dual_edge_detector_moore.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        repeat(4) @(negedge clk_i)
        signal_i = 0;
        repeat(4) @(negedge clk_i)
        signal_i = 1;
        repeat(4) @(negedge clk_i)
        signal_i = 0;
        repeat(4) @(negedge clk_i)
        signal_i = 1;
        repeat(4) @(negedge clk_i)
        signal_i = 0;
        repeat(4) @(negedge clk_i)
        signal_i = 1;
        $finish;
    end

endmodule
