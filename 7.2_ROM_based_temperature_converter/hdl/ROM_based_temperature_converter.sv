`timescale 1ns/1ps
`default_nettype none

module ROM_based_temperature_converter 
    #(
        localparam ADDR_WIDTH = 8,
        localparam DATA_WIDTH = 8
    ) (
    input wire clk_i,
    input wire [DATA_WIDTH-1:0] temperature_i,
    input wire unit_i,
    output logic [DATA_WIDTH-1:0] temperature_o
);

    // Declarations
    logic [ADDR_WIDTH-1:0] read_addr;

    logic [DATA_WIDTH-1:0] celsius;
    sync_rom #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .FILE("rom_f.txt")
    ) SYNC_ROM_C_TO_F (
        .clk_i(clk_i),
        .addr_i(read_addr),
        .data_o(celsius)
    );

    logic [DATA_WIDTH-1:0] farenheit;
    sync_rom #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .FILE("rom_c.txt")
    ) SYNC_ROM_F_TO_C (
        .clk_i(clk_i),
        .addr_i(read_addr),
        .data_o(farenheit)
    );

    // Logic
    always_comb begin
        read_addr = temperature_i;
        temperature_o = unit_i ? celsius : farenheit;
    end

endmodule
