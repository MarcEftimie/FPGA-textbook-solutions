`timescale 1ns/1ps
`default_nettype none

module period_counter(
    input wire clk_i, reset_i,
    input wire tick_i,
    output logic [15:0] period_count_o,
    output logic done_o
);

    // Declarations
    typedef enum logic [1:0] {
        IDLE,
        OP,
        DONE
    } state_d;

    state_d state_reg, state_next;

    logic [15:0] count_reg, count_next;

    // Registers
    always_ff @(posedge clk_i, posedge reset_i) begin
        if (reset_i) begin
            state_reg <= IDLE;
            count_reg <= 1;
        end else begin
            state_reg <= state_next;
            count_reg <= count_next;
        end
    end

    // Next State Logic
    always_comb begin
        state_next = state_reg;
        count_next = count_reg;
        done_o = 0;
        case (state_reg)
            IDLE : begin
                if (tick_i) begin
                    count_next = 1;
                    state_next = OP;
                end
            end
            OP : begin
                count_next = count_reg + 1;
                if (tick_i) begin
                    state_next = DONE;
                end
            end
            DONE : begin
                done_o = 1;
                state_next = IDLE;
            end
            default : state_next = IDLE;
        endcase
    end

    // Outputs
    assign period_count_o = count_reg;

endmodule
