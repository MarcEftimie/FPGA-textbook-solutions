`timescale 1ns/1ps
`default_nettype none

module BCD_incrementor_tb;

    localparam CLK_PERIOD_NS = 10;
    logic [11:0] BCD_in;
    wire [11:0] BCD_out;
    logic clk;

    BCD_incrementor UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk = ~clk;

    initial begin
        $dumpfile("BCD_incrementor.fst");
        $dumpvars(0, UUT);
        clk = 0;
        #1
        for (int i = 0; i < 1; i++) begin
            for (int j = 0; j < 10; j++) begin
                for (int k = 0; k < 10; k++) begin
                    #1
                    BCD_in = {i[3:0], j[3:0], k[3:0]};
                    #1
                    $display("BCD_in : %d BCD_out : %h", BCD_in, BCD_out);
                    #1;
                end
            end
        end
        $finish;
    end

endmodule
