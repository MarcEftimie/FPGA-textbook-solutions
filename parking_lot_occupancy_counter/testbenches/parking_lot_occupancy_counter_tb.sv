`timescale 1ns/1ps
`default_nettype none

module parking_lot_occupancy_counter_tb;

    localparam CLK_PERIOD_NS = 10;
    logic clk_i;
    logic reset_i;
    logic sensor_a_i;
    logic sensor_b_i;
    wire [6:0] seven_segment_o;
    wire [3:0] an_o;

    parking_lot_occupancy_counter UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("parking_lot_occupancy_counter.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        reset_i = 1;
        repeat(4) @(negedge clk_i);
        reset_i = 0;
        repeat(4) @(negedge clk_i);
        
        repeat(1000) @(negedge clk_i);
        $finish;
    end 
endmodule
