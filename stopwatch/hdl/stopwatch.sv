`timescale 1ns/1ps
`default_nettype none

module stopwatch #(
    parameter N = 24
    ) (
    input wire clk_i,
    input wire rst_i,
    input wire start_i,
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

    logic [N-1:0] count_reg;
    logic [N-1:0] count_next;

    logic [3:0] sseg;

    time_multiplexer TIME_MULTIPLEXER(
        .*,
        .in0_i(in0),
        .in1_i(in1),
        .in2_i(in2),
        .in3_i(in3),
        .sseg_o(sseg)
    );

    // Registers
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            count_reg <= 0;
            milliseconds_reg <= 0;
            seconds_reg <= 0;
            minutes_reg <= 0;
        end else begin
            count_reg <= count_next;
            milliseconds_reg <= milliseconds_next;
            seconds_reg <= seconds_next;
            minutes_reg <= minutes_next;
        end
    end

    // Next State Logic
    always_comb begin
        if (count_reg < 10000000) begin
            count_next = count_reg + 1;
        end else begin
            count_next = 0;
            milliseconds_next = milliseconds_reg + 1;
            if (milliseconds_reg < 9) begin
                milliseconds_next = milliseconds_reg + 1;
            end else begin
                milliseconds_next = 0;
                seconds_next = seconds_reg + 1;
                if (seconds_reg < 59) begin
                    seconds_next = seconds_reg + 1;
                end else begin
                    seconds_next = 0;
                    minutes_next = minutes_reg + 1;
                    if (minutes_reg < 9) begin
                        minutes_next = minutes_reg + 1;
                    end else begin
                        minutes_next = 0;
                    end
                end
            end
        end
    end

    assign in0 = milliseconds_reg;
    assign in1 = seconds[3:0];
    assign in2 = seconds[7:4];
    assign in3 = minutes_reg;

endmodule