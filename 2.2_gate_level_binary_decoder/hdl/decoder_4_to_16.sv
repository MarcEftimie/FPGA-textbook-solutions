`timescale 1ns/1ps
`default_nettype none

module decoder_4_to_16(
    input wire [3:0] a,
    input wire ena,
    output logic [15:0] out
);

    logic ena1, ena2, ena3, ena4;

    decoder_2_to_4 DECODER0(.a(a[3:2]), .ena(1), .out({ena4, ena3, ena2, ena1}));
    decoder_2_to_4 DECODER1(.a(a[1:0]), .ena(ena1), .out(out[3:0]));
    decoder_2_to_4 DECODER2(.a(a[1:0]), .ena(ena2), .out(out[7:4]));
    decoder_2_to_4 DECODER3(.a(a[1:0]), .ena(ena3), .out(out[11:8]));
    decoder_2_to_4 DECODER4(.a(a[1:0]), .ena(ena4), .out(out[15:12]));
    
endmodule