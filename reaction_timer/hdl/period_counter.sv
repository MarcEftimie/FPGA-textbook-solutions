`timescale 1ns/1ps
`default_nettype none

module period_counter #(
    parameter TICK_N = 14,
    parameter COUNT_N = 17
    ) (
    input wire clk_i, reset_i,
    input wire tick_i,
    output logic [TICK_N-1:0] period_count_o,
    output logic period_changed_o,
    output logic done_o
);

    // Declarations
    typedef enum logic [1:0] {
        IDLE,
        OP,
        DONE
    } state_d;

    state_d state_reg, state_next;

    logic [TICK_N-1:0] tick_count_reg, tick_count_next;
    logic [COUNT_N-1:0] count_reg, count_next;

    // Registers
    always_ff @(posedge clk_i, posedge reset_i) begin
        if (reset_i) begin
            state_reg <= IDLE;
            count_reg <= 1;
            tick_count_reg <= 1;
        end else begin
            state_reg <= state_next;
            count_reg <= count_next;
            tick_count_reg <= tick_count_next;
        end
    end

    // Next State Logic
    always_comb begin
        state_next = state_reg;
        tick_count_next = tick_count_reg;
        count_next = count_reg;
        done_o = 0;
        period_changed_o = 0;
        case (state_reg)
            IDLE : begin
                if (tick_i) begin
                    count_next = 1;
                    tick_count_next = 0;
                    state_next = OP;
                end
            end
            OP : begin
                if (count_reg < 100000) begin // 100000
                    count_next = count_reg + 1;
                end else begin
                    period_changed_o = 1;
                    tick_count_next = tick_count_reg + 1;
                    count_next = 0;
                end
                if (tick_i) begin
                    state_next = DONE;
                end
            end
            DONE : begin
                tick_count_next = 0;
                done_o = 1;
                state_next = IDLE;
            end
            default : state_next = IDLE;
        endcase
    end

    // Outputs
    assign period_count_o = tick_count_reg;

endmodule
