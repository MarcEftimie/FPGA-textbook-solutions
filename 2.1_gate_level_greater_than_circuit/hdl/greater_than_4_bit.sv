`timescale 1ns/1ps
`default_nettype none

module greater_than_4_bit(
    input wire [3:0] a, b,
    output logic out
);
    
    logic comparison_msb, comparison_lsb;

    greater_than_2_bit COMPARATOR0(.a(a[3:2]), .b(b[3:2]), .out(comparison_msb));
    greater_than_2_bit COMPARATOR1(.a(a[1:0]), .b(b[1:0]), .out(comparison_lsb));

    assign out =
        (comparison_msb) |
        (~comparison_msb & &(~(a[3:2] ^ b[3:2])) & comparison_lsb);

endmodule