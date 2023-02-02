`timescale 1ns/1ps
`default_nettype none

module binary_to_decimal (
    input wire [15:0] binary_in,
    output logic [15:0] decimal_out 
);

    always_comb begin
        decimal_out = binary_in;
        if (binary_in[3:0] == 9) begin
            decimal_out[3:0] = 0;
            if (binary_in[7:4] == 9) begin
                decimal_out[7:4] = 0;
                if (binary_in[11:8] == 9) begin
                    decimal_out[11:8] = 0; 
                    if (binary_in[15:11] == 9) begin
                        decimal_out[15:11] = 0;
                    end else begin
                        decimal_out[15:11] = binary_in[15:11];
                    end 
                end else begin
                    decimal_out[11:8] = binary_in[11:8];
                end
            end else begin
                decimal_out[7:4] = binary_in[7:4];
            end
        end else begin
            decimal_out[3:0] = binary_in[3:0];
        end
    end

endmodule
