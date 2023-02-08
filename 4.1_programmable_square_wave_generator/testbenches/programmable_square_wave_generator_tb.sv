`timescale 1ns/1ps
`default_nettype none

module programmable_square_wave_generator_tb;

    localparam CLK_PERIOD_NS = 10;
    logic clk_i;
    logic rst_i;
    logic [3:0] on_duty_i;
    logic [3:0] off_duty_i;
    wire square_wave_o;

    programmable_square_wave_generator UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("programmable_square_wave_generator.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        on_duty_i = 1;
        off_duty_i = 1;
        repeat(28) @(negedge clk_i);
        on_duty_i = 3;
        off_duty_i = 6;
        repeat(2400) @(negedge clk_i);
        $finish;
    end

endmodule