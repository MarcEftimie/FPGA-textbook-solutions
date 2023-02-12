`timescale 1ns/1ps
`default_nettype none

module FIFO_controller 
    #(
        parameter ADDR_WIDTH = 4
    ) (
    input wire clk_i, reset_i,
    input wire read_i, write_i,
    output logic empty_o, full_o, almost_empty_o, almost_full_o,
    output logic [ADDR_WIDTH-1:0] write_address_o, read_address_o
);

    // Declarations
    logic [ADDR_WIDTH-1:0] read_pointer_reg, read_pointer_next, read_pointer_out_reg, read_pointer_out_next;
    logic [ADDR_WIDTH-1:0] write_pointer_reg, write_pointer_next;
    logic empty_reg, empty_next;
    logic full_reg, full_next;
    logic [ADDR_WIDTH-1:0] word_count_reg, word_count_next;

    always_ff @(posedge clk_i, posedge reset_i) begin
        if (reset_i) begin
            read_pointer_reg <= 0;
            read_pointer_out_reg <= 0;
            write_pointer_reg <= 0;
            empty_reg <= 1;
            full_reg <= 0;
            word_count_reg <= 0;
        end else begin
            read_pointer_reg <= read_pointer_next;
            read_pointer_out_reg <= read_pointer_out_next;
            write_pointer_reg <= write_pointer_next;
            empty_reg <= empty_next;
            full_reg <= full_next;
            word_count_reg <= word_count_next;
        end
    end

    // Next State Logic
    always_comb begin
        read_pointer_next = read_pointer_reg;
        read_pointer_out_next = read_pointer_out_reg;
        write_pointer_next = write_pointer_reg;
        empty_next = empty_reg;
        full_next = full_reg;
        word_count_next = word_count_reg;
        unique case({write_i, read_i})
            2'b01 : begin
                if (~empty_reg) begin
                    word_count_next = word_count_reg - 1;
                    read_pointer_out_next = read_pointer_reg;
                    read_pointer_next = read_pointer_reg + 1;
                    full_next = 0;
                    if (read_pointer_next == write_pointer_reg) begin
                        empty_next = 1;
                    end
                end
            end
            2'b10 : begin
                if (~full_reg) begin
                    word_count_next = word_count_reg + 1;
                    write_pointer_next = write_pointer_reg + 1;
                    empty_next = 0;
                    if (write_pointer_next == read_pointer_reg) begin
                        full_next = 1;
                    end
                end
            end
            2'b11 : begin
                read_pointer_next = read_pointer_reg + 1;
                write_pointer_next = write_pointer_reg + 1;
            end
            default : ;
        endcase
    end

    // Output Logic
    assign write_address_o = write_pointer_reg;
    assign read_address_o = read_pointer_out_reg;
    assign empty_o = empty_reg;
    assign full_o = full_reg;
    assign almost_empty_o = word_count_reg <= (2**ADDR_WIDTH) * 0.25 ? 1 : 0;
    assign almost_full_o = word_count_reg >= (2**ADDR_WIDTH) * 0.75 ? 1 : 0;


endmodule
