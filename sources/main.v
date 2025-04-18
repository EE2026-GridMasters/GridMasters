module ai_intigrated(input clk, input start, input [17:0] board, input [1:0] level , input btnC, output  [17:0] out_board, output [8:0] mv);
reg[3:0] move, random_move = 0;
wire [3:0] medium_move, max_move;
wire med_done, max_done;
 wire [8:0] o = { board[16], board[14], board[12], board[10],
                    board[8], board[6], board[4], board[2], board[0] };
   wire [8:0] x = { board[17], board[15], board[13], board[11],
                    board[9], board[7], board[5], board[3], board[1] };
ai_level_medium med(clk, board,start, medium_move, med_done);
ai_level_max max(clk, board,start, max_move, max_done);
assign mv = move;
reg [17:0] board2;

function [3:0] get_empty_move(input [8:0] board);
    begin
        
        if(!board[0]) get_empty_move = 0;
        else if(!board[3]) get_empty_move = 3;
        else if(!board[6]) get_empty_move = 6;
        else if(!board[1]) get_empty_move = 1;
        else if(!board[4]) get_empty_move = 4;
        else if(!board[7]) get_empty_move = 7;
        else if(!board[2]) get_empty_move = 2;
        else if(!board[5]) get_empty_move = 5;
        else if(!board[8]) get_empty_move = 8;
        else get_empty_move = 9;
    end
    endfunction
always@(posedge clk) begin
       begin
       if(random_move > 7)
                   random_move = 0;
               else random_move = random_move + 1;
            case(level) 
                0: move = random_move;
                1: move = medium_move;
                2,3:  move = max_move;
            endcase
        end
        if((x|o) == 0)
            move = 4;
        board2 = board | (2'b10 << (move * 2));
    end
    //assign out_board = board | (1 << (move * 2));
    assign out_board = board2;
    assign mv = move;
endmodule 

module ai_level_max (
    input clk,
    input [17:0] board,
    input think,
    output  [3:0] move,  
    output animate
);
    wire [8:0] o = { board[16], board[14], board[12], board[10],
                     board[8], board[6], board[4], board[2], board[0] };
    wire [8:0] x = { board[17], board[15], board[13], board[11],
                     board[9], board[7], board[5], board[3], board[1] };
    reg [1:0] state;
    localparam IDLE        = 2'd0,
               ANIMATE     = 2'd1,
               OUTPUT_MOVE = 2'd2;
    reg [31:0] counter;
    parameter TWO_SEC_COUNT = 200_000_000; 
    reg think_prev;
    wire [3:0] ai_move;
    ai_max max (
        .clk(clk),
        .x(x),
        .o(o),
        .Move(move)
    );
    assign animate = 1;
endmodule
module ai_level_medium (
    input clk,
    input [17:0] board,
    input think,
    output  [3:0] move,  
    output animate
);
    wire [8:0] o = { board[16], board[14], board[12], board[10],
                     board[8], board[6], board[4], board[2], board[0] };
    wire [8:0] x = { board[17], board[15], board[13], board[11],
                     board[9], board[7], board[5], board[3], board[1] };
    reg [1:0] state;
    localparam IDLE        = 2'd0,
               ANIMATE     = 2'd1,
               OUTPUT_MOVE = 2'd2;
    reg [31:0] counter;
    parameter TWO_SEC_COUNT = 200_000_000; 
    reg think_prev;
    wire [3:0] ai_move;
    ai_medium ai_inst (
        .clk(clk),
        .x(x),
        .o(o),
        .Move(move)
    );
    assign animate = 1;
endmodule
