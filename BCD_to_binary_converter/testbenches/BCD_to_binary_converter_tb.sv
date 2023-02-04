`timescale 1ns/1ps
`default_nettype none

module BCD_to_binary_converter_tb;

    localparam CLK_PERIOD_NS = 10;
    logic clk_i;
    logic [39:0] BCD_i;
    wire [31:0] binary_o;

    BCD_to_binary_converter UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("BCD_to_binary_converter.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        repeat(2) @(negedge clk_i);
        BCD_i = 32'h00001010;
        repeat(100) @(negedge clk_i);
        $finish;
    end

endmodule
