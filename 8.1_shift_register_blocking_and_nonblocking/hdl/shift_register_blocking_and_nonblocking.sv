
`timescale 1ns/1ps
`default_nettype none

module shift_register_blocking_and_nonblocking
    (
        input wire clk_i, reset_i,
        input wire x0,
        output logic x1
    );

    always_ff @(posedge clk_i) begin
        x1 <= x0;
    end

endmodule
