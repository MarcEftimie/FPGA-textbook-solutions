`timescale 1ns/1ps
`default_nettype none

module dual_edge_detector_moore(
    input wire clk_i,
    input wire signal_i,
    output logic pulse_o
);

    // Declarations
    typedef enum logic {
        WAIT_RISE,
        WAIT_FALL
    } state_d;

    state_d state_reg, state_next;

    // Registers
    always_ff @(posedge clk_i) begin
        state_reg <= state_next;
    end

    // Next State Logic
    always_comb begin
        state_next = state_reg;
        pulse_o = 0;
        case (state_reg)
            WAIT_RISE : begin
                if (signal_i) begin
                    state_next = WAIT_FALL;
                    pulse_o = 1;
                end else begin
                    state_next = WAIT_RISE;
                end
            end
            WAIT_FALL : begin
                if (~signal_i) begin
                    state_next = WAIT_RISE;
                    pulse_o = 1;
                end else begin
                    state_next = WAIT_FALL;
                end
            end
            default : begin
                state_next = WAIT_RISE;
            end
        endcase
    end


endmodule
