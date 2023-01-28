`timescale 1ns/1ps
`default_nettype none

module pwd_generator_tb;

    localparam CLK_PERIOD_NS = 10;
    logic clk_i;
    logic rst_i;
    logic [3:0] duty_cycle_i;
    wire pwm_o;

    pwd_generator UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("pwd_generator.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        for (int i=0; i < 16; i++) begin
            duty_cycle_i = i;
            repeat(50) @(negedge clk_i);
        end
        $finish;
    end

endmodule