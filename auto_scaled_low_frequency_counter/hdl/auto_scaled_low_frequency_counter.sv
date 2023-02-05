`timescale 1ns/1ps
`default_nettype none

module auto_scaled_low_frequency_counter(
    input wire clk_i, reset_i,
    input wire btn_i,
    output logic [6:0] seven_segment_o,
    output logic [3:0] an_o
);

    // Declarations
    typedef enum logic [1:0] {
        IDLE,
        OP_COUNTER,
        OP_BIN_TO_BCD,
        DONE
    } state_d;

    state_d state_reg, state_next;

    logic btn_tick;

    button_pulse_debouncer DEBOUNCER(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .btn_i(btn_i),
        .tick_o(btn_tick)
    );

    logic [15:0] period_count;
    logic done_period_counter;

    period_counter PERIOD_COUNTER(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .tick_i(btn_tick),
        .period_count_o(period_count),
        .done_o(done_period_counter)
    );

    // Registers
    always_ff @(posedge clk_i, posedge reset_i) begin
        if (reset_i) begin
            state_reg <= IDLE;
        end else begin
            state_reg <= state_next;
        end
    end

    // Next State Logic
    always_comb begin
        state_next = state_reg;
        case (state_reg)
            IDLE : begin
                if (btn_tick) begin
                    state_next = OP_COUNTER;
                end
            end
            OP_COUNTER : begin
                if (done_period_counter) begin
                    state_next = OP_BIN_TO_BCD;
                end
            end
            OP_BIN_TO_BCD : begin
                state_next = IDLE;
            end
            default : state_next = IDLE;
        endcase
    end
endmodule
