`timescale 1ns/1ps
`default_nettype none

module hex_to_7_segment (
    input wire [3:0] hex_i,
    output logic [6:0] sseg_o
);

    always_comb begin
        case(hex_i)
            4'h0 : sseg_o = 7'b1000000;
            4'h1 : sseg_o = 7'b1111001;
            4'h2 : sseg_o = 7'b0100100;
            4'h3 : sseg_o = 7'b0110000;
            4'h4 : sseg_o = 7'b0011001;
            4'h5 : sseg_o = 7'b0010010;
            4'h6 : sseg_o = 7'b0000010;
            4'h7 : sseg_o = 7'b1111000;
            4'h8 : sseg_o = 7'b0000000;
            4'h9 : sseg_o = 7'b0010000;
        endcase
    end

endmodule