`timescale 1ns/1ps
`default_nettype none

module decoder_2_to_4_tb;

    localparam CLK_PERIOD_NS = 10;
    localparam NUM_OF_BITS = 2;
    logic [NUM_OF_BITS-1:0] a;
    logic ena, out;
    logic clk;

    decoder_2_to_4 UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk = ~clk;

    initial begin
        $dumpfile("decoder_2_to_4.fst");
        $dumpvars(0, UUT);
        clk = 0;
        ena = 1;
        for (int i = 0; i < NUM_OF_BITS ** 2; i++) begin
            a = i;
            $display("Error: a %b out %b", a, out);
            #1;
        end
        $finish;
    end

endmodule