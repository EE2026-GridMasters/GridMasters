`timescale 1ns / 1ps

module playerVSplayer(
    input clk,
    input btnC, btnReset,
    input reset_flag,
    input [8:0] sw,
    output reg [8:0] led,
    output [17:0] grid_state_disp,
    output reg turn, // 0 for X, 1 for O
    output reg [1:0] game_result
);
    
    reg [1:0] player_icon;  // 01 = X, 10 = O
    reg [8:0] confirmed_leds;
    reg [8:0] selected_led;
    wire [8:0] valid_sw = sw & ~confirmed_leds;
    
    reg [17:0] grid_state;
    wire [3:0] grid_box;
    wire is_win;
    
    // assign selected box 2'b11
    assign grid_state_disp = grid_state | ((selected_led != 0) ? 2'b11 << ((grid_box - 1) * 2) : 0);
    
    wire clk40Hz, clk10Hz, blink_10hz;
    custom_clock clk_5hz (clk, 2_500_000, clk40Hz); // Win led "running sequence"
    custom_clock clk_10hz (clk, 10_000_000, clk10Hz); // Draw "alt" blinking pattern
    custom_clock clk_20hz (clk, 5_000_000, blink_10hz); // User grid selection blink

    // led "running sequence"
    wire [3:0] position;
    wire [8:0] running_led;
    led_position win_pos (is_win, clk40Hz, position);
    pos_decoder_9bit win_decode (clk, position, running_led);
    
    // led "alt" blinking pattern
    reg blink_toggle = 0;
    wire [8:0] alt_blink_pattern = blink_toggle ? 9'b111100000 : 9'b000001111;
    always @(posedge clk10Hz) begin
        if (game_result == 2'b11)
            blink_toggle <= ~blink_toggle;
        else
            blink_toggle <= 0;
    end
    
    check_win win (clk, reset_flag, grid_state, is_win);
    
    // Decoder for selected_led to grid box number (1-9)
    assign grid_box = (selected_led == 9'b000000001) ? 1 :
                      (selected_led == 9'b000000010) ? 2 :
                      (selected_led == 9'b000000100) ? 3 :
                      (selected_led == 9'b000001000) ? 4 :
                      (selected_led == 9'b000010000) ? 5 :
                      (selected_led == 9'b000100000) ? 6 :
                      (selected_led == 9'b001000000) ? 7 :
                      (selected_led == 9'b010000000) ? 8 :
                      (selected_led == 9'b100000000) ? 9 : 0;

    initial begin
        player_icon = 2'b01; // Start with X
        confirmed_leds = 0;
        selected_led = 0;
        grid_state = 0;
        game_result = 0;
        turn = 0;
    end

    always @(posedge clk or posedge reset_flag) begin
        if (reset_flag || btnReset) begin
            led <= 0;
            player_icon <= 2'b01;
            confirmed_leds <= 0;
            selected_led <= 0;
            grid_state <= 0;
            game_result <= 0;
            turn <= 0;
        end else begin
            if (is_win) begin //There is a winner
                led <= running_led;
                game_result <= (player_icon == 2'b01) ? 2'b10: 2'b01;
                turn <= (player_icon == 2'b01) ? 0 : 1;
            end else if (confirmed_leds == 9'b111111111) begin //Draw
                led <= alt_blink_pattern;
                game_result <= 2'b11;
            end else begin //Player Input + confirmation
                if (btnC && selected_led != 0 && grid_box != 0) begin
                    confirmed_leds <= confirmed_leds | selected_led;
                    grid_state <= grid_state | (player_icon << ((grid_box - 1) * 2));
                    player_icon <= (player_icon == 2'b01) ? 2'b10 : 2'b01; //Switch Player
                    turn <= ~turn;
                    selected_led <= 0;
                end else begin
                    selected_led <= valid_sw;
                end
                
                // LED Display (confirmed + blinking selection)
                led <= confirmed_leds | (blink_10hz ? selected_led : 0);
            end
        end            
    end
endmodule