`timescale 1ns / 1ps

module draw_Xs(
    input [6:0] x,      // X coordinate for drawing
    input [5:0] y,     // Y coordinate for drawing
    input [17:0] grid_data,
    input [15:0] color_hex,
    output reg [15:0] oled_data
    );
    
    parameter BOX0_X = 15, BOX0_Y = 9;
    parameter BOX1_X = 48, BOX1_Y = 9;
    parameter BOX2_X = 81, BOX2_Y = 9;
    
    parameter BOX3_X = 15, BOX3_Y = 31; 
    parameter BOX4_X = 48, BOX4_Y = 31;
    parameter BOX5_X = 81, BOX5_Y = 31;
    
    parameter BOX6_X = 15, BOX6_Y = 53;
    parameter BOX7_X = 48, BOX7_Y = 53;
    parameter BOX8_X = 81, BOX8_Y = 53;
    
    parameter X_THICKNESS = 2, X_HEIGHT = 6;   
    
    reg signed [15:0] signed_x;
    reg signed [15:0] signed_y;
           
    always @ (*) begin
        oled_data = 16'h0000; // Default to black
              
        // box 0
        if (grid_data[1:0] == 2'b01) begin
            signed_x = x - BOX0_X;
            signed_y = y - BOX0_Y; 
            
            if (signed_x <= X_HEIGHT && signed_x >= - X_HEIGHT &&
                signed_y <= X_HEIGHT && signed_y >= - X_HEIGHT &&
                (((signed_x - signed_y) <= X_THICKNESS && (signed_x - signed_y) >= - X_THICKNESS) ||
                ((signed_x + signed_y) <= X_THICKNESS && (signed_x + signed_y) >= - X_THICKNESS))) begin
                oled_data = color_hex;
            end           
        end
        // box 1
        if (grid_data[3:2] == 2'b01) begin
            signed_x = x - BOX1_X;
            signed_y = y - BOX1_Y;
            
            if (signed_x <= X_HEIGHT && signed_x >= - X_HEIGHT &&
                signed_y <= X_HEIGHT && signed_y >= - X_HEIGHT &&
                (((signed_x - signed_y) <= X_THICKNESS && (signed_x - signed_y) >= - X_THICKNESS) ||
                ((signed_x + signed_y) <= X_THICKNESS && (signed_x + signed_y) >= - X_THICKNESS))) begin
                oled_data = color_hex;
            end              
                                
        end 
        // box 2
        if (grid_data[5:4] == 2'b01) begin
            signed_x = x - BOX2_X;
            signed_y = y - BOX2_Y;  
                      
            if (signed_x <= X_HEIGHT && signed_x >= - X_HEIGHT &&
                signed_y <= X_HEIGHT && signed_y >= - X_HEIGHT &&
                (((signed_x - signed_y) <= X_THICKNESS && (signed_x - signed_y) >= - X_THICKNESS) ||
                ((signed_x + signed_y) <= X_THICKNESS && (signed_x + signed_y) >= - X_THICKNESS))) begin
                oled_data = color_hex;
            end
              
        end
        // box 3
        if (grid_data[7:6] == 2'b01) begin
            signed_x = x - BOX3_X;
            signed_y = y - BOX3_Y;   
                     
            if (signed_x <= X_HEIGHT && signed_x >= - X_HEIGHT &&
                signed_y <= X_HEIGHT && signed_y >= - X_HEIGHT &&
                (((signed_x - signed_y) <= X_THICKNESS && (signed_x - signed_y) >= - X_THICKNESS) ||
                ((signed_x + signed_y) <= X_THICKNESS && (signed_x + signed_y) >= - X_THICKNESS))) begin
                oled_data = color_hex;
            end
        end
        // box 4
        if (grid_data[9:8] == 2'b01) begin
            signed_x = x - BOX4_X;
            signed_y = y - BOX4_Y;   
                     
            if (signed_x <= X_HEIGHT && signed_x >= - X_HEIGHT &&
                signed_y <= X_HEIGHT && signed_y >= - X_HEIGHT &&
                (((signed_x - signed_y) <= X_THICKNESS && (signed_x - signed_y) >= - X_THICKNESS) ||
                ((signed_x + signed_y) <= X_THICKNESS && (signed_x + signed_y) >= - X_THICKNESS))) begin
                oled_data = color_hex;
            end        
        end 
        // box 5
        if (grid_data[11:10] == 2'b01) begin
            signed_x = x - BOX5_X;
            signed_y = y - BOX5_Y;
                        
            if (signed_x <= X_HEIGHT && signed_x >= - X_HEIGHT &&
                signed_y <= X_HEIGHT && signed_y >= - X_HEIGHT &&
                (((signed_x - signed_y) <= X_THICKNESS && (signed_x - signed_y) >= - X_THICKNESS) ||
                ((signed_x + signed_y) <= X_THICKNESS && (signed_x + signed_y) >= - X_THICKNESS))) begin
                oled_data = color_hex;
            end           
        end 
        // box 6
        if (grid_data[13:12] == 2'b01) begin
            signed_x = x - BOX6_X;
            signed_y = y - BOX6_Y;
                        
            if (signed_x <= X_HEIGHT && signed_x >= - X_HEIGHT &&
                signed_y <= X_HEIGHT && signed_y >= - X_HEIGHT &&
                (((signed_x - signed_y) <= X_THICKNESS && (signed_x - signed_y) >= - X_THICKNESS) ||
                ((signed_x + signed_y) <= X_THICKNESS && (signed_x + signed_y) >= - X_THICKNESS))) begin
                oled_data = color_hex;
            end            
        end 
         // box 7
        if (grid_data[15:14] == 2'b01) begin
            signed_x = x - BOX7_X;
            signed_y = y - BOX7_Y;
                        
            if (signed_x <= X_HEIGHT && signed_x >= - X_HEIGHT &&
                signed_y <= X_HEIGHT && signed_y >= - X_HEIGHT &&
                (((signed_x - signed_y) <= X_THICKNESS && (signed_x - signed_y) >= - X_THICKNESS) ||
                ((signed_x + signed_y) <= X_THICKNESS && (signed_x + signed_y) >= - X_THICKNESS))) begin
                oled_data = color_hex;
            end           
        end                   
        // box 8
        if (grid_data[17:16] == 2'b01) begin
            signed_x = x - BOX8_X;
            signed_y = y - BOX8_Y;
            
            if (signed_x <= X_HEIGHT && signed_x >= - X_HEIGHT &&
                signed_y <= X_HEIGHT && signed_y >= - X_HEIGHT &&
                (((signed_x - signed_y) <= X_THICKNESS && (signed_x - signed_y) >= - X_THICKNESS) ||
                ((signed_x + signed_y) <= X_THICKNESS && (signed_x + signed_y) >= - X_THICKNESS))) begin
                oled_data = color_hex;
            end        
        end                         
    end
    
endmodule