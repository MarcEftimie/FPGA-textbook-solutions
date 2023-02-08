`timescale 1ns/1ps
`default_nettype none

module float_to_int_converter_tb;
    
    localparam CLK_PERIOD_NS = 10;
    logic [12:0] float_i;
    wire [7:0] int_o;
    wire overflow, underflow;
    logic clk;

    float_to_int_converter UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk = ~clk;

    initial begin
        $dumpfile("float_to_int_converter.fst");
        $dumpvars(0, UUT);
        clk = 0;
        for (int i = 0; i < 2 ** 13; i++) begin
            float_i = i;
            #1
            $display("Float : %b Int : %b Overflow : %b Underflow : %b", float_i, int_o, overflow, underflow);
        end
        #1
        $finish;
    end

endmodule