`timescale 1ns/1ps
`default_nettype none

module multi_function_barrel_shifter(
    input wire clk,
    input wire [7:0] data_i,
    input wire [2:0] shift_amount_i,
    input wire shift_direction_i,
    output logic [7:0] shifted_data_o
);

    logic [7:0] shifted_data;
    always_comb begin
        case(shift_amount_i)
            3'b000 : shifted_data = data_i[7:0];
            3'b001 : shifted_data = {data_i[0], data_i[7:1]};
            3'b010 : shifted_data = {data_i[1:0], data_i[7:2]};
            3'b011 : shifted_data = {data_i[2:0], data_i[7:3]};
            3'b100 : shifted_data = {data_i[3:0], data_i[7:4]};
            3'b101 : shifted_data = {data_i[4:0], data_i[7:5]};
            3'b110 : shifted_data = {data_i[5:0], data_i[7:6]};
            3'b111 : shifted_data = {data_i[6:0], data_i[7]};
        endcase
        shifted_data_o = shift_direction_i ? {
            shifted_data[0],
            shifted_data[1],
            shifted_data[2],
            shifted_data[3],
            shifted_data[4],
            shifted_data[5],
            shifted_data[6],
            shifted_data[7]
        } : shifted_data;
    end

endmodule