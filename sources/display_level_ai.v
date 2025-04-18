`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.04.2025 00:37:35
// Design Name: 
// Module Name: display_level_ai
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module display_level_ai (input clk, input [12:0] pixel_index_JB, input [1:0] level, input thinking, output [15:0] oled_data_JB);
    parameter basys3_clk_freq = 100_000_000;
    parameter frame_rate = 16;
    
    wire [31:0] clk_param;
    
    wire [15:0] oled1, oled2, oled3;
    assign oled_data_JB = oled1 | oled2 | oled3;
    
    wire clk_frameRate;
    
    reg reset = 0;
    
    assign clk_param = (basys3_clk_freq / (frame_rate)) - 1;
    

    flexible_clock_signal clkframeRate (clk, clk_param, clk_frameRate);

    
    combase_data combase (pixel_index_JB, oled1);
    comlvl_data comlvl (level, pixel_index_JB, oled2);
    comwait_data comwait (clk_frameRate, thinking, pixel_index_JB, oled3);
endmodule
