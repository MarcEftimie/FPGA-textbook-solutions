`timescale 1ns/1ps
`default_nettype none

module heartbeat_generator #(
    parameter N = 27,
    parameter LEFT_LINE = 7'b1001111,
    parameter RIGHT_LINE = 7'b1111001
    )(
    input wire clk_i,
    input wire rst_i,
    output logic [3:0] an_o,
    output logic [6:0] sseg_o,
    output logic dp_o
);

    // Declarations
    logic [6:0] in0_reg;
    logic [6:0] in1_reg;
    logic [6:0] in2_reg;
    logic [6:0] in3_reg;
    logic [6:0] in0_next;
    logic [6:0] in1_next;
    logic [6:0] in2_next;
    logic [6:0] in3_next;

    logic [N-1:0] count_reg;
    logic [N-1:0] count_next;

    assign dp_o = 1;

    time_multiplexer TIME_MULTIPLEXER(
        .*,
        .in0_i(in0_reg),
        .in1_i(in1_reg),
        .in2_i(in2_reg),
        .in3_i(in3_reg)
    );

    // Registers
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            count_reg <= 0;
            in0_reg <= 0;
            in1_reg <= 0;
            in2_reg <= 0;
            in3_reg <= 0;
        end else begin
            count_reg <= count_next;
            in0_reg <= in0_next;
            in1_reg <= in1_next;
            in2_reg <= in2_next;
            in3_reg <= in3_next;
        end
    end

    // Next State Logic
    always_comb begin
        in0_next = 7'b1111111;
        in1_next = 7'b1111111;
        in2_next = 7'b1111111;
        in3_next = 7'b1111111;
        count_next = count_reg + 1;
        if (count_reg < 27777777) begin
            in2_next = RIGHT_LINE;
            in1_next = LEFT_LINE;
        end else if (count_reg < 55555554) begin
            in2_next = LEFT_LINE;
            in1_next = RIGHT_LINE;
        end else if (count_reg < 83333331)begin
            in3_next = LEFT_LINE;
            in0_next = RIGHT_LINE;
        end else begin
            count_next = 0;
        end
    end

endmodule