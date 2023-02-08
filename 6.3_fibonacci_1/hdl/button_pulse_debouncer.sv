`timescale 1ns/1ps
`default_nettype none

module button_pulse_debouncer #(
    parameter DELAY_NS = 250000
    )
    (
    input wire clk_i, reset_i,
    input wire btn_i,
    output logic pulse_o 
);

    typedef enum logic [1:0] {
        IDLE,
        RISE,
        WAIT,
        FALL
    } state_d;

    state_d state_reg;
    state_d state_next;

    logic pulse_reg;
    logic pulse_next;

    logic [$clog2(DELAY_NS)-1:0] count_reg;
    logic [$clog2(DELAY_NS)-1:0] count_next;

    always_ff @(posedge clk_i, posedge reset_i) begin
        if (reset_i) begin
            state_reg <= IDLE;
            count_reg <= 0;
            pulse_reg <= 0;
        end else begin
            state_reg <= state_next;
            count_reg <= count_next;
            pulse_reg <= pulse_next;
        end
    end

    always_comb begin
        pulse_next = 0;
        count_next = 0;
        state_next = IDLE;
        case (state_reg)
            IDLE : begin
                if (btn_i == 1) begin
                    state_next = RISE;
                end else begin
                    state_next = IDLE;
                end
            end
            RISE : begin
                pulse_next = 1;
                state_next = WAIT;
            end
            WAIT : begin
                if (count_reg < DELAY_NS) begin
                    count_next = count_reg + 1;
                    state_next = WAIT;
                end else if (~btn_i) begin
                    count_next = 0;
                    state_next = FALL;   
                end else begin
                    count_next = count_reg;
                    state_next = WAIT;
                end
            end
            FALL : begin
                if (count_reg < DELAY_NS) begin
                    count_next = count_reg + 1;
                    state_next = FALL;
                end else begin
                    state_next = IDLE;
                end
            end
        endcase
    end

    // Output Logic
    assign pulse_o = pulse_reg;

endmodule
