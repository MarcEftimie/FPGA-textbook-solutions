`timescale 1ns/1ps
`default_nettype none

module BCD_to_binary_converter #(
    parameter N = 13
    ) (
    input wire clk_i, reset_i,
    input wire start_i,
    input wire [N-1:0] BCD_i,
    output logic ready_o, done_o,
    output logic [31:0] binary_o
);

    // Declarations
    typedef enum logic [1:0] {
        IDLE,
        OP,
        DONE
    } state_d;

    state_d state_reg, state_next;

    logic [N-1:0] BCD_reg, BCD_next, BCD_tmp;
    logic [31:0] binary_reg, binary_next, binary_tmp;
    logic [$clog2(N):0] bit_count_reg, bit_count_next;

    // Registers
    always_ff @(posedge clk_i, posedge reset_i) begin
        if (reset_i) begin
            state_reg <= IDLE;
            binary_reg <= 0;
            BCD_reg <= 0;
            bit_count_reg <= 31;
        end else begin
            state_reg <= state_next;
            binary_reg <= binary_next;
            BCD_reg <= BCD_next;
            bit_count_reg <= bit_count_next;
        end
    end

    // Next State Logic
    always_comb begin
        state_next = state_reg;
        binary_next = binary_reg;
        bit_count_next = bit_count_reg;
        BCD_next = BCD_reg;
        binary_next = binary_reg;
        done_o = 0;
        ready_o = 0;
        case(state_reg)
            IDLE : begin
                ready_o = 1;
                if (start_i) begin
                    state_next = OP;
                    BCD_next = BCD_i;
                    bit_count_next = 31;
                end
            end
            OP : begin
                {BCD_tmp, binary_next} = {BCD_reg, binary_reg} >> 1;
                BCD_next = BCD_tmp[3:0] > 4 ? BCD_tmp - 3 : BCD_tmp;
                if (bit_count_reg == 0) begin
                    state_next = DONE;
                end else begin
                    bit_count_next = bit_count_reg - 1;
                    state_next = OP;
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
    assign binary_o = binary_next;

endmodule
