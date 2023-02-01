`timescale 1ns/1ps
`default_nettype none

module delayed_detection_debouncing #(
    parameter DELAY_NS = 20000000
    )
    (
    input wire clk_i,
    input wire btn_i,
    output logic debounced_o 
);

    typedef enum logic [1:0] {
        IDLE,
        RISE,
        WAIT,
        FALL
    } state_d;

    state_d state_reg;
    state_d state_next;

    logic debounced_reg;
    logic debounced_next;

    logic [$clog2(DELAY_NS)-1:0] count_reg;
    logic [$clog2(DELAY_NS)-1:0] count_next;

    always_ff @(posedge clk_i) begin
        state_reg <= state_next;
        count_reg <= count_next;
        debounced_reg <= debounced_next;
    end

    always_comb begin
        debounced_next = 0;
        count_next = count_reg;
        state_next = IDLE;
        case (state_reg)
            IDLE : begin
                if (btn_i) begin
                    count_next = 0;
                    state_next = RISE;
                end else begin
                    state_next = IDLE;
                end
            end
            RISE : begin
                if (count_reg < DELAY_NS & btn_i) begin
                    count_next = count_reg + 1;
                    state_next = RISE;
                end else begin
                    if (btn_i) begin
                    debounced_next = 1;
                    state_next = WAIT;
                    end else begin
                        state_next = IDLE;
                    end
                end
            end
            WAIT : begin
                if (btn_i) begin
                    debounced_next = 1;
                    state_next = WAIT;
                end else begin
                    debounced_next = 1;
                    count_next = 0;
                    state_next = FALL;
                end
            end
            FALL : begin
                if (count_reg < DELAY_NS & ~btn_i) begin
                    count_next = count_reg + 1;
                    debounced_next = 1;
                    state_next = FALL;
                end else begin
                    if (~btn_i) begin
                    debounced_next = 0;
                    state_next = IDLE;
                    end else begin
                        state_next = WAIT;
                    end
                end
            end
            default : begin
                state_next = IDLE;
            end
        endcase
    end

    // Output Logic
    assign debounced_o = debounced_next;

endmodule
