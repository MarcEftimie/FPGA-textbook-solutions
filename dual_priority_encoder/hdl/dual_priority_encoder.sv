module dual_priority_encoder (
    input wire [11:0] req,
    output logic [3:0] first, 
    output logic [3:0] second 
);
    
    always_comb begin
        casex (req)
            12'b1 : first = 1;
            12'b1x : first = 2;
            12'b1xx : first = 3;
            12'b1xxx : first = 4;
            12'b1xxxx : first = 5;
            12'b1xxxxx : first = 6;
            12'b1xxxxxx : first = 7;
            12'b1xxxxxxx : first = 8;
            12'b1xxxxxxxx : first = 9;
            12'b1xxxxxxxxx : first = 10;
            12'b1xxxxxxxxxx : first = 11;
        endcase

        casex (req)
            12'b1 : second = 1;
            12'b1x : second = 2;
            12'b1xx : second = 3;
            12'b1xxx : second = 4;
            12'b1xxxx : second = 5;
            12'b1xxxxx : second = 6;
            12'b1xxxxxx : second = 7;
            12'b1xxxxxxx : second = 8;
            12'b1xxxxxxxx : second = 9;
            12'b1xxxxxxxxx : second = 10;
            12'b1xxxxxxxxxx : second = 11;
        endcase
    end

endmodule