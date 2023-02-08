`timescale 1ns/1ps
`default_nettype none

module babbage_difference_engine (
    input wire clk_i, reset_i,
    input logic compute_i,
    input logic [5:0] n,
    output logic [15:0] f_of_n_o
);

    // Compute f(n) for 2*n^2 + 3n + 5

    // Declarations
    typedef enum logic [1:0] {
        IDLE,
        OP,
        DONE
    } state_d;

    state_d state_reg, state_next;

    logic [15:0] f_of_n1_reg, f_of_n1_next;
    logic [15:0] f_of_n2_reg, f_of_n2_next;
    logic [15:0] difference_reg, difference_next;

    logic [5:0] iter_reg, iter_next;

    logic done;
 
    // Registers
    always_ff @(posedge clk_i, posedge reset_i) begin
        if (reset_i) begin
            state_reg <= IDLE;
            f_of_n1_reg <= 0;
            f_of_n2_reg <= 0;
            difference_reg <= 0;
            iter_reg <= 0;
        end else begin
            state_reg <= state_next;
            f_of_n1_reg <= f_of_n1_next;
            f_of_n2_reg <= f_of_n2_next;
            difference_reg <= difference_next;
            iter_reg <= iter_next;
        end
    end

    // Next State Logic
    always_comb begin
        state_next = state_reg;
        f_of_n1_next = f_of_n1_reg;
        f_of_n2_next = f_of_n2_reg;
        difference_next = difference_reg;
        iter_next = iter_reg;
        done = 0;
        case (state_reg)
            IDLE : begin
                if (compute_i) begin
                    state_next = OP;
                    iter_next = n;
                    f_of_n1_next = 5;
                    difference_next = 1;    
                end
            end
            OP : begin
                if (iter_reg != 0) begin
                    difference_next = difference_reg + 4;
                    f_of_n1_next = f_of_n1_reg + difference_next;
                    iter_next = iter_reg - 1;
                end else begin
                    state_next = DONE;
                end
            end
            DONE : begin
                done = 1;
                state_next = IDLE;
            end
            default : state_next = IDLE;
        endcase
    end

    // Outputs
    assign f_of_n_o = done ? f_of_n1_reg : 0;

endmodule
