`timescale 1ns/1ps
`default_nettype none

module greater_than_2_bit_tb;

    localparam CLK_PERIOD_NS = 10;
    localparam NUM_OF_BITS = 2;
    logic [1:0] a, b;
    logic out;
    logic clk;

    greater_than_2_bit UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk = ~clk;

    initial begin
        $dumpfile("greater_than_2_bit.fst");
        $dumpvars(0, UUT);
        clk = 0;
        for (int i = 0; i < NUM_OF_BITS << 1; i++) begin
            for (int j = 0; j < NUM_OF_BITS << 1; j++) begin
                a = i;
                b = j;
                #1;
                if (out != a > b) begin
                    $display("Error: a %b b %b out %b", a, b, out);
                end
                #1;
            end
        end

        $finish;
    end

endmodule