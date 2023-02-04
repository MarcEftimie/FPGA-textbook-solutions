`timescale 1ns/1ps
`default_nettype none

module fibonacci_top (
    input wire clk_i, reset_i,
    input wire start_i,
    input wire [7:0] iterations_bcd_i,
    output logic [6:0] seven_segment_o,
    output logic [3:0] an_o,
    output logic [6:0] iter_o,
    output logic dp_o
);

    // Declarations
    typedef enum logic [1:0] {
        IDLE,
        OP_BCD_TO_BIN,
        OP_COMPUTE_FIBONACCI,
        OP_BIN_TO_BCD
    } state_d;

    state_d state_reg, state_next;

    logic start;

    logic [6:0] iterations_bin_reg;
    logic [6:0] iterations_bin_next;
    logic [6:0] iterations_bin;

    logic start_BCD_to_bin;
    logic done_BCD_to_bin;

    logic overflow_reg;
    logic overflow_next;

    logic [13:0] fibonacci_num_bin_reg;
    logic [13:0] fibonacci_num_bin_next;

    logic start_fib;
    logic done_fib;
    logic overflow;
    logic [13:0] fibonacci_num_bin;

    logic [15:0] fibonacci_num_BCD_reg;
    logic [15:0] fibonacci_num_BCD_next;

    logic start_bin_to_bcd;
    logic done_bin_to_bcd;
    logic [15:0] fibonacci_num_BCD;

    logic [3:0] hex;

    button_pulse_debouncer DEBOUNCER(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .btn_i(start_i),
        .pulse_o(start)
    );

    BCD_to_binary_converter #(
        .N(8)
        ) BCD_TO_BIN(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .start_i(start_BCD_to_bin),
        .BCD_i(iterations_bcd_i),
        .ready_o(),
        .done_o(done_BCD_to_bin),
        .binary_o(iterations_bin)
    );

    fibonacci_generator FIBONACCI_GENERATOR(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .start_i(start_fib),
        .iterations_i(iterations_bin_reg),
        .ready_o(),
        .done_o(done_fib),
        .overflow_o(overflow),
        .fibonacci_o(fibonacci_num_bin)
    );

    binary_to_BCD_converter #(
        .N(14)
        ) BIN_TO_BCD(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .start_i(start_bin_to_bcd),
        .binary_i(fibonacci_num_bin_reg),
        .ready_o(),
        .done_o(done_bin_to_bcd),
        .BCD_o(fibonacci_num_BCD)
    );

    time_multiplexer TIME_MULTIPLEXER(
        .clk_i(clk_i),
        .rst_i(reset_i),
        .in0_i(fibonacci_num_BCD_reg[3:0]),
        .in1_i(fibonacci_num_BCD_reg[7:4]),
        .in2_i(fibonacci_num_BCD_reg[11:8]),
        .in3_i(fibonacci_num_BCD_reg[15:12]),
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
            state_reg <= IDLE;
            fibonacci_num_bin_reg <= 0;
            fibonacci_num_BCD_reg <= 0;
            iterations_bin_reg <= 0;
            overflow_reg <= 0;
        end else begin
            state_reg <= state_next;
            fibonacci_num_bin_reg <= fibonacci_num_bin_next;
            fibonacci_num_BCD_reg <= fibonacci_num_BCD_next;
            iterations_bin_reg <= iterations_bin_next;
            overflow_reg <= overflow_next;
        end
    end

    // Next State Logic
    always_comb begin
        state_next = state_reg;
        fibonacci_num_bin_next = fibonacci_num_bin_reg;
        fibonacci_num_BCD_next = fibonacci_num_BCD_reg;
        iterations_bin_next = iterations_bin_reg;
        overflow_next = overflow_reg;
        start_BCD_to_bin = 0;

        case (state_reg)
            IDLE : begin
                if (start) begin
                    state_next = OP_BCD_TO_BIN;
                    start_BCD_to_bin = 1;
                end
            end
            OP_BCD_TO_BIN : begin
                if (done_BCD_to_bin) begin
                    iterations_bin_next = iterations_bin;
                    state_next = OP_COMPUTE_FIBONACCI;                    
                end
            end
            OP_COMPUTE_FIBONACCI : begin
                if (done_fib) begin
                    fibonacci_num_bin_next = fibonacci_num_bin;
                    overflow_next = overflow;
                    start_fib = 0;
                    state_next = OP_BIN_TO_BCD;
                end else begin
                    start_fib = 1;
                end
            end
            OP_BIN_TO_BCD : begin
                if (done_bin_to_bcd) begin
                    fibonacci_num_BCD_next = fibonacci_num_BCD;
                    start_bin_to_bcd = 0;
                    state_next = IDLE;
                end else begin
                    start_bin_to_bcd = 1;
                end
            end
            default : state_next = IDLE;
        endcase
    end

    // Outputs
    assign dp_o = 1;
    assign iter_o = iterations_bin_reg;

endmodule
