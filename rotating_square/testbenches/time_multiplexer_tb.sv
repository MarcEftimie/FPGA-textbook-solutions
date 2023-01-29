`timescale 1ns/1ps
`default_nettype none

module time_multiplexer_tb;

    localparam CLK_PERIOD_NS = 10;
    localparam N = 8;
    logic clk_i;
    logic rst_i;
    logic [6:0] in0_i, in1_i, in2_i, in3_i;
    wire [3:0] an_o;
    wire [7:0] sseg_o;

    time_multiplexer #(
        .N(N)
        ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("time_multiplexer.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        rst_i = 1;
        in0_i = 7'hAA;
        in1_i = 7'hBB;
        in2_i = 7'hCC;
        in3_i = 7'hDD;
        repeat(3) @(negedge clk_i);
        rst_i = 0;
        repeat(2 ** 9) @(negedge clk_i);
        $finish;
    end
    
endmodule