`timescale 1ns/1ps
`default_nettype none

module BCD_to_binary_converter(
    input wire [39:0] BCD_i,
    output logic [31:0] binary_o
);

    assign binary_o = 
        BCD_i[3:0] +
        BCD_i[7:4]*10 +
        BCD_i[11:8]*100 +
        BCD_i[15:12]*1000 +
        BCD_i[19:16]*10000 +
        BCD_i[23:20]*100000 +
        BCD_i[27:24]*1000000 +
        BCD_i[31:28]*10000000;

endmodule
