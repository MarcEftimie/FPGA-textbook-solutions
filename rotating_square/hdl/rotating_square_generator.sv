`timescale 1ns/1ps
`default_nettype none

module rotating_square_generator #(
    parameter N = 18
    parameter TOP_SQUARE = 7'b0011100;
    parameter BOTTOM_SQUARE = 7'b1100010;
    )(
    input wire clk_i,
    input wire rst_i,
    output logic [3:0] an_o,
    output logic [6:0] sseg_o
);

    logic [6:0] in0_i;
    logic [6:0] in1_i;
    logic [6:0] in2_i;
    logic [6:0] in3_i;

    // ABFG 7'b0011100
    // CDEG 7'b1100010

    always_ff @(posedge clk_i) begin
        
    end

    always_comb begin
        in0_i = 7'h00;
        in1_i = 7'hF0;
        in2_i = 7'h0F;
        in3_i = 7'hFF;
    end

    time_multiplexer TIME_MULTIPLEXER(
        .*
    );

endmodule