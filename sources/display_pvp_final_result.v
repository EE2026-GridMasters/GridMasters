`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.04.2025 01:00:53
// Design Name: 
// Module Name: display_pvp_final_result
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


module display_pvp_final (input clk, input [12:0] pixel_index_JB, input [1:0] result, output [15:0] oled_data_JB);
    parameter clock_speed = 100_000_000;
    parameter frame_rate = 6;
    
    wire [31:0] frame_clk_number = clock_speed / (2 * frame_rate);
    
    wire [7:0] JB;
    
    wire done1, done2;
    reg start1, start2 = 0;

    wire [15:0] oled1, oled2, oled_anim1, oled_anim2;
    wire [15:0] oled_result = (done1 || done2) ? (oled1 | oled2) : 0;
    assign oled_data_JB = oled_result | oled_anim1 | oled_anim2;
    
    wire frame_clk;
    flexible_clock_signal frame_rate_clk (clk, frame_clk_number, frame_clk);
    
    reg winner; // 0 for X, 1 for O
    
    gameoverbase_data gameoverbase (pixel_index_JB, oled1);
    gameoverresult_data gameoverresult (winner, pixel_index_JB, oled2);
    
    x_win_anim x_win (frame_clk, start1, pixel_index_JB, done1, oled_anim1);
    o_win_anim o_win (frame_clk, start2, pixel_index_JB, done2, oled_anim2);
    
    always @ (posedge clk) begin
        if (result == 2'b00) begin
            start1 <= 0;
            start2 <= 0;
        end
        else if (result == 2'b01) begin // X win
            start1 <= 1;
            winner <= 0;
        end
        else if (result == 2'b10) begin // X win
            start2 <= 1;
            winner <= 1;
        end
    end
    
endmodule
