`timescale 1ns/1ps
`default_nettype none

module greater_than_2_bit(
    input wire [1:0] a, b,
    output logic out
);

    assign out =
        (~a[1] & a[0] & ~(|b[1:0])) |
        (a[1] & ~b[1]) | 
        (&a & ~(&b));
endmodule