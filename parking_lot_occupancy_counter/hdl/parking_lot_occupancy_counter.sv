`timescale 1ns/1ps
`default_nettype none

module parking_lot_occupancy_counter (
    input wire clk_i,
    input wire reset_i,
    input wire sensor_a_i,
    input wire sensor_b_i,
    output logic [6:0] seven_segment_o,
    output logic [3:0] an_o,
    output logic dp_o
);

    // Declarations
    typedef enum logic [3:0] {
        IDLE,
        ENTER_0,
        ENTER_1,
        ENTER_2,
        ENTER_3,
        EXIT_0,
        EXIT_1,
        EXIT_2,
        EXIT_3
    } state_d;

    state_d state_reg, state_next;

    logic sensor_a_reg, sensor_b_reg;
    logic sensor_a_next, sensor_b_next;

    logic [15:0] car_count_reg, car_count_next;

    logic [3:0] in0, in1, in2, in3;
    logic [3:0] hex;

    delayed_detection_debouncing SENSOR_A(
        .clk_i(clk_i),
        .btn_i(sensor_a_i),
        .debounced_o(sensor_a_next)
    );

    delayed_detection_debouncing SENSOR_B(
        .clk_i(clk_i),
        .btn_i(sensor_b_i),
        .debounced_o(sensor_b_next)
    );

    time_multiplexer TIME_MULTIPLEXER(
        .clk_i(clk_i),
        .rst_i(reset_i),
        .in0_i(in0),
        .in1_i(in1),
        .in2_i(in2),
        .in3_i(in3),
        .an_o(an_o),
        .hex_o(hex)
    );

    hex_to_7_segment HEX_TO_7_SEGMENT(
        .hex_i(hex),
        .sseg_o(seven_segment_o)
    );

    binary_to_decimal BINARY_TO_DECIMAL(
        .binary_in(car_count_reg),
        .decimal_out({in3, in2, in1, in0})
    );

    // Registers
    always_ff @(posedge clk_i, posedge reset_i) begin
        if (reset_i) begin
            state_reg <= IDLE;
            sensor_a_reg <= 0;
            sensor_b_reg <= 0;
            car_count_reg <= 0;
        end else begin
            state_reg <= state_next;
            sensor_a_reg <= sensor_a_next;
            sensor_b_reg <= sensor_b_next;
            car_count_reg <= car_count_next;
        end
    end

    // Next State logic
    always_comb begin
        case (state_reg)
            IDLE : begin
                if (~sensor_a_reg & ~sensor_b_reg) state_next = IDLE;
                else if (sensor_a_reg & ~sensor_b_reg) state_next = ENTER_0;
                else state_next = EXIT_0;
            end
            ENTER_0 : begin
                if (sensor_a_reg & ~sensor_b_reg) state_next = ENTER_0;
                else if (sensor_a_reg & sensor_b_reg) state_next = ENTER_1;
                else state_next = IDLE;
            end
            ENTER_1 : begin
                if (sensor_a_reg & sensor_b_reg) state_next = ENTER_1;
                else if (sensor_a_reg & ~sensor_b_reg) state_next = ENTER_0;
                else state_next = ENTER_2;
            end
            ENTER_2 : begin
                if (~sensor_a_reg & sensor_b_reg) state_next = ENTER_2;
                else if (sensor_a_reg & sensor_b_reg) state_next = ENTER_1;
                else state_next = ENTER_3; 
            end
            ENTER_3 : begin
                state_next = IDLE;
            end
            EXIT_0 : begin
                if (~sensor_a_reg & sensor_b_reg) state_next = EXIT_0;
                else if (sensor_a_reg & sensor_b_reg) state_next = EXIT_1;
                else state_next = IDLE;
            end
            EXIT_1 : begin
                if (sensor_a_reg & sensor_b_reg) state_next = EXIT_1;
                else if (~sensor_a_reg & sensor_b_reg) state_next = EXIT_0;
                else state_next = EXIT_2;
            end
            EXIT_2 : begin
                if (sensor_a_reg & ~sensor_b_reg) state_next = EXIT_2;
                else if (sensor_a_reg & sensor_b_reg) state_next = EXIT_1;
                else state_next = EXIT_3;
            end
            EXIT_3 : begin
                state_next = IDLE;
            end
            default : begin
                state_next = IDLE;
            end
        endcase
    end

    assign car_count_next =
        state_reg == ENTER_3 ? car_count_reg + 1 :
        car_count_reg == 0 ? 0 :
        state_reg == EXIT_3 ? car_count_reg - 1 : car_count_reg;

    // Output Logic
    assign dp_o = 1;
endmodule
