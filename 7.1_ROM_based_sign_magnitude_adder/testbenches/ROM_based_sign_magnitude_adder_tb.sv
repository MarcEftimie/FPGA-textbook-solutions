`timescale 1ns/1ps
`default_nettype none

module ROM_based_sign_magnitude_adder_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter ADDR_WIDTH = 8;
    parameter DATA_WIDTH = 5;
    logic clk_i;
    logic [3:0] a_i, b_i;
    wire [4:0] sum_o;

    ROM_based_sign_magnitude_adder #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
        ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("ROM_based_sign_magnitude_adder.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        repeat(2) @(negedge clk_i);
        for (int i=0; i<16; i++) begin
            for (int j=i; j<16; j++) begin
                a_i = i;
                b_i = j;
                repeat(2) @(negedge clk_i);
                $display("a: %d b: %d sum: %d", a_i, b_i, sum_o);
                repeat(2) @(negedge clk_i);
            end
        end
        $finish;
    end

endmodule
