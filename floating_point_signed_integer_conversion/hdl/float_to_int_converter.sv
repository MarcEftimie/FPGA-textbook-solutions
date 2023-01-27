module float_to_int_converter(
    input wire [12:0] float_i,
    output logic [7:0] int_o,
    output logic overflow, underflow
);

    logic sign;
    logic [3:0] exponent;
    logic [7:0] significand;
    logic [3:0] msb_significand;
    always_comb begin
        sign = float_i[12];
        exponent = float_i[11:8];
        significand = float_i[7:0];

        overflow = 1'b0;
        underflow = 1'b0;
        if (exponent > 7 && significand[7]) begin
            overflow = 1'b1;
        end else if (exponent == 0 && significand[7]) begin
            underflow = 1'b1;
        end else begin
            int_o[6:0] = significand >> (8-exponent);
        end

        int_o[7] = sign;
    end

endmodule