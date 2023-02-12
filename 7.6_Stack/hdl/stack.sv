`timescale 1ns/1ps
`default_nettype none

module stack
    #(
        parameter ADDR_WIDTH = 4,
        parameter DATA_WIDTH = 4
    ) (
    input wire clk_i, reset_i,
    input wire pop_i, push_i,
    input wire [DATA_WIDTH-1:0] write_data_i,
    output logic empty_o, full_o,
    output logic [DATA_WIDTH-1:0] read_data_o
);

    logic [ADDR_WIDTH-1:0] address;

    stack_controller #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) STACK_CONTROLLER(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .pop_i(pop_i),
        .push_i(push_i),
        .empty_o(empty_o),
        .full_o(full_o),
        .address_o(address)
    );

    logic write_en;

    register_file #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) REGISTER_FILE (
        .clk_i(clk_i),
        .write_en(write_en),
        .write_address_i(address),
        .read_address_i(address),
        .write_data_i(write_data_i[3:0]),
        .read_data_o(read_data_o)
    );

    assign write_en = push_i & ~full_o;

endmodule
