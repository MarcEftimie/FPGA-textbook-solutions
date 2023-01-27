`timescale 1ns/1ps
`default_nettype none

module int_float_converter_tb;
    
    localparam CLK_PERIOD_NS = 10;
    logic [7:0] int_i;
    wire [12:0] float_o;
    logic clk;

    int_to_float_converter UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk = ~clk;

    initial begin
        $dumpfile("int_to_float_converter.fst");
        $dumpvars(0, UUT);
        clk = 0;
        for (int i = 0; i < 2 ** 8; i++) begin
            int_i = i;
            #1
            $display("Int : %b Float : %b", int_i, float_o);
        end
        #1
        $finish;
    end

endmodule