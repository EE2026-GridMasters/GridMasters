`timescale 1ns / 1ps

module playerVSai(
    input clk,
    input btnC, btnReset,
    input reset_flag,
    input [1:0] ai_level,
    input [8:0] sw,
    output reg [8:0] led,
    output [17:0] grid_state_disp,
    output reg ai_waiting, // 0 for X, 1 for O
    output reg [1:0] game_result
);
    reg [1:0] player_icon;  // 01 = X, 10 = O
    reg [8:0] confirmed_leds;
    reg [8:0] selected_led;
    wire [8:0] valid_sw = sw & ~confirmed_leds;
       
    reg turn; 
    reg start_ai;
    reg [1:0] lvl = 0;
    reg [31:0] wait_count;  // Counts down from 2 -> 1 -> 0
    wire [8:0] mv;
    wire animate;

    reg [17:0] grid_state;
    wire [3:0] grid_box;
    wire [17:0] ai_grid_state;
    wire is_win;

    ai_intigrated(clk, start_ai, grid_state, ai_level, btnC, ai_grid_state, mv );
    check_win win (clk, reset_flag, grid_state, is_win);


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

    // Assign selected box 2'b11
    assign grid_state_disp = grid_state | ((selected_led != 0) ? 2'b11 << ((grid_box - 1) * 2) : 0);

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
        player_icon = 2'b10;  // Start with AI (O)
        confirmed_leds = 0;
        selected_led = 0;
        grid_state = 0;
        game_result = 0;
        turn = 1;
        ai_waiting = 200_000_000;
        start_ai = 0;
        wait_count = 0; 
    end

    always @(posedge clk or posedge reset_flag) begin
        if (reset_flag) begin
            led <= 0;
            player_icon <= 2'b10;
            confirmed_leds <= 0;
            selected_led <= 0;
            grid_state <= 0;
            game_result <= 0;
            turn <= 1;
            ai_waiting <= 0;
            start_ai <= 1;
            wait_count <= 0;
        end 
        else begin
            if (is_win) begin //There is a winner
                game_result <= (player_icon == 2'b01) ? 2'b10 : 2'b01;
                turn <= (player_icon == 2'b01) ? 1 : 0;
            end else if (confirmed_leds == 9'b111111111) begin //Draw
                game_result <= 2'b11;
            end else begin
                //If we are waiting to run AI, decrement wait_count
                if (ai_waiting) begin
                    // If wait_count has not hit zero, decrement
                    if (wait_count > 0) begin
                        wait_count <= wait_count - 1;
                        start_ai <= 0;
                    end
                    // Once wait_count == 0, start the AI
                    else begin
                        start_ai <= 1;
                    end
                end
                else begin
                    start_ai <= 0;
                end

                // Player's turn (X)
                if (player_icon == 2'b01) begin
                    if (btnC && selected_led != 0 && grid_box != 0) begin
                        confirmed_leds <= confirmed_leds | selected_led;
                        grid_state <= grid_state | (2'b01 << ((grid_box - 1) * 2));
                        turn <= ~turn;
                        player_icon <= 2'b10; //Switch AI's turn
                        selected_led <= 0;

                        // Trigger AI in two cycles
                        ai_waiting <= 1;
                        wait_count <= 200_000_000;
                    end 
                    else begin
                        // Update selection if no confirm yet
                        selected_led <= valid_sw;
                    end
                end

                // Actually run AI move once start_ai goes high
                else if (player_icon == 2'b10 && start_ai == 1) begin
                    // AI logic finishes in same cycle you signal start_ai
                    if(grid_state[mv * 2] | grid_state[mv* 2 + 1]) begin
                        ai_waiting <= 1;
                         wait_count <= 5;
                         start_ai <= 1;
                    end else begin
                    grid_state <= ai_grid_state;
                    confirmed_leds <= confirmed_leds | (1 << mv);
                    turn <= ~turn;

                    ai_waiting <= 0; 
                    player_icon <= 2'b01; // Switch player's turn
                    end
                end
            end
            
            // Final LED assignment
             if (game_result == 2'b01) begin
                  led <= running_led;  // Player wins
              end else if (game_result == 2'b10) begin
                  led <= {9{clk10Hz}};  // AI wins
              end else if (game_result == 2'b11) begin
                  led <= alt_blink_pattern;  // Draw
              end else begin
                  led <= confirmed_leds | (blink_10hz ? selected_led : 0); //Player selection + confirmation
              end                        
        end
    end
    assign animate = ai_waiting;
endmodule
