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

    genvar i;
    generate
        for (i=0; i<N; i++) begin
            assign shifted_data_o[i] = shift_direction_i ? data_i[(i - shift_amount_i) % N] : data_i[(i + shift_amount_i) % N]; 
        end
    endgenerate

endmodule