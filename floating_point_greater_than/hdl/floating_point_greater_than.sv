`timescale 1ns/1ps
`default_nettype none

module floating_point_greater_than(
    input wire [12:0] a,
    input wire [12:0] b,
    output logic gt
);

    always_comb begin
        if (a[12] > b[12]) begin
            gt = 1;
        end else if (a[12] < b[12]) begin
            gt = 0;
        end else begin
            if (a[11:8] > b[11:8]) begin
                gt = a[12] == 0 ? 1 : 0;
            end else if (a[11:8] < b[11:8]) begin
                gt = a[12] == 0 ? 0 : 1;
            end else begin
                if (a[7:0] > b[7:0]) begin
                    gt = a[12] == 0 ? 1 : 0;
                end else if (a[7:0] < b[7:0]) begin
                    gt = a[12] == 0 ? 0 : 1;
                end else begin
                    gt = 0;
                end
            end
        end
    end

endmodule