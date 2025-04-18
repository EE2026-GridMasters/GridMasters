`timescale 1ns / 1ps

module Top_Module (
    input clk,
    input [8:0] sw, 
    input btnC, btnU, btnD, btnL, btnR,
    output reg [15:0] led, reg [7:0] seg, reg [3:0] an, 
    output [7:0] JX, [7:0] JB
    );

    // OLED outputs
    wire frame_begin_top, frame_begin_bot; 
    wire [12:0] pixel_index_top, pixel_index_bot;
    wire sending_pixels_top, sending_pixels_bot;
    wire sample_pixel_top, sample_pixel_bot;
    reg [15:0] oled_data_top, oled_data_bot;
    
    // instantiate 6.25MHz clock for OLED
    wire clk6p25m;
    custom_clock oled_clk (clk, 7, clk6p25m);
    
    // instantiate OLED displays
    Oled_Display top_oled_inst (
            .clk(clk6p25m),
            .reset(0),
            .frame_begin(frame_begin_top),
            .sending_pixels(sending_pixels_top),
            .sample_pixel(sample_pixel_top),
            .pixel_index(pixel_index_top),
            .pixel_data(oled_data_top),
            .cs(JB[0]),
            .sdin(JB[1]),
            .sclk(JB[3]),
            .d_cn(JB[4]),
            .resn(JB[5]),
            .vccen(JB[6]),
            .pmoden(JB[7])
    );    
    Oled_Display bot_oled_inst (
            .clk(clk6p25m),
            .reset(0),
            .frame_begin(frame_begin_bot),
            .sending_pixels(sending_pixels_bot),
            .sample_pixel(sample_pixel_bot),
            .pixel_index(pixel_index_bot),
            .pixel_data(oled_data_bot),
            .cs(JX[0]),
            .sdin(JX[1]),
            .sclk(JX[3]),
            .d_cn(JX[4]),
            .resn(JX[5]),
            .vccen(JX[6]),
            .pmoden(JX[7])
    );
    wire grid_reset_flag;
    wire [8:0] led_pvp, led_ai;
    wire [3:0] an_pvp, an_ai;
    wire [7:0] seg_pvp, seg_ai;
    wire [17:0] grid_state_pvp, grid_state_ai;
    wire turn_pvp;
    wire [1:0] game_status_pvp;
    wire [1:0] game_status_pvp_final;
    wire [1:0] game_status_ai;
    
    wire [1:0] ai_level;
    wire ai_waiting;
    
    wire general_reset;
        
    playerVSplayer pVpInput (clk, btnC, btnR, grid_reset_flag, sw, led_pvp, grid_state_pvp, turn_pvp, game_status_pvp);
    playerVSai pVaiInput (clk, btnC, btnR, grid_reset_flag, ai_level, sw, led_ai, grid_state_ai, ai_waiting, game_status_ai);
            
    reg [17:0] grid_state; // tictactoe board state
    reg turn;
    wire [4:0] screen_state; // oled display state
    handle_screen_state update_screen_state (clk, btnC, btnU, btnD, btnL, btnR, sw[8:0], game_status_pvp, game_status_pvp_final, game_status_ai, ai_level, grid_reset_flag, general_reset, screen_state);  
    
    wire [15:0] selected_oled_data_top;
    wire [15:0] selected_oled_data_bot;
    select_oled_data oled (clk, btnU, btnD, pixel_index_top, screen_state, turn, ai_waiting, game_status_pvp, game_status_pvp_final, game_status_ai, ai_level, grid_state, selected_oled_data_top, selected_oled_data_bot);
    
    scoreboard pvp_score (clk, general_reset, game_status_pvp, game_status_pvp_final, seg_pvp, an_pvp);
    
    reg ai_round_done, ai_timer_hold, ai_timer_reset = 0;
    timer ai_timer (clk, ai_timer_hold, ai_timer_reset, seg_ai, an_ai);
    
    reg [1:0] ai_prev_result;
    
    always @ (posedge clk) begin
        ai_prev_result <= game_status_ai;
        ai_round_done <= (ai_prev_result != game_status_ai);
        
        if (general_reset || grid_reset_flag) ai_timer_reset <= 1;
        else ai_timer_reset <= 0;
        
        if (game_status_ai != 2'b00) ai_timer_hold = 1;
        else ai_timer_hold <= 0; 
    end
        
        // state constants
        parameter HOME = 5'd0, MODE_SELECT_PVP = 5'd1, MODE_SELECT_AI = 5'd2, 
            PVP = 5'd3, PVP_RESULT = 5'd4, PVP_FINAL = 5'd7,
            AI = 5'd5, AI_RESULT = 5'd6;
            
        always @ (*) begin        
            if (screen_state == PVP || screen_state == PVP_RESULT || screen_state == PVP_FINAL) begin
                led[8:0] = led_pvp;
                an = an_pvp;
                seg = seg_pvp;
                grid_state = grid_state_pvp;
                turn = turn_pvp;
                
            end else if (screen_state == AI || screen_state == AI_RESULT) begin
                led[8:0] = led_ai;
                an = an_ai;
                seg = seg_ai;
                grid_state = grid_state_ai;
                
            end else begin
                an = 4'b1111;
                led[8:0] = 0;
            end   
        
            oled_data_top = selected_oled_data_top;        
            oled_data_bot = selected_oled_data_bot;
        end
        
    endmodule