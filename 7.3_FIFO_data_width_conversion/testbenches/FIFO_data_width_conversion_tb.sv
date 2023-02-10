`timescale 1ns/1ps
`default_nettype none

module FIFO_data_width_conversion_tb;

    parameter CLK_PERIOD_NS = 10;
    parameter ADDR_WIDTH = 9;
    parameter DATA_WIDTH = 8;
    logic clk_i;
    logic [DATA_WIDTH-1:0] temperature_i;
    logic unit_i;
    wire [DATA_WIDTH-1:0] temperature_o;

    FIFO_data_width_conversion #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
        ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("FIFO_data_width_conversion.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        unit_i = 0;
        repeat(2) @(negedge clk_i);
        for (int i=0; i<101; i++) begin
            temperature_i = i;
            repeat(2) @(negedge clk_i);
            $display("Celsius: %d Farenheit: %d", temperature_i, temperature_o);
            repeat(2) @(negedge clk_i);
        end
        unit_i = 1;
        repeat(2) @(negedge clk_i);
        for (int j=32; j<213; j++) begin
            temperature_i = j;
            repeat(2) @(negedge clk_i);
            $display("Celsius: %d Farenheit: %d", temperature_i, temperature_o);
            repeat(2) @(negedge clk_i);
        end
        $finish;
    end

endmodule
