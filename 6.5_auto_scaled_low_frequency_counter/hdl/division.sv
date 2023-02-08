`timescale 1ns/1ps
`default_nettype none

module division(
    input wire clk_i, reset_i,
    input wire start_i,
    input wire [31:0] dividend_i, divisor_i,
    output logic [31:0] quotient_o,
    output logic done_o
);

    // Declarations
    typedef enum logic [1:0] {
        IDLE,
        OP,
        DONE
    } state_d;

    state_d state_reg, state_next;

    logic [63:0] dividend_reg, dividend_next;
    logic [31:0] dividend_tmp;
    logic [31:0] quotient_reg, quotient_next;

    logic [$clog2(32):0] count_reg, count_next;

    // Registers
    always_ff @(posedge clk_i, posedge reset_i) begin
        if (reset_i) begin
            state_reg <= IDLE;
            dividend_reg <= 0;
            quotient_reg <= 0;
            count_reg <= 0;
        end else begin
            state_reg <= state_next;
            dividend_reg <= dividend_next;
            quotient_reg <= quotient_next;
            count_reg <= count_next;
        end
    end

    // Next State Logic
    always_comb begin
        state_next = state_reg;
        dividend_next = dividend_reg;
        quotient_next = quotient_reg;
        count_next = count_reg;

        dividend_tmp = 0;
        done_o = 0;
        case (state_reg)
            IDLE : begin
                if (start_i) begin
                    dividend_next = {32'h00000000, dividend_i};
                    count_next = 33;
                    state_next = OP;
                end
            end
            OP : begin
                if (count_next > 0) begin
                    if (dividend_reg[63:32] >= divisor_i) begin
                        dividend_tmp = dividend_reg[63:32] - divisor_i;
                        quotient_next = {quotient_reg[30:0], 1'b1};
                    end else begin
                        dividend_tmp = dividend_reg[63:32];
                        quotient_next = {quotient_reg[30:0], 1'b0};
                    end
                    dividend_next = {dividend_tmp, dividend_reg[31:0]} << 1;
                    state_next = OP;
                    count_next = count_reg - 1;
                end else begin
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
    assign quotient_o = quotient_reg;

endmodule
