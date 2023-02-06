`timescale 1ns/1ps
`default_nettype none

module auto_scaled_low_frequency_counter #(
    parameter DELAY_NS = 250000
    ) (
    input wire clk_i, reset_i,
    input wire btn_i,
    output logic [3:0] an_o,
    output logic [6:0] seven_segment_o,
    output logic dp_o,
    output logic [15:0] test_o
);

    localparam bin_N = 24;
    localparam bcd_N = 16;
    // Declarations
    typedef enum logic [2:0] {
        IDLE,
        OP_COUNTER,
        OP_BIN_TO_BCD,
        OP_DIVISION,
        OP_BCD_NORMALIZER
    } state_d;

    state_d state_reg, state_next;

    logic btn_tick;

    button_pulse_debouncer #(
        .DELAY_NS(DELAY_NS)
    ) DEBOUNCER(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .btn_i(btn_i),
        .tick_o(btn_tick)
    );

    logic done_period_counter;
    logic [31:0] period_count_reg, period_count_next;
    logic [31:0] period_count;
    // logic [31:0] frequency_reg, frequency_next;

    period_counter PERIOD_COUNTER(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .tick_i(btn_tick),
        .period_count_o(period_count),
        .done_o(done_period_counter)
    );

    logic start_division_reg, start_division_next;
    logic done_division;
    logic [bin_N-1:0] frequency_reg, frequency_next, frequency;

    division DIVISION(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .start_i(start_division_reg),
        .dividend_i(1000000),
        .divisor_i(period_count_reg),
        .quotient_o(frequency),
        .done_o(done_division)
    );

    logic start_bin_to_bcd_reg, start_bin_to_bcd_next;
    logic done_bin_to_bcd;
    logic [bcd_N-1:0] bcd_reg, bcd_next;
    logic [bcd_N-1:0] bcd;

    binary_to_BCD_converter #(
        .N(bin_N),
        .bcd_N(bcd_N)
    ) BIN_to_BCD(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .start_i(start_bin_to_bcd_reg),
        .binary_i(frequency_reg),
        .ready_o(),
        .done_o(done_bin_to_bcd),
        .BCD_o(bcd)
    );

    logic start_bcd_normalizer_reg, start_bcd_normalizer_next;
    logic done_bcd_normalizer;
    logic [bcd_N-1:0] bcd_normalized_next, bcd_normalized_reg;
    logic [bcd_N-1:0] bcd_normalized;
    logic [3:0] power;


    BCD_normalizer #(
        .N(bcd_N)
    ) BCD_NORMALIZER (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .start_i(start_bcd_normalizer_reg),
        .BCD_i(bcd_reg),
        .done_o(done_bcd_normalizer),
        .BCD_o(bcd_normalized),
        .power_o(power)
    );

    logic [4:0] in0, in1, in2, in3;
    logic [3:0] hex;

    time_multiplexer TIME_MULTIPLEXER(
        .clk_i(clk_i),
        .rst_i(reset_i),
        .in0_i(in0),
        .in1_i(in1),
        .in2_i(in2),
        .in3_i(in3),
        .an_o(an_o),
        .hex_o(hex),
        .dp_o(dp_o)
    );

    hex_to_7_segment HEX_TO_7_SEGMENT(
        .hex_i(hex),
        .sseg_o(seven_segment_o)
    );

    // Registers
    always_ff @(posedge clk_i, posedge reset_i) begin
        if (reset_i) begin
            state_reg <= IDLE;
            start_division_reg <= 0;
            start_bin_to_bcd_reg <= 0;
            start_bcd_normalizer_reg <= 0;
            bcd_normalized_reg <= 0;
            period_count_reg <= 0;
            bcd_reg <= 0;
            frequency_reg <= 0;
        end else begin
            state_reg <= state_next;
            start_division_reg <= start_division_next;
            start_bin_to_bcd_reg <= start_bin_to_bcd_next;
            start_bcd_normalizer_reg <= start_bcd_normalizer_next;
            bcd_normalized_reg <= bcd_normalized_next;
            period_count_reg <= period_count_next;
            bcd_reg <= bcd_next;
            frequency_reg <= frequency_next;
        end
    end

    // Next State Logic
    always_comb begin
        state_next = state_reg;
        start_division_next = 0;
        start_bin_to_bcd_next = 0;
        start_bcd_normalizer_next = 0;
        bcd_normalized_next = bcd_normalized_reg;
        period_count_next = period_count_reg;
        bcd_next = bcd_reg;
        frequency_next = frequency_reg;
        case (state_reg)
            IDLE : begin
                if (btn_tick) begin
                    state_next = OP_COUNTER;
                end
            end
            OP_COUNTER : begin
                if (done_period_counter) begin
                    period_count_next = period_count;
                    start_division_next = 1;
                    state_next = OP_DIVISION;
                end
            end
            OP_DIVISION : begin
                if (done_division) begin
                    frequency_next = frequency;
                    start_bin_to_bcd_next = 1;
                    state_next = OP_BIN_TO_BCD;
                end
            end
            OP_BIN_TO_BCD : begin
                if (done_bin_to_bcd) begin
                    bcd_next = bcd;
                    start_bcd_normalizer_next = 1;
                    state_next = OP_BCD_NORMALIZER;
                end
            end
            OP_BCD_NORMALIZER : begin
                if (done_bcd_normalizer) begin
                    bcd_normalized_next = bcd_normalized;
                    state_next = OP_COUNTER;
                end
            end
            default : state_next = IDLE;
        endcase
    end

    assign in0 = {1'b1, bcd_normalized_reg[bcd_N-13:bcd_N-16]};
    assign in1 = {1'b1, bcd_normalized_reg[bcd_N-9:bcd_N-12]};
    assign in2 = {1'b1, bcd_normalized_reg[bcd_N-5:bcd_N-8]};            
    assign in3 = {1'b1, bcd_normalized_reg[bcd_N-1:bcd_N-4]};

    assign test_o = {bcd_reg[10:0], frequency_reg[4:0]};

endmodule
