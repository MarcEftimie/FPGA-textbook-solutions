`timescale 1ns/1ps
`default_nettype none

module fibonacci_generator_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter DELAY_NS = 10;
    logic clk_i, reset_i;
    logic start_i;
    logic [4:0] iterations_i;
    wire ready_o, done_o;
    wire overflow_o;
    wire [19:0] fibonacci_o;

    fibonacci_generator UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("fibonacci_generator.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        reset_i = 1;
        repeat(2) @(negedge clk_i);
        reset_i = 0;
        repeat(2) @(negedge clk_i);
        iterations_i = 5'b11111;
        start_i = 1;
        repeat(2) @(negedge clk_i);
        start_i = 0;
        repeat(100) @(negedge clk_i);
        $finish;
    end

endmodule
