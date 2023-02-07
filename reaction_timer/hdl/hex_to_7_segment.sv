`timescale 1ns/1ps
`default_nettype none

module hex_to_7_segment (
    input wire [7:0] hex_i,
    output logic [6:0] sseg_o
);

    always_comb begin
        case(hex_i)
            0 : sseg_o = 7'b1000000;
            1 : sseg_o = 7'b1111001;
            2 : sseg_o = 7'b0100100;
            3 : sseg_o = 7'b0110000;
            4 : sseg_o = 7'b0011001;
            5 : sseg_o = 7'b0010010;
            6 : sseg_o = 7'b0000010;
            7 : sseg_o = 7'b1111000;
            8 : sseg_o = 7'b0000000;
            9 : sseg_o = 7'b0010000;
            default : sseg_o = hex_i[6:0];
        endcase
    end

endmodule
