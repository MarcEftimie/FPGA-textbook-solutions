
`timescale 1ns/1ps
`default_nettype none

module dual_mode_comparator_tb;

    parameter CLK_PERIOD_NS = 10;
    
    logic clk_i;
    logic [7:0] a_i, b_i;
    logic signed_i;
    wire agtb_o;

    dual_mode_comparator UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("dual_mode_comparator.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        signed_i = 1;
        repeat(1) @(negedge clk_i);
        a_i = 8'h0F;
        b_i = 8'hFF;
        repeat(1) @(negedge clk_i);
        for(int i=0; i<8; i++) begin
            b_i = i;
            repeat(1) @(negedge clk_i);
        end
        $finish;
    end

endmodule
