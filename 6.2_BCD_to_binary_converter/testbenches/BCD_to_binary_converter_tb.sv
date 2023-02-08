`timescale 1ns/1ps
`default_nettype none

module BCD_to_binary_converter_tb;

    localparam CLK_PERIOD_NS = 10;
    localparam N = 13;
    logic clk_i, reset_i;
    logic start_i;
    logic [N-1:0] BCD_i;
    wire ready_o, done_o;
    wire [31:0] binary_o;

    BCD_to_binary_converter UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("BCD_to_binary_converter.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        reset_i = 1;
        BCD_i = 32'h00000042;
        repeat(2) @(negedge clk_i);
        reset_i = 0;
        repeat(2) @(negedge clk_i);
        start_i = 1;
        repeat(2) @(negedge clk_i);
        start_i = 0;
        repeat(2) @(negedge clk_i);
        repeat(100) @(negedge clk_i);
        $finish;
    end

endmodule
