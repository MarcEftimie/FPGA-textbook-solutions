`timescale 1ns/1ps
`default_nettype none

module ROM_based_sign_magnitude_adder 
    #(
        localparam ADDR_WIDTH = 8,
        localparam DATA_WIDTH = 5
    ) (
    input wire clk_i,
    input wire [3:0] a_i, b_i,
    output logic [4:0] sum_o
);

    // Declarations
    logic [ADDR_WIDTH-1:0] read_addr;

    sync_rom #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) SYNC_ROM (
        .clk_i(clk_i),
        .addr_i(read_addr),
        .data_o(sum_o)
    );

    // Logic
    always_comb begin
        if (a_i > b_i) begin
            read_addr = {b_i, a_i};
        end else begin
            read_addr = {a_i, b_i};
        end
    end

endmodule
