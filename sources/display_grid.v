`timescale 1ns / 1ps

module display_grid(
    input [12:0] pixel_index,
    input [17:0] grid_data,
    output reg [15:0] oled_data
    );
    
    // colour constants
    parameter BG_BLUE_HEX = 16'b0000000001000100;
    parameter LINE_PURPLE_HEX = 16'h50DC;
    parameter O_PINK_HEX = 16'hF899;
    parameter X_BLUE_HEX = 16'h177F;
    parameter BLACK_HEX = 16'h0000;
    parameter WHITE_HEX = 16'hFFFF;
    parameter SELECTING_HEX = 16'h39EB;
    
    // dimension constants
    parameter LINE_THICKNESS = 3;
    parameter BOX_WIDTH = 30;
    parameter BOX_HEIGHT = 19;
    
    // position constants
    parameter X0 = 0, X1 = 33, X2 = 66;
    parameter Y0 = 0, Y1 = 22, Y2 = 44;
    
    // x and y coordinates for drawing
    wire [6:0] x;
    wire [5:0] y;
    pixel_to_coordinates update_x_y (pixel_index, x, y);
    
    wire [15:0] draw_Os_output;
    wire [15:0] draw_Xs_output;
    wire [15:0] display_selection_output;
    draw_Os dispOs (x, y, grid_data, O_PINK_HEX, draw_Os_output);
    draw_Xs dispXs (x, y, grid_data, X_BLUE_HEX, draw_Xs_output);
    display_selection dispSelection (x, y, grid_data, SELECTING_HEX, display_selection_output);

    always @ (*) begin
        // set background
        oled_data = BG_BLUE_HEX;
        
        // draw vertical lines
        if ((x >= X0 + BOX_WIDTH && x < X1) ||
            (x >= X1 + BOX_WIDTH && x < X2)) begin
            oled_data = LINE_PURPLE_HEX;
        end
        
        // draw horizontal lines
        if ((y >= Y0 + BOX_HEIGHT && y < Y1) ||
            (y >= Y1 + BOX_HEIGHT && y < Y2)) begin
            oled_data = LINE_PURPLE_HEX;
        end
        
        // draw Os
        if (draw_Os_output == O_PINK_HEX) begin
            oled_data = draw_Os_output;
        end
        
        // draw Xs
        if (draw_Xs_output == X_BLUE_HEX) begin
            oled_data = draw_Xs_output;
        end
        
        // indicate selecting box
        if (display_selection_output == SELECTING_HEX) begin
            oled_data = display_selection_output;
        end
        
    end
    
        
endmodule
