`timescale 1ns/1ps
`default_nettype none

module fibonacci(
    input wire clk_i, reset_i,
    input wire start_i,
    input wire [7:0] iterations_bcd_i,
    output logic [6:0] seven_segment_o,
    output logic [3:0] an_o,
    output logic dp_o
);

    // Declarations
    typedef enum logic [1:0] {
        IDLE,
        OP_BCD_TO_BIN,
        DONE
    } state_main_d;

    state_main_d state_main_reg, state_main_next;


    logic start_main;

    delayed_detection_debouncing DEBOUNCER(
        .clk_i(clk_i),
        .btn_i(start_i),
        .debounced_o(start_main)
    );

    // Registers
    always_ff @(posedge clk_i, posedge reset_i) begin
        if (reset_i) begin
            state_main_reg <= IDLE;
        end else begin
            state_main_reg <= state_main_next;
        end
    end

    // Next State Logic
    always_comb begin
        state_main_next = state_main_reg;
        case (state_main_reg)
            IDLE : begin
                if (start_main) begin
                    
                end
            end
            OP_BCD_TO_BIN : begin
                state_main_next = DONE;
            end
            DONE : begin
                state_main_next = IDLE;
            end
            default : state_main_next = IDLE;
        endcase
    end


endmodule
