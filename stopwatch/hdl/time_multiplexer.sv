`timescale 1ns/1ps
`default_nettype none

module time_multiplexer #(
    parameter N = 18
    )(
    input wire clk_i,
    input wire rst_i,
    input wire [3:0] in0_i, in1_i, in2_i, in3_i,
    output logic [3:0] an_o,
    output logic [3:0] sseg_o
);

    // Declarations
    logic [N-1:0] count_reg;
    logic [N-1:0] count_next;

    // Registers
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            count_reg <= 0;
        end else begin
            count_reg <= count_next;
        end
    end

    // Next State Logic
    assign count_next = count_reg + 1;

    always_comb begin
        case(count_reg[N-1:N-2])
            2'b00 : begin
                an_o = 4'b1110;
                sseg_o = in0_i;
            end
            2'b01 : begin
                an_o = 4'b1101;
                sseg_o = in1_i;
            end
            2'b10 : begin
                an_o = 4'b1011;
                sseg_o = in2_i;
            end
            default : begin
                an_o = 4'b0111;
                sseg_o = in3_i;
            end
        endcase
    end

    always_comb begin
        case(sseg)
            4'h0 : sseg_o = 7'b1000000;
            4'h1 : sseg_o = 7'b1111001;
            4'h2 : sseg_o = 7'b0100100;
            4'h3 : sseg_o = 7'b0110000;
            4'h4 : sseg_o = 7'b0011001;
            4'h5 : sseg_o = 7'b0010010;
            4'h6 : sseg_o = 7'b0000010;
            4'h7 : sseg_o = 7'b1111000;
            4'h8 : sseg_o = 7'b0000000;
            4'h9 : sseg_o = 7'b0010000;
        endcase
    end

endmodule