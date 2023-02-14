
`timescale 1ns/1ps
`default_nettype none

module dual_mode_comparator
    (
        input wire clk_i,
        input wire [7:0] a_i, b_i,
        input wire signed_i,
        output logic agtb_o
    );

    always_comb begin
        if (signed_i) begin
            agtb_o = $signed(a_i) > $signed(b_i);
        end else begin
            agtb_o = a_i > b_i;
        end
    end


endmodule
