`timescale 1ns/1ps
`default_nettype none

module binary_to_BCD_converter #(
    parameter N = 14
    ) (
    input wire clk_i, reset_i,
    input wire start_i,
    input wire [N-1:0] binary_i,
    output logic ready_o, done_o,
    output logic [15:0] BCD_o
);

    // Declarations
    typedef enum logic [1:0] {
        IDLE,
        OP,
        DONE
    } state_d;

    state_d state_reg, state_next;

    logic [N-1:0] binary_reg, binary_next, binary_tmp;
    logic [15:0] BCD_reg, BCD_next, BCD_tmp;
    logic [$clog2(N):0] bit_count_reg, bit_count_next;

    // Registers
    always_ff @(posedge clk_i, posedge reset_i) begin
        if (reset_i) begin
            state_reg <= IDLE;
            binary_reg <= 0;
            BCD_reg <= 0;
            bit_count_reg <= N;
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
        done_o = 0;
        ready_o = 0;
        case(state_reg)
            IDLE : begin
                ready_o = 1;
                if (start_i) begin
                    state_next = OP;
                    binary_next = binary_i;
                    bit_count_next = N;
                end
            end
            OP : begin
                
                if (bit_count_reg == 0) begin
                    state_next = DONE;
                end else begin
                    {BCD_tmp, binary_next} = {BCD_reg, binary_reg} << 1;
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

    // Datapath Logic
    genvar i;
    generate
        for (i=0; i<15; i=i+4) begin
            assign BCD_next[i+3:i] = (state_reg == OP) ? ((BCD_tmp[i+3:i] > 4) ? BCD_tmp[i+3:i]+3 : BCD_tmp[i+3:i]) : 4'b0000;
        end
    endgenerate

    // Output Logic
    assign BCD_o = BCD_tmp;

endmodule
