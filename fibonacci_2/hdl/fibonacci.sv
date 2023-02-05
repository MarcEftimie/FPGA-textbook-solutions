`timescale 1ns/1ps
`default_nettype none

module fibonacci #(
    parameter DEBOUNCE_DELAY_NS = 20000000
    )
    (
    input wire clk_i, reset_i,
    input wire start_i,
    input wire [7:0] iterations_bcd_i,
    output logic [6:0] seven_segment_o,
    output logic [3:0] an_o,
    output logic dp_o
);

    // Declarations
    typedef enum logic [2:0] {
        IDLE_MAIN,
        OP_BCD_TO_BIN_MAIN,
        OP_FIBONACCI_MAIN,
        OP_BIN_TO_BCD_MAIN,
        DONE_MAIN
    } state_main_d;

    state_main_d state_main_reg, state_main_next;

    typedef enum logic {
        IDLE_BCD_TO_BIN,
        OP_BCD_TO_BIN
    } state_BCD_to_BIN_d;

    state_BCD_to_BIN_d state_BCD_to_BIN_reg, state_BCD_to_BIN_next;

    typedef enum logic {
        IDLE_FIBONACCI,
        OP_FIBONACCI
    } state_fibonacci_d;

    state_fibonacci_d state_fibonacci_reg, state_fibonacci_next;

    typedef enum logic {
        IDLE_BIN_TO_BCD,
        OP_BIN_TO_BCD
    } state_BIN_to_BCD_d;

    state_BIN_to_BCD_d state_bin_to_bcd_reg, state_bin_to_bcd_next;

    logic start_main;

    logic [31:0] binary_reg, binary_next, binary_tmp;
    logic [15:0] BCD_reg, BCD_next, BCD_tmp;

    logic [15:0] bit_count_reg, bit_count_next;
    
    logic [13:0] fib0_reg, fib0_next, fib1_reg, fib1_next; 

    logic [3:0] hex;

    delayed_detection_debouncing #(
        .DELAY_NS(DEBOUNCE_DELAY_NS)
        ) DEBOUNCER(
        .clk_i(clk_i),
        .btn_i(start_i),
        .debounced_o(start_main)
    );

    time_multiplexer TIME_MULTIPLEXER(
        .clk_i(clk_i),
        .rst_i(reset_i),
        .in0_i(BCD_reg[3:0]),
        .in1_i(BCD_reg[7:4]),
        .in2_i(BCD_reg[11:8]),
        .in3_i(BCD_reg[11:8]),
        .an_o(an_o),
        .hex_o(hex)
    );

    hex_to_7_segment HEX_TO_7_SEGMENT(
        .hex_i(hex),
        .sseg_o(seven_segment_o)
    );

    // Registers
    always_ff @(posedge clk_i, posedge reset_i) begin
        if (reset_i) begin
            state_main_reg <= IDLE_MAIN;
            state_BCD_to_BIN_reg <= IDLE_BCD_TO_BIN;
            state_fibonacci_reg <= IDLE_FIBONACCI;
            state_bin_to_bcd_reg <= IDLE_BIN_TO_BCD;

            bit_count_reg <= 31;
            binary_reg <= 0;
            BCD_reg <= 0;

            fib0_reg <= 0;
            fib1_reg <= 1;
        end else begin
            state_main_reg <= state_main_next;
            state_BCD_to_BIN_reg <= state_BCD_to_BIN_next;
            state_fibonacci_reg <= state_fibonacci_next;
            state_bin_to_bcd_reg <= state_bin_to_bcd_next;

            bit_count_reg <= bit_count_next;
            binary_reg <= binary_next;
            BCD_reg <= BCD_next;

            fib0_reg <= fib0_next;
            fib1_reg <= fib1_next;
        end
    end

    // Next State Logic
    always_comb begin
        state_main_next = state_main_reg;
        state_BCD_to_BIN_next = state_BCD_to_BIN_reg;
        state_fibonacci_next = state_fibonacci_reg;
        state_bin_to_bcd_next = state_bin_to_bcd_reg;

        binary_next = binary_reg;
        BCD_next = BCD_reg;
        bit_count_next = bit_count_reg;

        fib0_next = fib0_reg;
        fib1_next = fib1_reg;

        case (state_main_reg)
            IDLE_MAIN : begin
                if (start_main) begin
                    bit_count_next = 31;
                    binary_next = 0;
                    BCD_next = 0;

                    fib0_next = 0;
                    fib1_next = 1;
                    bit_count_next = 31;
                    BCD_next = iterations_bcd_i;
                    state_main_next = OP_BCD_TO_BIN_MAIN;
                    state_BCD_to_BIN_next = OP_BCD_TO_BIN;
                end
            end
            OP_BCD_TO_BIN_MAIN : begin
                case(state_BCD_to_BIN_reg)
                    IDLE_BCD_TO_BIN : begin
                        state_BCD_to_BIN_next = IDLE_BCD_TO_BIN;
                    end
                    OP_BCD_TO_BIN : begin
                        {BCD_tmp, binary_next} = {BCD_reg, binary_reg} >> 1;
                        BCD_next = BCD_tmp[3:0] > 4 ? BCD_tmp - 3 : BCD_tmp;
                        if (bit_count_reg == 0) begin
                            fib0_next = 0;
                            fib1_next = 1;
                            state_BCD_to_BIN_next = IDLE_BCD_TO_BIN;
                            state_main_next = OP_FIBONACCI_MAIN;
                            state_fibonacci_next = OP_FIBONACCI;
                        end else begin
                            bit_count_next = bit_count_reg - 1;
                            state_BCD_to_BIN_next = OP_BCD_TO_BIN;
                        end
                    end
                    default : begin
                        state_BCD_to_BIN_next = IDLE_BCD_TO_BIN;
                    end
                endcase
            end
            OP_FIBONACCI_MAIN : begin
                case(state_fibonacci_reg)
                    IDLE_FIBONACCI : begin
                        state_fibonacci_next = IDLE_FIBONACCI;
                    end
                    OP_FIBONACCI : begin
                        if (BCD_reg > 9999) begin
                            BCD_next = 9999;
                            fib1_next = 0;
                            bit_count_next = 14;
                            binary_next = fib1_reg;
                            state_fibonacci_next = IDLE_FIBONACCI;
                            state_main_next = OP_BIN_TO_BCD_MAIN;
                        end else if (binary_reg == 0) begin
                            fib1_next = 0;
                            bit_count_next = 14;
                            binary_next = fib1_reg;
                            state_fibonacci_next = IDLE_FIBONACCI;
                            state_main_next = OP_BIN_TO_BCD_MAIN;
                            state_bin_to_bcd_next = OP_BIN_TO_BCD;
                        end else if (binary_reg == 1) begin
                            bit_count_next = 14;
                            binary_next = fib1_reg;
                            state_fibonacci_next = IDLE_FIBONACCI;
                            state_main_next = OP_BIN_TO_BCD_MAIN;
                            state_bin_to_bcd_next = OP_BIN_TO_BCD;
                        end else begin
                            fib0_next = fib1_reg;
                            fib1_next = fib0_reg + fib1_reg;
                            binary_next = binary_reg - 1;
                        end
                    end
                    default : begin
                        state_fibonacci_next = IDLE_FIBONACCI;
                    end
                endcase
            end
            OP_BIN_TO_BCD_MAIN : begin
                case(state_bin_to_bcd_reg)
                    IDLE_BIN_TO_BCD : begin
                        state_bin_to_bcd_next = IDLE_BIN_TO_BCD;
                    end
                    OP_BIN_TO_BCD : begin
                        if (bit_count_reg == 0) begin
                            state_bin_to_bcd_next = IDLE_BIN_TO_BCD;
                            state_main_next = DONE_MAIN;
                        end else begin
                            {BCD_tmp, binary_next[13:0]} = {BCD_reg, binary_reg[13:0]} << 1;
                            BCD_next[3:0] = BCD_tmp[3:0] > 4 ? BCD_tmp[3:0]+3 : BCD_tmp[3:0];
                            BCD_next[7:4] = BCD_tmp[7:4] > 4 ? BCD_tmp[7:4]+3 : BCD_tmp[7:4];
                            BCD_next[11:8] = BCD_tmp[11:8] > 4 ? BCD_tmp[11:8]+3 : BCD_tmp[11:8];
                            BCD_next[15:12] = BCD_tmp[15:12] > 4 ? BCD_tmp[15:12]+3 : BCD_tmp[15:12];
                            bit_count_next = bit_count_reg - 1;
                        end
                    end
                    default : begin
                        state_bin_to_bcd_next = IDLE_BIN_TO_BCD;
                    end
                endcase
            end
            DONE_MAIN : begin
                state_main_next = IDLE_MAIN;
            end
            default : state_main_next = IDLE_MAIN;
        endcase
    end

    assign dp_o = 1;

endmodule
