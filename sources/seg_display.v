`timescale 1ns / 1ps

module scoreboard(input clk, reset, input [1:0] round_result, output reg [1:0] win_result = 0, reg [7:0] SEG, output reg [3:0] AN);

    parameter [7:0] symbol_o = 8'b10100011;
    parameter [7:0] symbol_x = 8'b10001001;

    wire clk500hz;
    custom_clock segment_clock (clk, 100000, clk500hz);

    reg round_done = 0;
    reg [1:0] x_score, o_score = 0;
    reg [1:0] prev_result;
    
    always @ (posedge clk) begin
        prev_result <= round_result;
        round_done <= (prev_result != round_result);
        
        if (reset) begin
            x_score <= 0;
            o_score <= 0;
        end else if (round_done) begin 
            if (round_result == 2'b01) // X win
                x_score <= x_score + 1;
            else if (round_result == 2'b10) // O win
                o_score <= o_score + 1;
            // draw/inactive, no change
        end
    end

    wire [7:0] x_score_seg, o_score_seg;
    
    decoder x_score_decode (clk, x_score, x_score_seg);
    decoder o_score_decode (clk, o_score, o_score_seg);

    reg [1:0] count = 0;

    always @ (posedge clk500hz) begin
        count <= count + 1;
        if (count == 0) begin
            SEG <= symbol_o;
            AN <= 4'b0111;
        end
        if (count == 1) begin
            SEG <= o_score_seg & 8'b01111111;
            AN <= 4'b1011;
        end
        if (count == 2) begin
            SEG <= symbol_x;
            AN <= 4'b1101;
        end
        if (count == 3) begin
            SEG <= x_score_seg;
            AN <= 4'b1110;
        end
    end

    // send overall win signal if either reaches 3
    always @ (posedge clk) begin
        if (x_score == 3) win_result <= 01;
        else if (o_score == 3) win_result <= 10;
        else win_result <= 00;
    end
    
endmodule

module timer(input clk, hold, reset, output reg [7:0] SEG, output reg [3:0] AN);
    reg [3:0] AN_blk = 4'b0000;

    wire clk500hz, clk2hz, clk1hz;
    custom_clock segment_clock (clk, 100000, clk500hz);
    custom_clock counter_clock (clk, 50000000, clk1hz);
    custom_clock blink_clock (clk, 25000000, clk2hz);
    
    wire [3:0] second, ten_second, minute, ten_minute;
    wire [7:0] digit1, digit2, digit3, digit4;
    count counter (clk1hz, hold, reset, second, ten_second, minute, ten_minute);
    
    decoder seconds (clk, second, digit1);
    decoder ten_seconds (clk, ten_second, digit2);
    decoder minutes (clk, minute, digit3);
    decoder ten_minutes (clk, ten_minute, digit4);
    
    reg [1:0] count = 0;
    
    always @ (posedge clk2hz) begin
        if (hold) AN_blk <= ~AN_blk;
        else AN_blk <= 4'b0000;
    end
    
    always @ (posedge clk500hz) begin
        count <= count + 1;
        if (count == 0) begin
            SEG <= digit4;
            AN <= 4'b0111 | AN_blk;
        end
        if (count == 1) begin
            SEG <= digit3 & 8'b01111111;
            AN <= 4'b1011 | AN_blk;
        end
        if (count == 2) begin
            SEG <= digit2;
            AN <= 4'b1101 | AN_blk;
        end
        if (count == 3) begin
            SEG <= digit1;
            AN <= 4'b1110 | AN_blk;
        end
    end

endmodule

module decoder(input clk, input [3:0] number, output reg [7:0] segment);

    always @ (posedge clk) begin
        if (number == 0)
            segment <= 8'b11000000;
        if (number == 1)
            segment <= 8'b11111001;
        if (number == 2)
            segment <= 8'b10100100;
        if (number == 3)
            segment <= 8'b10110000;
        if (number == 4)
            segment <= 8'b10011001;
        if (number == 5)
            segment <= 8'b10010010;
        if (number == 6)
            segment <= 8'b10000010;
        if (number == 7)
            segment <= 8'b11111000;
        if (number == 8)
            segment <= 8'b10000000;
        if (number == 9)
            segment <= 8'b10010000;
    end

endmodule

module count(input clk1hz, hold, reset,
        output reg [3:0] second = 0, ten_second = 0, minute = 0, ten_minute = 0);
    
    always @ (posedge clk1hz, posedge reset) begin
        second <= second == 9 ? 0 : second + 1;
        if (reset) begin
            second <= 0;
            ten_second <= 0;
            minute <= 0;
            ten_minute <= 0;
        end
        else if (hold) begin
            second <= second;
            ten_second <= ten_second;
            minute <= minute;
            ten_minute <= ten_minute;
        end
        else if (ten_minute == 9 && minute == 9 && 
                ten_second == 5 && second == 9) begin
            second <= 9;
            ten_second <= 5;
            minute <= 9;
            ten_minute <= 9;
        end
        else if (second == 9) begin
            ten_second <= ten_second == 5 ? 0 : ten_second + 1;
            if (ten_second == 5) begin
                minute <= minute == 9 ? 0 : minute + 1;
                if (minute == 9)
                    ten_minute <= ten_minute + 1;
            end
        end
    end

endmodule