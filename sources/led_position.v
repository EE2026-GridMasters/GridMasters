`timescale 1ns / 1ps

module led_position(
    input start_flag,
    input move_clk,
    output reg [3:0] position = 4'd0
);

    always @(posedge move_clk) begin
        if (!start_flag) begin
            position <= 4'd0;
        end else begin
            if (position == 4'd8)
                position <= 4'd0;
            else
                position <= position + 1;
        end
    end

endmodule

module pos_decoder_9bit(
    input clk,
    input [3:0] pos,
    output reg [8:0] led
);

    always @(posedge clk) begin
        case (pos)
            4'd0: led <= 9'b000000001;
            4'd1: led <= 9'b000000010;
            4'd2: led <= 9'b000000100;
            4'd3: led <= 9'b000001000;
            4'd4: led <= 9'b000010000;
            4'd5: led <= 9'b000100000;
            4'd6: led <= 9'b001000000;
            4'd7: led <= 9'b010000000;
            4'd8: led <= 9'b100000000;
            default: led <= 9'b000000000;
        endcase
    end
endmodule
