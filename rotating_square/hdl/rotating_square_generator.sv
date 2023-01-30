`timescale 1ns/1ps
`default_nettype none

module rotating_square_generator #(
    parameter N = 26,
    parameter TOP_SQUARE = 7'b0011100,
    parameter BOTTOM_SQUARE = 7'b1100010
    )(
    input wire clk_i,
    input wire rst_i,
    output logic [3:0] an_o,
    output logic [6:0] sseg_o
);

    logic [6:0] in0_reg;
    logic [6:0] in1_reg;
    logic [6:0] in2_reg;
    logic [6:0] in3_reg;
    logic [6:0] in0_next;
    logic [6:0] in1_next;
    logic [6:0] in2_next;
    logic [6:0] in3_next;

    // ABFG 7'b0011100
    // CDEG 7'b1100010

    logic [N-1:0] count_reg;
    logic [N-1:0] count_next;

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
        case(count_reg[N-1:N-3])
            3'b000 : in3_next = 7'b0011100;  
            3'b001 : in2_next = 7'b0011100;  
            3'b010 : in1_next = 7'b0011100;  
            3'b011 : in0_next = 7'b0011100;  
            3'b100 : in0_next = 7'b0100011;  
            3'b101 : in1_next = 7'b0100011;  
            3'b110 : in2_next = 7'b0100011;  
            3'b111 : in3_next = 7'b0100011;  
        endcase
        count_next = count_reg + 1;
    end

    time_multiplexer TIME_MULTIPLEXER(
        .*,
        .in0_i(in0_reg),
        .in1_i(in1_reg),
        .in2_i(in2_reg),
        .in3_i(in3_reg)
    );

endmodule