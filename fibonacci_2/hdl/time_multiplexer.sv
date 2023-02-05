`timescale 1ns/1ps
`default_nettype none

module time_multiplexer #(
    parameter N = 18
    )(
    input wire clk_i,
    input wire rst_i,
    input wire [3:0] in0_i, in1_i, in2_i, in3_i,
    output logic [3:0] an_o,
    output logic [3:0] hex_o
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
                hex_o = in0_i;
            end
            2'b01 : begin
                an_o = 4'b1101;
                hex_o = in1_i;
            end
            2'b10 : begin
                an_o = 4'b1011;
                hex_o = in2_i;
            end
            default : begin
                an_o = 4'b0111;
                hex_o = in3_i;
            end
        endcase
    end

endmodule