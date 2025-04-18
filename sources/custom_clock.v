`timescale 1ns / 1ps

module custom_clock (
    input clk,
    input [25:0] max_count,
    output reg slow_clk
);

    reg [25:0] count = 0;
    initial slow_clk = 0;
    
    always @ (posedge clk) begin
        count <= count + 1;
        if (count == max_count) begin
            slow_clk <= ~slow_clk;
            count <= 0;
        end
    end
endmodule
