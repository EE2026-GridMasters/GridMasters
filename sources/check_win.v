`timescale 1ns / 1ps

module check_win(
    input clk,
    input reset_flag,
    input [17:0] grid_state,
    output reg is_win
    );
    
    always @ (posedge clk, posedge reset_flag) begin
    
        if (reset_flag) is_win <= 0;
        
        else begin
            //check col win
            if ((grid_state[17:16] == grid_state[11:10] && grid_state[11:10] == grid_state[5:4] && grid_state[17:16] != 0) ||
                (grid_state[15:14] == grid_state[9:8] && grid_state[9:8] == grid_state[3:2] && grid_state[15:14] != 0) ||
                (grid_state[13:12] == grid_state[7:6] && grid_state[7:6] == grid_state[1:0] && grid_state[13:12] != 0)) begin
                is_win <= 1;
            end
            
            //check row win
            else if ((grid_state[17:16] == grid_state[15:14] && grid_state[15:14] == grid_state[13:12] && grid_state[17:16] != 0) ||
                     (grid_state[11:10] == grid_state[9:8] && grid_state[9:8] == grid_state[7:6] && grid_state[11:10] != 0) ||
                     (grid_state[5:4] == grid_state[3:2] && grid_state[3:2] == grid_state[1:0] && grid_state[5:4] != 0)) begin
                is_win <= 1;
            end
            
            //check diagonal win
            else if ((grid_state[17:16] == grid_state[9:8] && grid_state[9:8] == grid_state[1:0] && grid_state[17:16] != 0) ||
                     (grid_state[13:12] == grid_state[9:8] && grid_state[9:8] == grid_state[5:4] && grid_state[13:12] != 0)) begin
                is_win <= 1;
            end
            else begin is_win <= 0; end 
        end     
    end        
endmodule
