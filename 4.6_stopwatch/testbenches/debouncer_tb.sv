`timescale 1ns/1ps
`default_nettype none

module debouncer_tb;

    localparam CLK_PERIOD_NS = 10;
    localparam DELAY_NS = 1000;
    logic clk_i;
    logic btn_i;
    wire pulse_o;

    debouncer #(
        .DELAY_NS(DELAY_NS)
        ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("debouncer.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        btn_i = 0;
        repeat(8) @(negedge clk_i);
        btn_i = 1;
        repeat(5) @(negedge clk_i);
        btn_i = 0;
        repeat(5) @(negedge clk_i);
        btn_i = 1;
        repeat(5) @(negedge clk_i);
        btn_i = 0;
        repeat(100000) @(negedge clk_i);
        $finish;
    end

endmodule
