`timescale 1ns/1ps
`default_nettype none

module reaction_timer #(
    parameter DELAY_NS = 2000000,
    parameter BIN_N = 16,
    parameter BCD_N = 20,
    parameter TICK_N = 14
    ) (
    input wire clk_i, reset_i,
    input wire clear_i, start_i, stop_i,
    output logic [3:0] an_o,
    output logic [6:0] seven_segment_o,
    output logic dp_o
);

    
    // Declarations
    typedef enum logic [1:0] {
        IDLE,
        START,
        COUNT_UP,
        STOP
    } state_d;

    state_d state_reg, state_next;

    logic clear_tick;

    button_pulse_debouncer #(
        .DELAY_NS(DELAY_NS)
    ) CLEAR_DEBOUNCER(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .btn_i(clear_i),
        .tick_o(clear_tick)
    );

    logic start_tick;

    button_pulse_debouncer #(
        .DELAY_NS(DELAY_NS)
    ) START_DEBOUNCER(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .btn_i(start_i),
        .tick_o(start_tick)
    );

    logic stop_tick;

    button_pulse_debouncer #(
        .DELAY_NS(DELAY_NS)
    ) STOP_DEBOUNCER(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .btn_i(stop_i),
        .tick_o(stop_tick)
    );

    logic done_period_counter;
    logic [TICK_N-1:0] period_count;
    logic tick_reg, tick_next;
    logic period_changed_o;

    period_counter #(
        .TICK_N(TICK_N),
        .COUNT_N(17)
    ) PERIOD_COUNTER (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .tick_i(tick_reg),
        .period_count_o(period_count),
        .period_changed_o(period_changed_o),
        .done_o(done_period_counter)
    );

    logic start_bin_to_bcd_reg, start_bin_to_bcd_next;
    logic done_bin_to_bcd_reg;
    logic [BCD_N-1:0] bcd_reg, bcd_next, bcd;

    binary_to_BCD_converter #(
        .BIN_N(BIN_N),
        .BCD_N(BCD_N)
    ) BIN_to_BCD(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .start_i(period_changed_o),
        .binary_i(period_count + 1),
        .ready_o(),
        .done_o(done_bin_to_bcd_reg),
        .BCD_o(bcd)
    );

    logic [7:0] in0, in1, in2, in3;
    logic [7:0] hex;

    time_multiplexer TIME_MULTIPLEXER(
        .clk_i(clk_i),
        .rst_i(reset_i),
        .in0_i(in0),
        .in1_i(in1),
        .in2_i(in2),
        .in3_i(in3),
        .an_o(an_o),
        .hex_o(hex)
    );

    hex_to_7_segment HEX_TO_7_SEGMENT(
        .hex_i(hex),
        .sseg_o(seven_segment_o)
    );

    logic [26:0] delay_count_reg, delay_count_next;

    // Registers
    always_ff @(posedge clk_i, posedge reset_i) begin
        if (reset_i) begin
            state_reg <= IDLE;
            start_bin_to_bcd_reg <= 0;
            tick_reg <= 0;
            delay_count_reg <= 0;
            bcd_reg <= 0;
        end else begin
            state_reg <= state_next;
            start_bin_to_bcd_reg <= start_bin_to_bcd_next;
            tick_reg <= tick_next;
            delay_count_reg <= delay_count_next;
            bcd_reg <= bcd_next;
        end
    end

    // Next State Logic
    always_comb begin
        state_next = state_reg;
        start_bin_to_bcd_next = 0;
        tick_next = 0;
        delay_count_next = delay_count_reg;
        bcd_next = bcd_reg;
        case (state_reg)
            IDLE : begin
                if (start_tick) begin
                    delay_count_next = 0;
                    state_next = START;
                end
            end
            START : begin
                if (delay_count_reg < 100000000) begin // 100000000
                    delay_count_next = delay_count_reg + 1;
                end else begin
                    tick_next = 1;
                    state_next = COUNT_UP;
                end
            end
            COUNT_UP : begin
                if (done_bin_to_bcd_reg) begin
                    bcd_next = bcd;
                end
                if (stop_i) begin
                    tick_next = 1;
                end
                if (done_period_counter) begin
                    state_next = STOP;
                end
            end
            STOP : begin
                if (clear_i) begin
                    bcd_next = 0;
                    state_next = IDLE;
                end
            end
            default : state_next = IDLE;
        endcase
    end

    assign in0 = (state_reg == IDLE)     ?  8'hFF :
                 (state_reg == START)    ?  8'hFF :
                 (state_reg == COUNT_UP) ?  bcd_reg[3:0] :
                 (state_reg == STOP)     ?  bcd_reg[3:0] : 8'h00;
    assign in1 = (state_reg == IDLE)     ?  8'hFF :
                 (state_reg == START)    ?  8'hFF :
                 (state_reg == COUNT_UP) ?  bcd_reg[7:4] :
                 (state_reg == STOP)     ?  bcd_reg[7:4] : 8'h00;
    assign in2 = (state_reg == IDLE)     ?  8'b11001111 :
                 (state_reg == START)    ?  8'hFF :
                 (state_reg == COUNT_UP) ?  bcd_reg[11:8] :
                 (state_reg == STOP)     ?  bcd_reg[11:8] : 8'h00;
    assign in3 = (state_reg == IDLE)     ?  8'b10001001 :
                 (state_reg == START)    ?  8'hFF :
                 (state_reg == COUNT_UP) ?  bcd_reg[15:12] :
                 (state_reg == STOP)     ?  bcd_reg[15:12] : 8'h00;

    assign dp_o = 1;

endmodule
