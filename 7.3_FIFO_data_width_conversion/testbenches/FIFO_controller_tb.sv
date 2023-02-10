`timescale 1ns/1ps
`default_nettype none

module FIFO_controller_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter ADDR_WIDTH = 4;
    logic clk_i, reset_i;
    logic read_i, write_i;
    wire empty_o, full_o;
    wire [ADDR_WIDTH-1:0] write_address_o, read_address_o;

    FIFO_controller #(
        .ADDR_WIDTH(ADDR_WIDTH)
        ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("FIFO_controller.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        reset_i = 1;
        repeat(2) @(negedge clk_i);
        reset_i = 0;
        repeat(2) @(negedge clk_i);
        for (int i=0; i<17; i++) begin
            write_i = 1;
            read_i = 0;
            repeat(1) @(negedge clk_i);
        end
        for (int i=0; i<17; i++) begin
            write_i = 0;
            read_i = 1;
            repeat(1) @(negedge clk_i);
        end
        for (int i=0; i<17; i++) begin
            write_i = 1;
            read_i = 1;
            repeat(1) @(negedge clk_i);
        end
        $finish;
    end

endmodule
