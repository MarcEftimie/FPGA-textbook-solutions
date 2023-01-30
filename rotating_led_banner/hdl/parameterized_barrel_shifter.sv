`timescale 1ns/1ps
`default_nettype none

module parameterized_barrel_shifter #(
    parameter N = 8
    )
    (
    input wire [N-1:0] data_i,
    input wire [$clog2(N):0] shift_amount_i,
    input wire shift_direction_i,
    output logic [N-1:0] shifted_data_o
);
    logic [(N*2)-1:0] shift_data;
    assign shift_data = shift_direction_i ? {data_i, data_i} << shift_amount_i : {data_i, data_i} >> shift_amount_i;
    assign shifted_data_o = shift_direction_i ? shift_data[(N*2)-1:N] : shift_data[N-1:0];

endmodule