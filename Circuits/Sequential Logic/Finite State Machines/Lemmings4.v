module top_module(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    localparam LEFT   = 3'b000,
               RIGHT  = 3'b001,
               FALL_L = 3'b010,
               FALL_R = 3'b011,
               DIG_L  = 3'b100,
               DIG_R  = 3'b101,
               SPLATTERED = 3'b110;  

    reg [2:0] state;
    reg [10:0] count;  // to check if the lemming has been falling for 20 cycles

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT;  // areset: reset to initial left-walking state
            count <= 11'd0;  // count: reset to 0 on areset
        end
        else begin
            unique case (state)
                LEFT: begin
                    state <= !ground ? FALL_L : (dig ? DIG_L : (bump_left ? RIGHT : LEFT));
                    count <= 11'd0;  // reset count when not falling
                end                 
                RIGHT:  begin
                    state <= !ground ? FALL_R : (dig ? DIG_R : (bump_right ? LEFT : RIGHT));
                    count <= 11'd0;  
                end
                FALL_L: begin
                    if (ground) begin
                        if (count >= 20)
                            state <= SPLATTERED;
                        else
                            state <= LEFT;
                    end 
                    else begin
                        state <= FALL_L;
                        count <= count + 1;
                    end
                end
                FALL_R: begin
                    if (ground) begin
                        if (count >= 20)
                            state <= SPLATTERED;
                        else
                            state <= RIGHT;
                    end 
                    else begin
                        state <= FALL_R;
                        count <= count + 1;
                    end
                end
                DIG_L:  begin
                    state <= !ground ? FALL_L : DIG_L;
                    count <= 11'd0;  
                end
                DIG_R:  begin
                    state <= !ground ? FALL_R : DIG_R;
                    count <= 11'd0;  
                end
                SPLATTERED: state <= SPLATTERED;  
            endcase
        end 
    end

    assign aaah = (state == FALL_L) || (state == FALL_R);
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);  
    assign digging = (state == DIG_L) || (state == DIG_R);  

endmodule