`timescale 1ns/1ps
`default_nettype none

module floating_point_greater_than_tb;

    localparam CLK_PERIOD_NS = 10;
    logic [12:0] a;
    logic [12:0] b;
    wire gt;
    logic clk;

    floating_point_greater_than UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk = ~clk;

    initial begin
        $dumpfile("floating_point_greater_than.fst");
        $dumpvars(0, UUT);
        clk = 0;
        b = 13'b1010011001010;
        #1
        for (int i = 0; i < 2; i++) begin
            for (int j = 0; j < (2 ** 4); j++) begin
                for (int k = 0; k < (2 ** 8); k++) begin
                    a = {i[0], j[3:0], k[7:0]};
                    #1
                    $display("a : %b b : %b gt : %b", a, b, gt);
                    #1;
                end
            end
        end
        $finish;
    end

endmodule