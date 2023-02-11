`timescale 1ns/1ps
`default_nettype none

module FIFO_controller_width_conversion
    #(
        parameter ADDR_WIDTH = 4
    ) (
    input wire clk_i, reset_i,
    input wire read_i, write_i,
    output wire empty_o, full_o,
    output logic [ADDR_WIDTH-1:0] write_address_1_o, write_address_2_o, read_address_o
);

    // Declarations
    logic [ADDR_WIDTH-1:0] read_pointer_reg, read_pointer_next;
    logic [ADDR_WIDTH-1:0] write_pointer_1_reg, write_pointer_1_next;
    logic [ADDR_WIDTH-1:0] write_pointer_2_reg, write_pointer_2_next;
    logic empty_reg, empty_next;
    logic full_reg, full_next;

    always_ff @(posedge clk_i, posedge reset_i) begin
        if (reset_i) begin
            read_pointer_reg <= 0;
            write_pointer_1_reg <= 0;
            write_pointer_2_reg <= 1;
            empty_reg <= 1;
            full_reg <= 0;
        end else begin
            read_pointer_reg <= read_pointer_next;
            write_pointer_1_reg <= write_pointer_1_next;
            write_pointer_2_reg <= write_pointer_2_next;
            empty_reg <= empty_next;
            full_reg <= full_next;
        end
    end

    // Next State Logic
    always_comb begin
        read_pointer_next = read_pointer_reg;
        write_pointer_1_next = write_pointer_1_reg;
        write_pointer_2_next = write_pointer_2_reg;
        empty_next = empty_reg;
        full_next = full_reg;
        unique case({write_i, read_i})
            2'b01 : begin
                if (~empty_reg) begin
                    read_pointer_next = read_pointer_reg + 1;
                    full_next = 0;
                    if (read_pointer_next == write_pointer_2_reg) begin
                        empty_next = 1;
                    end
                end
            end
            2'b10 : begin
                if (~full_reg) begin
                    write_pointer_1_next = write_pointer_1_reg + 2;
                    write_pointer_2_next = write_pointer_2_reg + 2;
                    empty_next = 0;
                    if ((write_pointer_2_next == read_pointer_reg) | (write_pointer_1_next == read_pointer_reg)) begin
                        full_next = 1;
                    end
                end
            end
            2'b11 : begin
                write_pointer_1_next = write_pointer_1_reg + 1;
                write_pointer_2_next = write_pointer_2_reg + 1;
                read_pointer_next = read_pointer_reg + 1;
            end
            default : ;
        endcase
    end

    // Output Logic
    assign write_address_1_o = write_pointer_1_reg;
    assign write_address_2_o = write_pointer_2_reg;
    assign read_address_o = read_pointer_reg;
    assign empty_o = empty_reg;
    assign full_o = full_reg;


endmodule
