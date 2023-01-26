module dual_priority_encoder (
    input wire [11:0] req_i,
    output logic [3:0] first_o, 
    output logic [3:0] second_o
);
    
    logic [11:0] decoded_first;
    logic [11:0] req_filtered;
    always_comb begin
        casex (req_i)
            12'b1 : first_o = 1;
            12'b1x : first_o = 2;
            12'b1xx : first_o = 3;
            12'b1xxx : first_o = 4;
            12'b1xxxx : first_o = 5;
            12'b1xxxxx : first_o = 6;
            12'b1xxxxxx : first_o = 7;
            12'b1xxxxxxx : first_o = 8;
            12'b1xxxxxxxx : first_o = 9;
            12'b1xxxxxxxxx : first_o = 10;
            12'b1xxxxxxxxxx : first_o = 11;
            default : first_o = 0;
        endcase

        case (first_o)
            1  : decoded_first = 12'b000000000001;
            2  : decoded_first = 12'b000000000010;
            3  : decoded_first = 12'b000000000100;
            4  : decoded_first = 12'b000000001000;
            5  : decoded_first = 12'b000000010000;
            6  : decoded_first = 12'b000000100000;
            7  : decoded_first = 12'b000001000000;
            8  : decoded_first = 12'b000010000000;
            9  : decoded_first = 12'b000100000000;
            10 : decoded_first = 12'b001000000000;
            11 : decoded_first = 12'b010000000000;
            12 : decoded_first = 12'b100000000000;
            default : decoded_first = 12'b0;
        endcase

        req_filtered = req_i ^ decoded_first;

        casex (req_filtered)
            12'b1 : second_o = 1;
            12'b1x : second_o = 2;
            12'b1xx : second_o = 3;
            12'b1xxx : second_o = 4;
            12'b1xxxx : second_o = 5;
            12'b1xxxxx : second_o = 6;
            12'b1xxxxxx : second_o = 7;
            12'b1xxxxxxx : second_o = 8;
            12'b1xxxxxxxx : second_o = 9;
            12'b1xxxxxxxxx : second_o = 10;
            12'b1xxxxxxxxxx : second_o = 11;
            default : second_o = 0;
        endcase

    end

endmodule