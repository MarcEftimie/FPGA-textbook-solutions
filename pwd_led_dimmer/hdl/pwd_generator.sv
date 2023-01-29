`timescale 1ns/1ps
`default_nettype none

module pwd_generator(
    input wire clk_i,
    input wire rst_i,
    input wire [3:0] duty_cycle_i,
    output logic pwm_o
);

    // Declarations
    localparam COUNT_CEILING = 15;
    logic pwm_reg;
    logic pwm_next;

    logic [3:0] duty_cycle_reg;

    logic [3:0] count_reg;
    logic [3:0] count_next;

    // Registers
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            pwm_reg <= 0;
            duty_cycle_reg <= 0;
            count_reg <= 0;
        end else begin
            pwm_reg <= pwm_next;
            duty_cycle_reg <= duty_cycle_i;
            count_reg <= count_next;
        end    
    end

    // Next State Logic
    always_comb begin
        if (duty_cycle_reg == 0) begin
            pwm_next = 0;
            count_next = 0;
        end else if (count_reg < duty_cycle_reg-1) begin
            count_next = count_reg + 1;
            pwm_next = 1;
        end else if (count_reg < COUNT_CEILING-1) begin
            count_next = count_reg + 1;
            pwm_next = 0;
        end else begin
            count_next = 0;
            pwm_next = 1;
        end
    end

    // Output Logic
    assign pwm_o = pwm_reg;
endmodule