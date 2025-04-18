`timescale 1ns / 1ps

module select_oled_data(
    input clk,
    input btnU, btnD,
    input [12:0] pixel_index,
    input [4:0] state,
    input turn_pvp,
    input waiting_ai,
    input [1:0] game_result_pvp,
    input [1:0] game_result_pvp_final,
    input [1:0] game_result_ai,
    input [1:0] level_ai,
    input [17:0] grid_data,
    output reg [15:0] selected_oled_data_top,
    output reg [15:0] selected_oled_data_bot
    );
    
    parameter HOME = 5'd0, MODE_SELECT_PVP = 5'd1, MODE_SELECT_AI = 5'd2, 
        PVP = 5'd3, PVP_RESULT = 5'd4, PVP_FINAL = 5'd7,
        AI = 5'd5, AI_RESULT = 5'd6; 
    
    wire [15:0] home_oled_data; // home page
    wire [15:0] start_oled_data; // click to start
    wire [15:0] select_pvp_oled_data; // mode selection pvp
    wire [15:0] select_ai_oled_data; // mode selection ai
    wire [15:0] grid_oled_data; // game grid
    wire [15:0] turn_oled_data; // turn indicator
    wire [15:0] level_oled_data;
    wire [15:0] winner_oled_data_pvp;
    wire [15:0] final_oled_data_pvp;
    wire [15:0] winner_oled_data_ai;
    
    wire [15:0] testing_oled_data;
    
    display_home_page home (pixel_index, home_oled_data);
    display_start start (pixel_index, start_oled_data);
    display_mode_select_pvp selecting_pvp (pixel_index, select_pvp_oled_data);
    display_mode_select_ai selecting_ai (pixel_index, select_ai_oled_data);
    display_grid game_grid (pixel_index, grid_data, grid_oled_data); 
    display_turn_pvp turn (pixel_index, turn_pvp, turn_oled_data);
    display_level_ai level (clk, pixel_index, level_ai, waiting_ai, level_oled_data);
    display_winner winnerpvp (clk, pixel_index, game_result_pvp, winner_oled_data_pvp);
    display_pvp_final finalpvp (clk, pixel_index, game_result_pvp_final, final_oled_data_pvp);
    display_ai_result winnerai (clk, pixel_index, game_result_ai, winner_oled_data_ai);

    test_disp testing (pixel_index, testing_oled_data);
            
    always @ (*) begin 
        if (state == HOME) begin
            selected_oled_data_top <= home_oled_data;
            selected_oled_data_bot <= start_oled_data;
            
        end else if (state == MODE_SELECT_PVP) begin
            selected_oled_data_top <= home_oled_data;
            selected_oled_data_bot <= select_pvp_oled_data;  
                  
        end else if (state == MODE_SELECT_AI) begin
            selected_oled_data_top <= home_oled_data;
            selected_oled_data_bot <= select_ai_oled_data; 
            
        end else if (state == PVP) begin
            selected_oled_data_top <= turn_oled_data;
            selected_oled_data_bot <= grid_oled_data;
            
        end else if (state == PVP_RESULT) begin
            selected_oled_data_top <= winner_oled_data_pvp;
            selected_oled_data_bot <= grid_oled_data;
        
        end else if (state == PVP_FINAL) begin
            selected_oled_data_top <= final_oled_data_pvp;
            selected_oled_data_bot <= grid_oled_data;
        
        end else if (state == AI) begin
            selected_oled_data_top <= level_oled_data;
            selected_oled_data_bot <= grid_oled_data;  
            
        end else if (state == AI_RESULT) begin
            selected_oled_data_top <= winner_oled_data_ai;
            selected_oled_data_bot <= grid_oled_data;
            
        end else begin
        end
    end
endmodule
