`timescale 1ns / 1ps

module pixel_to_coordinates(
    input [15:0] pixel_index,
    output [6:0] x, // X coordinate (0-95 for 96 columns)
    output [5:0] y // Y coordinate (0-63 for 64 rows)
);
    
    parameter OLED_WIDTH = 96;
    parameter OLED_HEIGHT = 64;
    
    assign x = pixel_index % OLED_WIDTH;
    assign y = pixel_index / OLED_WIDTH;
    
endmodule
