
`timescale 1ns/1ps
`default_nettype none

module shift_register_blocking_and_nonblocking_tb;

    parameter CLK_PERIOD_NS = 10;
    
    logic clk_i, reset_i;
    logic x0;
    wire x1;

    shift_register_blocking_and_nonblocking #(
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("shift_register_blocking_and_nonblocking.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        reset_i = 1;
        x0 = 0;
        repeat(1) @(negedge clk_i);
        x0 = 1;
        reset_i = 0;
        repeat(10) @(negedge clk_i);
        $finish;
    end

endmodule
