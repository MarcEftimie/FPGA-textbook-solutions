`timescale 1ns/1ps
`default_nettype none

module delayed_detection_debouncing_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter DELAY_NS = 10;
    logic clk_i;
    logic btn_i;
    wire debounced_o;

    delayed_detection_debouncing #(
        .DELAY_NS(DELAY_NS)
        ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("delayed_detection_debouncing.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        repeat(8) @(negedge clk_i);
        btn_i = 1;
        repeat(5) @(negedge clk_i);
        btn_i = 0;
        repeat(5) @(negedge clk_i);
        btn_i = 1;
        repeat(5) @(negedge clk_i);
        btn_i = 0;
        repeat(5) @(negedge clk_i);
        btn_i = 1;
        repeat(100) @(negedge clk_i);
        btn_i = 0;
        repeat(5) @(negedge clk_i);
        btn_i = 1;
        repeat(5) @(negedge clk_i);
        btn_i = 0;
        repeat(100) @(negedge clk_i);
        $finish;
    end

endmodule
