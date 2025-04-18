`timescale 1ns / 1ps

module test_disp(
    input [12:0] pixel_index,
    output reg [15:0] oled_data
    );
    
    always @ (*) begin
        oled_data = 16'hFFFF;
    end
    
endmodule
