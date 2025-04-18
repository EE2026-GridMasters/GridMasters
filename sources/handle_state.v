`timescale 1ns / 1ps

module handle_screen_state (
    input clk,
    input btnC, btnU, btnD, btnL, btnR,
    input [8:0] sw,
    input [1:0] pvp_game_status,
    input [1:0] pvp_game_status_final,
    input [1:0] ai_game_status,
    output reg [1:0] level_ai,
    output reg grid_reset_flag,
    output reg general_reset,
    output reg [4:0] state
    );
    
    parameter HOME = 5'd0, MODE_SELECT_PVP = 5'd1, MODE_SELECT_AI = 5'd2, 
        PVP = 5'd3, PVP_RESULT = 5'd4, PVP_FINAL = 5'd7,
        AI = 5'd5, AI_RESULT = 5'd6;    
    initial begin
        state = HOME;
        grid_reset_flag = 0;
    end
    
    wire deb_btnC, deb_btnU, deb_btnD, deb_btnL, deb_btnR;
    
    debouncer debounce_C (clk, btnC, deb_btnC);
    debouncer debounce_U (clk, btnU, deb_btnU);
    debouncer debounce_D (clk, btnD, deb_btnD);
    debouncer debounce_L (clk, btnL, deb_btnL);
    debouncer debounce_R (clk, btnR, deb_btnR);
    
    reg [30:0] count = 0; // counter for timing
    
    always @ (posedge clk) begin
        if (state == HOME) begin
            general_reset <= 1;
            state <= ((deb_btnC) && sw == 0) ? MODE_SELECT_PVP : HOME;
                grid_reset_flag <= 1; 
                level_ai <= 0;
            
        end else if (state == MODE_SELECT_PVP) begin
            general_reset <= 1;
            state <= (deb_btnC && sw == 0) ? PVP : // 1v1 mode selected
                (deb_btnL) ? HOME : // back to home page
                (deb_btnD) ? MODE_SELECT_AI : MODE_SELECT_PVP;
            grid_reset_flag <= 1;                
            
        end else if (state == MODE_SELECT_AI) begin
            general_reset <= 1;
            state <= (deb_btnC  && sw == 0) ? AI : // ai mode selected
                (deb_btnL) ? HOME : // back to home page
                (deb_btnU) ? MODE_SELECT_PVP : MODE_SELECT_AI;
            grid_reset_flag <= 1;                
                   
        end else if (state == PVP) begin
            general_reset <= 0;
            state <= (deb_btnL) ? MODE_SELECT_PVP : // back to selection page
                (pvp_game_status == 2'b00) ? PVP : PVP_RESULT; // show results if game is over
            grid_reset_flag <= 0;
            
        end else if (state == PVP_RESULT) begin
            general_reset <= 0;
            if (pvp_game_status_final != 00) state <= PVP_FINAL;
            else begin
            // show result for ~5 sec
                if (count == 500_000_000) begin
                    count <= 0;
                    state <= PVP;
                    grid_reset_flag <= 1;
                end else begin
                    count <= count + 1;
                end
            end
        
        end else if (state == PVP_FINAL) begin
            general_reset <= 0;
            // 10 seconds counter -- will stay in this state for 10s
            if (count == 1_000_000_000) begin
                count <= 0;
                state <= MODE_SELECT_PVP; // back to selection page
                grid_reset_flag <= 1;
            end else begin
                count <= count + 1;
            end
        
        end else if (state == AI) begin
            general_reset <= 0;
            state <= (deb_btnL) ? MODE_SELECT_AI : // back to selection page
                (ai_game_status == 2'b00) ? AI : AI_RESULT; // show results if game is over
            grid_reset_flag <= 0;
            
        end else if (state == AI_RESULT) begin
            general_reset <= 0;
            // 10 seconds counter -- will stay in this state for 10s
            if (count == 1_000_000_000) begin
                count <= 0;
                grid_reset_flag <= 1;
                if (ai_game_status == 2'b01) begin // win --> progress level
                    if (level_ai == 2'b10) begin // beat level 3 --> back to selection page
                        level_ai <= 0;
                        state <= MODE_SELECT_AI;
                    end else begin
                        level_ai <= level_ai + 1;
                        state <= AI;
                    end
                end else if (ai_game_status == 2'b10) begin // lose --> to level 1
                    level_ai <= 0;
                    state <= AI; // back to grid
                end else if (ai_game_status == 2'b11) begin // draw --> stay at level
                    level_ai <= level_ai;
                    state <= AI; // back to grid
                end
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule
