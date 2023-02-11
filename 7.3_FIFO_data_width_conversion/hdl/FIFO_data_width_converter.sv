`timescale 1ns/1ps
`default_nettype none

module FIFO_data_width_converter
    #(
        parameter ADDR_WIDTH = 4,
        parameter DATA_WIDTH = 4
    ) (
    input wire clk_i, reset_i,
    input wire read_i, write_i,
    input wire [7:0] write_data_i,
    output logic empty_o, full_o,
    output logic [3:0] read_data_o
);

    logic [ADDR_WIDTH-1:0] write_address_1, write_address_2, read_address_1;

    FIFO_controller_width_conversion #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) FIFO_CONTROLLER(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .read_i(read_i),
        .write_i(write_i),
        .empty_o(empty_o),
        .full_o(full_o),
        .write_address_1_o(write_address_1),
        .write_address_2_o(write_address_2),
        .read_address_o(read_address_1)
    );

    logic write_en;

    register_file_2_write_port #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) REGISTER_FILE (
        .clk_i(clk_i),
        .write_en(write_en),
        .write_address_1_i(write_address_1),
        .write_address_2_i(write_address_2),
        .read_address_i(read_address_1),
        .write_data_1_i(write_data_i[7:4]),
        .write_data_2_i(write_data_i[3:0]),
        .read_data_o(read_data_o)
    );

    assign write_en = write_i & ~full_o;

endmodule
