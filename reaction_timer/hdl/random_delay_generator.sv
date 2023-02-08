`timescale 1ns/1ps
`default_nettype none

module random_delay_generator #(
    parameter COUNT_N = 30
    ) (
    input wire clk_i, reset_i,
    input wire sample_i,
    output logic [COUNT_N-1:0] random_delay_o
);

    // Declarations
    logic [COUNT_N-1:0] count_reg, count_next;
    logic [COUNT_N-1:0] random_delay_reg, random_delay_next;

    // Registers
    always_ff @(posedge clk_i, posedge reset_i) begin
        if (reset_i) begin
            count_reg <= 0;
            random_delay_reg <= 0;
        end else begin
            count_reg <= count_next;
            random_delay_reg <= random_delay_next;
        end
    end

    assign count_next = count_reg + 1;
    assign random_delay_next = sample_i ? count_reg : random_delay_reg;
    assign random_delay_o = random_delay_reg;

endmodule
