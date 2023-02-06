`timescale 1ns/1ps
`default_nettype none

module BCD_normalizer #(
    parameter N = 16
    ) (
    input wire clk_i, reset_i,
    input wire start_i,
    input wire [N-1:0] BCD_i,
    output logic done_o,
    output logic [N-1:0] BCD_o,
    output logic [($clog2(N/4)):0] power_o
);

    // Declarations
    typedef enum logic [1:0] {
        IDLE,
        OP,
        DONE
    } state_d;

    state_d state_reg, state_next;

    logic [N-1:0] BCD_reg, BCD_next;
    logic [($clog2(N/4)):0] power_reg, power_next;

    // Registers
    always_ff @(posedge clk_i, posedge reset_i) begin
        if (reset_i) begin
            state_reg <= IDLE;
            BCD_reg <= 0;
            power_reg <= 0;
        end else begin
            state_reg <= state_next;
            BCD_reg <= BCD_next;
            power_reg <= power_next;
        end
    end

    // Next State Logic
    always_comb begin
        state_next = state_reg;
        power_next = power_reg;
        BCD_next = BCD_reg;
        done_o = 0;
        case(state_reg)
            IDLE : begin
                if (start_i) begin
                    BCD_next = BCD_i;
                    state_next = OP;
                end
            end
            OP : begin
                if (BCD_reg[N-1:N-4] == 4'h0) begin
                    BCD_next = BCD_reg << 4;
                    power_next = power_reg + 1;
                end else begin
                    state_next = DONE;
                end
            end
            DONE : begin
                done_o = 1;
                state_next = IDLE;
            end
            default : begin
                state_next = IDLE;
            end
        endcase
    end

    // Output Logic
    assign BCD_o = BCD_reg;
    assign power_o = power_reg;

endmodule
