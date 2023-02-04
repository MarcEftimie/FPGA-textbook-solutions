`timescale 1ns/1ps
`default_nettype none

module fibonacci_generator (
    input wire clk_i, reset_i,
    input wire start_i,
    input wire [6:0] iterations_i,
    output logic ready_o, done_o,
    output logic overflow_o,
    output logic [13:0] fibonacci_o
);

    // Declarations
    typedef enum logic [1:0] {
        IDLE,
        OP,
        DONE
    } state_d;

    state_d state_reg, state_next;

    logic [13:0] fib1_reg, fib2_reg;
    logic [13:0] fib1_next, fib2_next;

    logic [6:0] iteration_reg;
    logic [6:0] iteration_next;

    logic overflow_reg;
    logic overflow_next;

    // Registers
    always_ff @(posedge clk_i, posedge reset_i) begin
        if (reset_i) begin
            state_reg <= IDLE;
            overflow_reg <= 0;
            fib1_reg <= 0;
            fib2_reg <= 0;
            iteration_reg <= 0;
        end else begin
            state_reg <= state_next;
            overflow_reg <= overflow_next;
            fib1_reg <= fib1_next;
            fib2_reg <= fib2_next;
            iteration_reg <= iteration_next;
        end
    end

    // Next State Logic
    always_comb begin
        state_next = state_reg;
        ready_o = 0;
        done_o = 0;
        overflow_next = overflow_reg;
        fib1_next = fib1_reg;
        fib2_next = fib2_reg;
        iteration_next = iteration_reg;
        case (state_reg)
            IDLE : begin
                ready_o = 1;
                overflow_next = 0;
                if (start_i) begin
                    fib1_next = 0;
                    fib2_next = 1;
                    iteration_next = iterations_i;
                    state_next = OP;
                end
            end
            OP : begin
                if (fib2_next >= 9999) begin
                    overflow_next = 1;
                    state_next = DONE;
                end else if (iteration_reg == 0) begin
                    fib2_next = 0;
                    state_next = DONE;
                end else if (iteration_reg == 1) begin
                    state_next = DONE;
                end else begin
                    fib1_next = fib2_reg;
                    fib2_next = fib1_reg + fib2_reg;
                    iteration_next = iteration_reg - 1;
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
    assign fibonacci_o = fib2_reg;
    assign overflow_o = overflow_reg;

endmodule
