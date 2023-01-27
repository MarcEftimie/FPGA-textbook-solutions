module int_to_float_converter(
    input wire [7:0] int_i,
    output logic [12:0] float_o
);

    logic sign;
    logic [3:0] exponent;
    logic [7:0] significand;
    always_comb begin
        sign = int_i[7];
        casex (int_i[6:0])
            7'b1 : exponent = 1;
            7'b1x : exponent = 2;
            7'b1xx : exponent = 3;
            7'b1xxx : exponent = 4;
            7'b1xxxx : exponent = 5;
            7'b1xxxxx : exponent = 6;
            7'b1xxxxxx : exponent = 7;
            default : exponent = 0;
        endcase
        significand = {int_i[6:0] << (7 - exponent), 1'b0};

        float_o = {sign, exponent, significand};
    end

endmodule