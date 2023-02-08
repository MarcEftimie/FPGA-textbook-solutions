`timescale 1ns/1ps
`default_nettype none

module stopwatch #(
    parameter TICK_NS = 10000000
    )
    (
    input wire clk_i,
    input wire rst_i,
    input wire stop_i,
    output logic [3:0] an_o,
    output logic [6:0] sseg_o,
    output logic dp_o
);

    // Declarations
    logic [3:0] milliseconds_reg;
    logic [7:0] seconds_reg;
    logic [3:0] minutes_reg;
    logic [3:0] milliseconds_next;
    logic [7:0] seconds_next;
    logic [3:0] minutes_next;

    logic [3:0] in0;
    logic [3:0] in1;
    logic [3:0] in2;
    logic [3:0] in3;

    logic [$clog2(TICK_NS)-1:0] count_reg;
    logic [$clog2(TICK_NS)-1:0] count_next;

    logic [3:0] sseg;
    logic [3:0] hex;

    logic stop_reg;
    logic stop_next;
    logic stop;

    time_multiplexer TIME_MULTIPLEXER(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .in0_i(in0),
        .in1_i(in1),
        .in2_i(in2),
        .in3_i(in3),
        .an_o(an_o),
        .hex_o(hex)
    );

    hex_to_7_segment HEX_TO_7_SEGMENT(
        .hex_i(hex),
        .sseg_o(sseg_o)
    );

    debouncer DEBOUNCER_STOP(
        .clk_i(clk_i),
        .btn_i(stop_i),
        .pulse_o(stop)
    );

    // Registers
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            count_reg <= 0;
            milliseconds_reg <= 0;
            seconds_reg <= 0;
            minutes_reg <= 0;
            stop_reg <= 0;
        end else begin
            count_reg <= count_next;
            milliseconds_reg <= milliseconds_next;
            seconds_reg <= seconds_next;
            minutes_reg <= minutes_next;
            stop_reg <= stop_next;
        end
    end

    // Next State Logic
    always_comb begin
        count_next = count_reg;
        milliseconds_next = milliseconds_reg;
        seconds_next = seconds_reg;
        minutes_next = minutes_reg;
        if (~stop_reg) begin
            if (count_reg < TICK_NS) begin
                count_next = count_reg + 1;
            end else begin
                count_next = 0;
                if (milliseconds_reg < 9) begin
                    milliseconds_next = milliseconds_reg + 1;
                end else begin
                    milliseconds_next = 0;
                    if (seconds_reg[3:0] < 9) begin
                        seconds_next[3:0] = seconds_reg[3:0] + 1;
                    end else begin
                        seconds_next[3:0] = 0;
                        if (seconds_reg[7:4] < 5) begin
                            seconds_next[7:4] = seconds_reg[7:4] + 1;
                        end else begin
                            seconds_next[7:4] = 0;
                            if (minutes_reg < 9) begin
                                minutes_next = minutes_reg + 1;
                            end else begin
                                minutes_next = 0;
                            end
                        end
                    end
                end
            end
        end
    end

    assign stop_next = stop ? ~stop_reg : stop_reg;

    assign in0 = milliseconds_reg;
    assign in1 = seconds_reg[3:0];
    assign in2 = seconds_reg[7:4];
    assign in3 = minutes_reg;

endmodule
