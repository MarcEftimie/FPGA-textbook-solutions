`timescale 1ns/1ps
`default_nettype none

module binary_to_BCD_converter_tb;

    localparam CLK_PERIOD_NS = 10;
    localparam bin_N = 16;
    localparam bcd_N = 20;
    logic clk_i, reset_i;
    logic start_i;
    logic [31:0] binary_i;
    wire ready_o, done_o;
    wire [39:0] BCD_o;

    binary_to_BCD_converter #(
        .bin_N(bin_N),
        .bcd_N(bcd_N)
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("binary_to_BCD_converter.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        reset_i = 1;
        repeat(2) @(negedge clk_i);
        reset_i = 0;
        repeat(2) @(negedge clk_i);
        for (int i = 0; i < 128; i++) begin
            binary_i = i;
            repeat(2) @(negedge clk_i)
            start_i = 1;
            repeat(2) @(negedge clk_i);
            start_i = 0;
            repeat(1) @(posedge done_o)
            $display("binary_i: %d BCD_o: %h", binary_i, BCD_o);
            // $displayh("BCD_o: %h", BCD_o);
        end
        start_i = 1;
        repeat(2) @(negedge clk_i);
        start_i = 0;
        repeat(100) @(negedge clk_i);
        $finish;
    end

endmodule
