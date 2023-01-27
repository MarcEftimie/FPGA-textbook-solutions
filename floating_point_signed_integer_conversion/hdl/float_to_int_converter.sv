module float_to_int_converter(
    input wire [12:0] float_i;
    output logic [7:0] int_o;
);

    logic sign;
    logic [3:0] exponent;
    logic [7:0] significand;
    always_comb begin
        sign = float_i[12];
        exponent = float_i[11:8];
        significand = float_i[7:0];
    end

endmodule