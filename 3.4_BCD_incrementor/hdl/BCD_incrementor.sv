module BCD_incrementor (
    input wire [11:0] BCD_in,
    output logic [11:0] BCD_out 
);

    always_comb begin
        BCD_out = BCD_in;
        if (BCD_in[3:0] == 9) begin
            BCD_out[3:0] = 0;
            if (BCD_in[7:4] == 9) begin
                BCD_out[7:4] = 0;
                if (BCD_in[11:8] == 9) begin
                   BCD_out[11:8] = 0; 
                end else begin
                    BCD_out[11:8] = BCD_in[11:8] + 1;
                end
            end else begin
                BCD_out[7:4] = BCD_in[7:4] + 1;
            end
        end else begin
            BCD_out[3:0] = BCD_in[3:0] + 1;
        end
    end

endmodule
