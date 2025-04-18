`timescale 1ns / 1ps

module display_selection (
    input [6:0] x,      // X coordinate for drawing
    input [5:0] y,     // Y coordinate for drawing
    input [17:0] grid_data,
    input [15:0] color_hex,
    output reg [15:0] oled_data
    );

    // dimension constants
    parameter BOX_WIDTH = 30;
    parameter BOX_HEIGHT = 19;    
    // position constants
    parameter X0 = 0, X1 = 33, X2 = 66;
    parameter Y0 = 0, Y1 = 22, Y2 = 44;
        
    always @ (*) begin
    oled_data = 16'h0000; // Default to black

        if (grid_data[1:0] == 2'b11) begin
            if (x >= X0 && x < X0 + BOX_WIDTH &&
                y >= Y0 && y < Y0 + BOX_HEIGHT) begin
                oled_data = color_hex;
            end
        end
        if (grid_data[3:2] == 2'b11) begin
            if (x >= X1 && x < X1 + BOX_WIDTH &&
                y >= Y0 && y < Y0 + BOX_HEIGHT) begin
                oled_data = color_hex;
            end
        end
        if (grid_data[5:4] == 2'b11) begin
            if (x >= X2 && x < X2 + BOX_WIDTH &&
                y >= Y0 && y < Y0 + BOX_HEIGHT) begin
                oled_data = color_hex;
            end
        end
        if (grid_data[7:6] == 2'b11) begin
            if (x >= X0 && x < X0 + BOX_WIDTH &&
                y >= Y1 && y < Y1 + BOX_HEIGHT) begin
                oled_data = color_hex;
            end
        end
         if (grid_data[9:8] == 2'b11) begin
            if (x >= X1 && x < X1 + BOX_WIDTH &&
                y >= Y1 && y < Y1 + BOX_HEIGHT) begin
                oled_data = color_hex;
            end
        end
        if (grid_data[11:10] == 2'b11) begin
            if (x >= X2 && x < X2 + BOX_WIDTH &&
                y >= Y1 && y < Y1 + BOX_HEIGHT) begin
                oled_data = color_hex;
            end
        end       
        if (grid_data[13:12] == 2'b11) begin
            if (x >= X0 && x < X0 + BOX_WIDTH &&
                y >= Y2 && y < Y2 + BOX_HEIGHT) begin
                oled_data = color_hex;
            end
        end
        if (grid_data[15:14] == 2'b11) begin
            if (x >= X1 && x < X1 + BOX_WIDTH &&
                y >= Y2 && y < Y2 + BOX_HEIGHT) begin
                oled_data = color_hex;
            end
        end
        if (grid_data[17:16] == 2'b11) begin
            if (x >= X2 && x < X2 + BOX_WIDTH &&
                y >= Y2 && y < Y2 + BOX_HEIGHT) begin
                oled_data = color_hex;
            end
        end 
    end
    
endmodule
