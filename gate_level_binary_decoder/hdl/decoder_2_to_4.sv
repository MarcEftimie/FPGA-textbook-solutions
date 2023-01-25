`timescale 1ns/1ps
`default_nettype none

module decoder_2_to_4(
    input wire [1:0] a,
    input wire ena,
    output logic [3:0] out
);

    assign out[0] = ena & ~a[1] & ~a[0];
    assign out[1] = ena & ~a[1] & a[0];
    assign out[2] = ena & a[1] & ~a[0];
    assign out[3] = ena & a[1] & a[0];
    
endmodule