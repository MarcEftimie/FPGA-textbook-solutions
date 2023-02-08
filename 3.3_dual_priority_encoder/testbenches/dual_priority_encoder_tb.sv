`timescale 1ns/1ps
`default_nettype none

module dual_priority_encoder_tb;

    localparam CLK_PERIOD_NS = 10;
    localparam N = 12;
    logic [N-1:0] req_i;
    wire [$clog2(N)-1:0] first_o;
    wire [$clog2(N)-1:0] second_o;
    logic clk;

    dual_priority_encoder #(.N(N)) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk = ~clk;

    initial begin
        $dumpfile("dual_priority_encoder.fst");
        $dumpvars(0, UUT);
        clk = 0;
        #1
        for (int i = 0; i < 2 ** N; i++) begin
            req_i = i;
            #1
            $display("Req : %b First : %b Second : %b", req_i, first_o, second_o);
            #1;
        end
        $finish;
    end
endmodule