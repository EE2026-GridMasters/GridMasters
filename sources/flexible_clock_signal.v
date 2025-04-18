`timescale 1ns / 1ps

module flexible_clock_signal(input clk, input [31:0] number, output reg slw_clk = 0);

    reg [31:0] count = 0;
    always @ (posedge clk)begin
        count <= (count == number) ? 0 : count + 1;
        slw_clk <= (count == 0) ? ~slw_clk : slw_clk;
    end

endmodule
