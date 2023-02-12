`timescale 1ns/1ps
`default_nettype none

module stack_controller 
    #(
        parameter ADDR_WIDTH = 4
    ) (
    input wire clk_i, reset_i,
    input wire pop_i, push_i,
    output logic empty_o, full_o,
    output logic [ADDR_WIDTH-1:0] address_o
);

    // Declarations
    logic [ADDR_WIDTH-1:0] pointer_reg, pointer_next, pointer_out_reg, pointer_out_next;
    logic empty_reg, empty_next;
    logic full_reg, full_next;

    always_ff @(posedge clk_i, posedge reset_i) begin
        if (reset_i) begin
            pointer_reg <= 0;
            pointer_out_reg <= 0;
            empty_reg <= 1;
            full_reg <= 0;
        end else begin
            pointer_reg <= pointer_next;
            pointer_out_reg <= pointer_out_next;
            empty_reg <= empty_next;
            full_reg <= full_next;
        end
    end

    // Next State Logic
    always_comb begin
        pointer_next = pointer_reg;
        pointer_out_next = pointer_out_reg;
        empty_next = empty_reg;
        full_next = full_reg;
        unique case({push_i, pop_i})
            2'b01 : begin
                if (~empty_reg) begin
                    pointer_next = pointer_reg - 1;
                    pointer_out_next = pointer_reg;
                    full_next = 0;
                    if (pointer_reg == 0) begin
                        empty_next = 1;
                    end
                end
            end
            2'b10 : begin
                if (~full_reg) begin
                    pointer_next = pointer_reg + 1;
                    pointer_out_next = pointer_reg;
                    empty_next = 0;
                    if (pointer_reg == 2**ADDR_WIDTH-1) begin
                        full_next = 1;
                    end
                end
            end
            default : ;
        endcase
    end

    // Output Logic
    assign address_o = pointer_out_next;
    assign empty_o = empty_reg;
    assign full_o = full_reg;


endmodule
