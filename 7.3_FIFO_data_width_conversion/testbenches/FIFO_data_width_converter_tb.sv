`timescale 1ns/1ps
`default_nettype none

module FIFO_data_width_converter_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter ADDR_WIDTH = 4;
    parameter DATA_WIDTH = 4;
    logic clk_i, reset_i;
    logic read_i, write_i;
    logic [7:0] write_data_i;
    wire empty_o, full_o;
    wire [3:0] read_data_o;

    FIFO_data_width_converter #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
        ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("FIFO_data_width_converter.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        reset_i = 1;
        write_i = 0;
        read_i = 0;
        write_data_i = 0;
        repeat(2) @(negedge clk_i);
        reset_i = 0;
        repeat(2) @(negedge clk_i);
        write_data_i = 1;
        write_i = 1;
        repeat(3) @(negedge clk_i);
        write_i = 0;
        read_i = 1;
        repeat(9) @(negedge clk_i);
        read_i = 0;
        write_data_i = 1;
        write_i = 1;
        repeat(3) @(negedge clk_i);
        write_i = 0;
        read_i = 1;
        repeat(9) @(negedge clk_i);
        write_i = 1;
        read_i = 1;
        repeat(9) @(negedge clk_i);
        
        $finish;
    end

endmodule
