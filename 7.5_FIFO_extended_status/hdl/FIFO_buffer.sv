`timescale 1ns/1ps
`default_nettype none

module FIFO_buffer
    #(
        parameter ADDR_WIDTH = 4,
        parameter DATA_WIDTH = 4
    ) (
    input wire clk_i, reset_i,
    input wire read_i, write_i,
    input wire [3:0] write_data_i,
    output logic empty_o, full_o, almost_empty_o, almost_full_o,
    output logic [3:0] read_data_o
);

    logic [ADDR_WIDTH-1:0] write_address, read_address;

    FIFO_controller #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) FIFO_CONTROLLER(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .read_i(read_i),
        .write_i(write_i),
        .empty_o(empty_o),
        .full_o(full_o),
        .almost_empty_o(almost_empty_o),
        .almost_full_o(almost_full_o),
        .write_address_o(write_address),
        .read_address_o(read_address)
    );

    logic write_en;

    register_file #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) REGISTER_FILE (
        .clk_i(clk_i),
        .write_en(write_en),
        .write_address_i(write_address),
        .read_address_i(read_address),
        .write_data_i(write_data_i[3:0]),
        .read_data_o(read_data_o)
    );

    assign write_en = write_i & ~full_o;

endmodule
