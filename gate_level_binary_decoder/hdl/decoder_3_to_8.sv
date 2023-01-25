`timescale 1ns/1ps
`default_nettype none

module decoder_3_to_8(
    input wire [2:0] a,
    input wire ena,
    output logic [7:0] out
);

    decoder_2_to_4 DECODER0(.a(a[1:0]), .ena(~a[2]), .out(out[3:0]));
    decoder_2_to_4 DECODER1(.a(a[1:0]), .ena(a[2]), .out(out[7:4]));
    
endmodule