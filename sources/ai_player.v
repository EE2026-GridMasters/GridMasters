module ai_max(input clk, input [8:0] x, input [8:0] o, output [3:0] Move);
    reg [3:0] temp1, move;
    
    function [3:0] n_moves(input [8:0] x, input [8:0] o);
    begin
        n_moves = (x[0]+x[1]+x[2]+x[3]+x[4]+x[5]+x[6]+x[7]+x[8])+(o[0]+o[1]+o[2]+o[3]+o[4]+o[5]+o[6]+o[7]+o[8]);
    end
    endfunction

    function [3:0] get_empty_move(input [8:0] board);
    begin
        if(!board[0]) get_empty_move = 0;
        else if(!board[1]) get_empty_move = 1;
        else if(!board[2]) get_empty_move = 2;
        else if(!board[3]) get_empty_move = 3;
        else if(!board[4]) get_empty_move = 4;
        else if(!board[5]) get_empty_move = 5;
        else if(!board[6]) get_empty_move = 6;
        else if(!board[7]) get_empty_move = 7;
        else if(!board[8]) get_empty_move = 8;
        else get_empty_move = 9;
    end
    endfunction

    function [3:0] get_winning_move(input [8:0] o, input [8:0] x);
    begin
        if(!x[0] && !o[0] && x[1] && x[2]) get_winning_move = 0;
        else if(!x[1] && !o[1] && x[0] && x[2]) get_winning_move = 1;
        else if(!x[2] && !o[2] && x[0] && x[1]) get_winning_move = 2;
        else if(!x[3] && !o[3] && x[4] && x[5]) get_winning_move = 3;
        else if(!x[4] && !o[4] && x[3] && x[5]) get_winning_move = 4;
        else if(!x[5] && !o[5] && x[3] && x[4]) get_winning_move = 5;
        else if(!x[6] && !o[6] && x[7] && x[8]) get_winning_move = 6;
        else if(!x[7] && !o[7] && x[6] && x[8]) get_winning_move = 7;
        else if(!x[8] && !o[8] && x[6] && x[7]) get_winning_move = 8;
        else if(!x[0] && !o[0] && x[3] && x[6]) get_winning_move = 0;
        else if(!x[3] && !o[3] && x[0] && x[6]) get_winning_move = 3;
        else if(!x[6] && !o[6] && x[0] && x[3]) get_winning_move = 6;
        else if(!x[1] && !o[1] && x[4] && x[7]) get_winning_move = 1;
        else if(!x[4] && !o[4] && x[1] && x[7]) get_winning_move = 4;
        else if(!x[7] && !o[7] && x[1] && x[4]) get_winning_move = 7;
        else if(!x[2] && !o[2] && x[5] && x[8]) get_winning_move = 2;
        else if(!x[5] && !o[5] && x[2] && x[8]) get_winning_move = 5;
        else if(!x[8] && !o[8] && x[2] && x[5]) get_winning_move = 8;
        else if(!x[0] && !o[0] && x[4] && x[8]) get_winning_move = 0;
        else if(!x[4] && !o[4] && x[0] && x[8]) get_winning_move = 4;
        else if(!x[8] && !o[8] && x[0] && x[4]) get_winning_move = 8;
        else if(!x[2] && !o[2] && x[4] && x[6]) get_winning_move = 2;
        else if(!x[4] && !o[4] && x[2] && x[6]) get_winning_move = 4;
        else if(!x[6] && !o[6] && x[2] && x[4]) get_winning_move = 6;
        else get_winning_move = 9;
    end
    endfunction

    function [3:0] create_fork(input [8:0] o, input [8:0] x);
        reg [3:0] i, fork_count;
        reg [3:0] candidate;
        reg [3:0] sim_x, sim_o;
        begin
            candidate = 9;
            for(i = 0; i < 9; i = i + 1) begin
                if(!o[i] && !x[i]) begin
                    fork_count = 0;
                    if(i < 3) begin
                        sim_x = ((i==0 ? 1 : x[0]) + (i==1 ? 1 : x[1]) + (i==2 ? 1 : x[2]));
                        sim_o = (o[0] + o[1] + o[2]);
                        if((sim_x == 2) && (sim_o == 0))
                            fork_count = fork_count + 1;
                    end else if(i < 6) begin
                        sim_x = ((i==3 ? 1 : x[3]) + (i==4 ? 1 : x[4]) + (i==5 ? 1 : x[5]));
                        sim_o = (o[3] + o[4] + o[5]);
                        if((sim_x == 2) && (sim_o == 0))
                            fork_count = fork_count + 1;
                    end else begin
                        sim_x = ((i==6 ? 1 : x[6]) + (i==7 ? 1 : x[7]) + (i==8 ? 1 : x[8]));
                        sim_o = (o[6] + o[7] + o[8]);
                        if((sim_x == 2) && (sim_o == 0))
                            fork_count = fork_count + 1;
                    end
                    if(i % 3 == 0) begin
                        sim_x = ((i==0 ? 1 : x[0]) + (i==3 ? 1 : x[3]) + (i==6 ? 1 : x[6]));
                        sim_o = (o[0] + o[3] + o[6]);
                        if((sim_x == 2) && (sim_o == 0))
                            fork_count = fork_count + 1;
                    end else if(i % 3 == 1) begin
                        sim_x = ((i==1 ? 1 : x[1]) + (i==4 ? 1 : x[4]) + (i==7 ? 1 : x[7]));
                        sim_o = (o[1] + o[4] + o[7]);
                        if((sim_x == 2) && (sim_o == 0))
                            fork_count = fork_count + 1;
                    end else if(i % 3 == 2) begin
                        sim_x = ((i==2 ? 1 : x[2]) + (i==5 ? 1 : x[5]) + (i==8 ? 1 : x[8]));
                        sim_o = (o[2] + o[5] + o[8]);
                        if((sim_x == 2) && (sim_o == 0))
                            fork_count = fork_count + 1;
                    end
                    if((i == 0) || (i == 4) || (i == 8)) begin
                        sim_x = ((i==0 ? 1 : x[0]) + (i==4 ? 1 : x[4]) + (i==8 ? 1 : x[8]));
                        sim_o = (o[0] + o[4] + o[8]);
                        if((sim_x == 2) && (sim_o == 0))
                            fork_count = fork_count + 1;
                    end
                    if((i == 2) || (i == 4) || (i == 6)) begin
                        sim_x = ((i==2 ? 1 : x[2]) + (i==4 ? 1 : x[4]) + (i==6 ? 1 : x[6]));
                        sim_o = (o[2] + o[4] + o[6]);
                        if((sim_x == 2) && (sim_o == 0))
                            fork_count = fork_count + 1;
                    end
                    if(fork_count >= 2)
                        candidate = i;
                end
            end
            create_fork = candidate;
        end
    endfunction

    function [3:0] prevent_fork(input [8:0] x, input [8:0] o);
        reg [3:0] i, fork_count;
        begin
            for(i = 0; i < 9; i = i + 1) begin
                if(!o[i]) begin
                    fork_count = 0;
                    if(!x[3*(i/3)] && !x[3*(i/3)+1] && !x[3*(i/3)+2])
                        fork_count = fork_count + 1;
                    if(!x[i%3] && !x[i%3+3] && !x[i%3+6])
                        fork_count = fork_count + 1;
                    if((i==0)||(i==2)||(i==4)||(i==6)||(i==8)) begin
                        if(!x[0] && !x[4] && !x[8])
                            fork_count = fork_count + 1;
                        if(!x[2] && !x[4] && !x[6])
                            fork_count = fork_count + 1;
                    end
                    if(fork_count > 1)
                        prevent_fork = i;
                end
            end
            prevent_fork = 9;
        end
    endfunction

    always @(*) begin
        case(n_moves(x,o))
            0: move = 4;
            1: move = (x[4] | o[4]) ? 0 : 4;
            2: begin
                if(o[4] | x[4]) begin
                    if(((x|o) & 9'b111_000_111) != 9'b000_000_000) begin
                        move = 3;
                    end 
                    else move = 1;
                end
                else move = 4;
            end
            3,4,5,6,7: begin
                temp1 = get_winning_move(o,x);
                if(temp1 != 9)
                    move = temp1;
                else begin
                    temp1 = get_winning_move(x,o);
                    if(temp1 != 9)
                        move = temp1;
                    else begin
                        temp1 = create_fork(o,x);
                        if(temp1 != 9)
                            move = temp1;
                        else begin
                            temp1 = create_fork(x,o);
                            if(temp1 != 9)
                                move = temp1;
                            else
                                move = get_empty_move(x|o);
                        end
                    end
                end
            end
            8: move = get_empty_move(x|o);
            default: move = get_empty_move(x|o);
        endcase
    end

    assign Move = move;
endmodule

module ai_medium (input clk, input [8:0] x, input [8:0] o, output [3:0] Move);
    reg [3:0] temp1, move;
    
    function [3:0] n_moves(input [8:0] x, input [8:0] o);
    begin
        n_moves = (x[0]+x[1]+x[2]+x[3]+x[4]+x[5]+x[6]+x[7]+x[8])+(o[0]+o[1]+o[2]+o[3]+o[4]+o[5]+o[6]+o[7]+o[8]);
    end
    endfunction

    function [3:0] get_empty_move(input [8:0] board);
    begin
        if(!board[0]) get_empty_move = 0;
        else if(!board[1]) get_empty_move = 1;
        else if(!board[2]) get_empty_move = 2;
        else if(!board[3]) get_empty_move = 3;
        else if(!board[4]) get_empty_move = 4;
        else if(!board[5]) get_empty_move = 5;
        else if(!board[6]) get_empty_move = 6;
        else if(!board[7]) get_empty_move = 7;
        else if(!board[8]) get_empty_move = 8;
        else get_empty_move = 9;
    end
    endfunction

    function [3:0] get_winning_move(input [8:0] o, input [8:0] x);
    begin
        if(!x[0] && !o[0] && x[1] && x[2]) get_winning_move = 0;
        else if(!x[1] && !o[1] && x[0] && x[2]) get_winning_move = 1;
        else if(!x[2] && !o[2] && x[0] && x[1]) get_winning_move = 2;
        else if(!x[3] && !o[3] && x[4] && x[5]) get_winning_move = 3;
        else if(!x[4] && !o[4] && x[3] && x[5]) get_winning_move = 4;
        else if(!x[5] && !o[5] && x[3] && x[4]) get_winning_move = 5;
        else if(!x[6] && !o[6] && x[7] && x[8]) get_winning_move = 6;
        else if(!x[7] && !o[7] && x[6] && x[8]) get_winning_move = 7;
        else if(!x[8] && !o[8] && x[6] && x[7]) get_winning_move = 8;
        else if(!x[0] && !o[0] && x[3] && x[6]) get_winning_move = 0;
        else if(!x[3] && !o[3] && x[0] && x[6]) get_winning_move = 3;
        else if(!x[6] && !o[6] && x[0] && x[3]) get_winning_move = 6;
        else if(!x[1] && !o[1] && x[4] && x[7]) get_winning_move = 1;
        else if(!x[4] && !o[4] && x[1] && x[7]) get_winning_move = 4;
        else if(!x[7] && !o[7] && x[1] && x[4]) get_winning_move = 7;
        else if(!x[2] && !o[2] && x[5] && x[8]) get_winning_move = 2;
        else if(!x[5] && !o[5] && x[2] && x[8]) get_winning_move = 5;
        else if(!x[8] && !o[8] && x[2] && x[5]) get_winning_move = 8;
        else if(!x[0] && !o[0] && x[4] && x[8]) get_winning_move = 0;
        else if(!x[4] && !o[4] && x[0] && x[8]) get_winning_move = 4;
        else if(!x[8] && !o[8] && x[0] && x[4]) get_winning_move = 8;
        else if(!x[2] && !o[2] && x[4] && x[6]) get_winning_move = 2;
        else if(!x[4] && !o[4] && x[2] && x[6]) get_winning_move = 4;
        else if(!x[6] && !o[6] && x[2] && x[4]) get_winning_move = 6;
        else get_winning_move = 9;
    end
    endfunction

    always @(*) begin
        case(n_moves(x,o))
            0: move = 4;
            1: move = (x[4] | o[4]) ? 0 : 4;
            2: begin
                if(o[4] | x[4]) begin
                    if(((x|o)  & 9'b111_000_111) != 9'b000_000_000) begin
                        move = 3;
                    end 
                    else move = 1;
                end
                else move = 4;
            end
            3,4,5,6,7: begin
                temp1 = get_winning_move(o,x);
                if(temp1 != 9)
                    move = temp1;
                else begin
                    temp1 = get_winning_move(x,o);
                    if(temp1 != 9)
                        move = temp1;
                    else begin
                        move = get_empty_move(x|o);
                        end
                    end
                end
            8: move = get_empty_move(x|o);
            default: move = get_empty_move(x|o);
        endcase
    end

    assign Move = move;
endmodule

module ai_low (input clk, input [8:0] x, input [8:0] o, output [3:0] Move);
    reg [3:0] temp1, move;
    
    function [3:0] n_moves(input [8:0] x, input [8:0] o);
    begin
        n_moves = (x[0]+x[1]+x[2]+x[3]+x[4]+x[5]+x[6]+x[7]+x[8])+(o[0]+o[1]+o[2]+o[3]+o[4]+o[5]+o[6]+o[7]+o[8]);
    end
    endfunction

    function [3:0] get_empty_move(input [8:0] board);
    begin
        if(!board[0]) get_empty_move = 0;
        else if(!board[1]) get_empty_move = 1;
        else if(!board[2]) get_empty_move = 2;
        else if(!board[3]) get_empty_move = 3;
        else if(!board[4]) get_empty_move = 4;
        else if(!board[5]) get_empty_move = 5;
        else if(!board[6]) get_empty_move = 6;
        else if(!board[7]) get_empty_move = 7;
        else if(!board[8]) get_empty_move = 8;
        else get_empty_move = 9;
    end
    endfunction


    always @(posedge clk) begin
        case(n_moves(x,o))
            0: move = 4;
            default: move = get_empty_move(x|o);
        endcase
    end

    assign Move = move;
endmodule

