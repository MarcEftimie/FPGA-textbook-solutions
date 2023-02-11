`timescale 1ns/1ps
`default_nettype none

module register_file_2_write_port 
    # (
        parameter ADDR_WIDTH = 8,
        parameter DATA_WIDTH = 8
    ) (
        input logic clk_i,
        input logic write_en,
        input logic [ADDR_WIDTH-1:0] write_address_1_i, write_address_2_i, read_address_i,
        input logic [DATA_WIDTH-1:0] write_data_1_i, write_data_2_i,
        output logic [DATA_WIDTH-1:0] read_data_o
    );

    // Declarations
    logic [DATA_WIDTH-1:0] rom [0:(2**ADDR_WIDTH)-1];

    // Registers
    always_ff @(posedge clk_i) begin
        if (write_en) begin
            rom[write_address_1_i] <= write_data_1_i;
            rom[write_address_2_i] <= write_data_2_i;
        end
    end

    // Output Logic
    assign read_data_o = rom[read_address_i];

endmodule
