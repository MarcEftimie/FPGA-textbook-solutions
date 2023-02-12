`timescale 1ns/1ps
`default_nettype none

module stack_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter ADDR_WIDTH = 4;
    parameter DATA_WIDTH = 4;
    logic clk_i, reset_i;
    logic pop_i, push_i;
    logic [3:0] write_data_i;
    wire empty_o, full_o;
    wire [3:0] read_data_o;

    stack #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
        ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("stack.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        reset_i = 1;
        push_i = 0;
        pop_i = 0;
        repeat(1) @(negedge clk_i);
        reset_i = 0;
        repeat(1) @(negedge clk_i);
        write_data_i = 1;
        push_i = 1;
        repeat(1) @(negedge clk_i);
        write_data_i = 2;
        repeat(1) @(negedge clk_i);
        write_data_i = 3;
        repeat(1) @(negedge clk_i);
        write_data_i = 4;
        repeat(1) @(negedge clk_i);
        write_data_i = 5;
        repeat(1) @(negedge clk_i);
        push_i = 0;
        pop_i = 1;
        repeat(10) @(negedge clk_i);


        $finish;
    end

endmodule
