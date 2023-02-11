`timescale 1ns/1ps
`default_nettype none

module FIFO_controller_width_conversion_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter ADDR_WIDTH = 4;
    logic clk_i, reset_i;
    logic read_i, write_i;
    wire empty_o, full_o;
    wire [ADDR_WIDTH-1:0] write_address_1_o, write_address_2_o, read_address_o;

    FIFO_controller_width_conversion #(
        .ADDR_WIDTH(ADDR_WIDTH)
        ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("FIFO_controller_width_conversion.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        reset_i = 1;
        write_i = 0;
        read_i = 0;
        repeat(2) @(negedge clk_i);
        reset_i = 0;
        repeat(2) @(negedge clk_i);
        write_i = 1;
        repeat(3) @(negedge clk_i);
        write_i = 0;
        read_i = 1;
        repeat(9) @(negedge clk_i);
        write_i = 1;
        read_i = 0;
        repeat(20) @(negedge clk_i);
        write_i = 1;
        read_i = 1;
        repeat(16) @(negedge clk_i);


        // for (int i=0; i<17; i++) begin
        //     write_i = 1;
        //     read_i = 0;
        //     repeat(1) @(negedge clk_i);
        // end
        // for (int i=0; i<18; i++) begin
        //     write_i = 0;
        //     read_i = 1;
        //     repeat(1) @(negedge clk_i);
        // end
        // for (int i=0; i<3; i++) begin
        //     write_i = 1;
        //     read_i = 0;
        //     repeat(1) @(negedge clk_i);
        // end
        $finish;
    end

endmodule
