`timescale 1ns/1ps
`default_nettype none

module sync_rom 
    # (
        parameter ADDR_WIDTH = 8,
        parameter DATA_WIDTH = 8
    ) (
        input logic clk_i,
        input logic [ADDR_WIDTH-1:0] addr_i,
        output logic [DATA_WIDTH-1:0] data_o
    );

    // Declarations
    logic [DATA_WIDTH-1:0] rom [0:(2**ADDR_WIDTH)-1];
    logic [DATA_WIDTH-1:0] data_reg;

    initial begin 
        $readmemb("rom.txt", rom);
    end

    always_ff @(posedge clk_i) begin
        data_reg <= rom[addr_i];
    end

    assign data_o = data_reg;

endmodule
