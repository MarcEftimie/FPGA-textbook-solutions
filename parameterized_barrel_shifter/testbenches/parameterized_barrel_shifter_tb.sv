`timescale 1ns/1ps
`default_nettype none

module parameterized_barrel_shifter_tb;

    localparam CLK_PERIOD_NS = 10;
    localparam N = 8;
    logic [N-1:0] data_i;
    logic [$clog2(N)-1:0] shift_amount_i;
    logic shift_direction_i;
    wire [N-1:0] shifted_data_o;
    logic clk;

    parameterized_barrel_shifter #(.N(N)) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk = ~clk;

    initial begin
        $dumpfile("parameterized_barrel_shifter.fst");
        $dumpvars(0, UUT);
        clk = 0;
        data_i = 8'b11110000;
        #1
        for (int i = 0; i < 2; i++) begin
            for (int j = 0; j < N; j++) begin
                shift_direction_i = i;
                shift_amount_i = j;
                #1
                $display("Shift Direction : %b Shift Amount : %b Data : %b Shifted Data : %b", shift_direction_i, shift_amount_i, data_i, shifted_data_o);
                #1;
            end
        end

        $finish;
    end

endmodule