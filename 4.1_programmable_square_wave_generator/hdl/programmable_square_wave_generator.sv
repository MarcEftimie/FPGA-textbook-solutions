`timescale 1ns/1ps
`default_nettype none

module programmable_square_wave_generator(
    input wire clk_i,
    input wire rst_i,
    input wire [3:0] on_duty_i,
    input wire [3:0] off_duty_i,
    output logic square_wave_o
);

    // Declaration
    localparam CLK_CYCLES = 10;

    logic square_wave_reg;
    logic square_wave_next;

    logic [7:0] clk_cycle_count_reg;
    logic [7:0] clk_cycle_count_next;

    logic on_reg;
    logic on_next;

    logic [3:0] on_duty_cycles_reg;
    logic [3:0] off_duty_cycles_reg;

    // Registers
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            square_wave_reg <= 0;
            on_reg <= 0;
            clk_cycle_count_reg <= 0;
            on_duty_cycles_reg <= on_duty_i;
            off_duty_cycles_reg <= off_duty_i;
        end else begin
            square_wave_reg <= square_wave_next;
            on_reg <= on_next;
            clk_cycle_count_reg <= clk_cycle_count_next;
            on_duty_cycles_reg <= on_duty_i;
            off_duty_cycles_reg <= off_duty_i;
        end
    end

    // Next State Logic
    always_comb begin
        if (on_reg) begin
            square_wave_next = 1;
            if (clk_cycle_count_reg < CLK_CYCLES*on_duty_cycles_reg - 1) begin
                clk_cycle_count_next = clk_cycle_count_reg + 1;
            end else begin
                clk_cycle_count_next = 0;
                on_next = 0;
            end
        end else begin
            square_wave_next = 0;
            if (clk_cycle_count_reg < CLK_CYCLES*off_duty_cycles_reg - 1) begin
                clk_cycle_count_next = clk_cycle_count_reg + 1;
            end else begin
                on_next = 1;
                clk_cycle_count_next = 0;
            end
        end
    end

    // Output Logic
    assign square_wave_o = square_wave_reg;

endmodule