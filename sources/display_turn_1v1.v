`timescale 1ns / 1ps

//module display_turn_pvp(
//    input [12:0] pixel_index,
//    input turn, // 0 for "X", 1 for "O"
//    output [15:0] oled_data
//    );
    
//    wire [15:0] disp_turn_X, disp_turn_O;
//    display_turn_X x (pixel_index, disp_turn_X);
//    display_turn_O o (pixel_index, disp_turn_O);
//    assign oled_data = (turn == 0) ? disp_turn_X : disp_turn_O;
    
//endmodule

module display_turn_pvp(input [12:0] pixel_index_JB, input sw, output [15:0] oled_data_JB);
    wire [7:0] JB;

    wire [15:0] oled1, oled2;
    assign oled_data_JB = oled1 | oled2;
    
    vsbase_data vsbase (pixel_index_JB, oled1);
    vsturn_data vsturn (sw, pixel_index_JB, oled2);
endmodule

//module display_turn_X(
//    input [12:0] pixel_index,
//    output reg [15:0] oled_data
//    );
//    parameter BG_BLUE_HEX = 16'h0006;
//    parameter X_BLUE_HEX = 16'h177F;

//    // x and y coordinates for drawing
//    wire [6:0] x;
//    wire [5:0] y;
//    pixel_to_coordinates update_x_y (pixel_index, x, y);
//    wire signed [15:0] signed_x = x - 48;
//    wire signed [15:0] signed_y = y - 32;
    
//    parameter X_THICKNESS = 5, X_HEIGHT = 25;   
//    always @ (*) begin
//        oled_data = BG_BLUE_HEX;

//        if (signed_x <= X_HEIGHT && signed_x >= - X_HEIGHT &&
//            signed_y <= X_HEIGHT && signed_y >= - X_HEIGHT &&
//            (((signed_x - signed_y) <= X_THICKNESS && (signed_x - signed_y) >= - X_THICKNESS) ||
//            ((signed_x + signed_y) <= X_THICKNESS && (signed_x + signed_y) >= - X_THICKNESS))) begin
//            oled_data = X_BLUE_HEX;
//        end     
//    end 
    
//endmodule

//module display_turn_O(
//    input [12:0] pixel_index,
//    output reg [15:0] oled_data
//    );
//    parameter BG_BLUE_HEX = 16'h0006;
//    parameter O_PINK_HEX = 16'hF899;

//    // x and y coordinates for drawing
//    wire [6:0] x;
//    wire [5:0] y;
//    pixel_to_coordinates update_x_y (pixel_index, x, y);
//    wire signed [15:0] signed_x = x - 48;
//    wire signed [15:0] signed_y = y - 32;
//    wire [15:0] dist_sq = signed_x * signed_x + signed_y * signed_y;
    
//    parameter OUTER_D = 50, INNER_D = 40;
//    parameter OUTER_SQ = (OUTER_D / 2) * (OUTER_D / 2);
//    parameter INNER_SQ = (INNER_D / 2) * (INNER_D / 2);
    
//    always @ (*) begin
//        oled_data = BG_BLUE_HEX;
       
//        if ((dist_sq >= INNER_SQ) && (dist_sq <= OUTER_SQ)) begin
//            oled_data = O_PINK_HEX;
//        end    
//    end
    
//endmodule

