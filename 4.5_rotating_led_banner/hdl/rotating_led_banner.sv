`timescale 1ns/1ps
`default_nettype none

module rotating_led_banner #(
    parameter N = 27
    )(
    input wire clk_i,
    input wire rst_i,
    output logic [3:0] an_o,
    output logic [6:0] sseg_o,
    output logic dp_o
);

    // Declarations
    logic [3:0] in0_reg;
    logic [3:0] in1_reg;
    logic [3:0] in2_reg;
    logic [3:0] in3_reg;
    logic [3:0] in0_next;
    logic [3:0] in1_next;
    logic [3:0] in2_next;
    logic [3:0] in3_next;

    logic [39:0] data_reg;
    logic [39:0] data_next;

    logic [39:0] shifted_data;

    logic [N-1:0] count_reg;
    logic [N-1:0] count_next;

    logic [3:0] hex;

    time_multiplexer TIME_MULTIPLEXER(
        .*,
        .in0_i(in0_reg),
        .in1_i(in1_reg),
        .in2_i(in2_reg),
        .in3_i(in3_reg),
        .hex_o(hex)
    );

    hex_to_7_segment HEX_TO_7_SEGMENT(
        .hex_i(hex),
        .sseg_o(sseg_o)
    );

    parameterized_barrel_shifter #(
        .N(40)
        ) BARREL_SHIFTER(
        .data_i(data_reg),
        .shift_amount_i(7'b0000100),
        .shift_direction_i(1),
        .shifted_data_o(shifted_data)
    );

    // Registers
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            count_reg <= 0;
            in0_reg <= 0;
            in1_reg <= 0;
            in2_reg <= 0;
            in3_reg <= 0;
            data_reg <= 40'h0123456789;
        end else begin
            count_reg <= count_next;
            in0_reg <= in0_next;
            in1_reg <= in1_next;
            in2_reg <= in2_next;
            in3_reg <= in3_next;
            data_reg <= data_next;
        end
    end

    // Next State Logic
    always_comb begin
        in0_next = data_reg[3:0];
        in1_next = data_reg[7:4];
        in2_next = data_reg[11:8];
        in3_next = data_reg[15:12];
        count_next = count_reg + 1;
        data_next = data_reg;
        if (count_reg < 55555554) begin // 55555554
        end else begin
            data_next = shifted_data;
            count_next = 0;
        end
    end

    // Output Logic
    assign dp_o = 1;

endmodule