module top_module(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    localparam LEFT   = 2'b00,
               RIGHT  = 2'b01,
               FALL_L = 2'b10,
               FALL_R = 2'b11;

    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;
        else begin
            unique case (state)
                LEFT:  state <= !ground ? FALL_L : (bump_left ? RIGHT : LEFT);
                RIGHT: state <= !ground ? FALL_R : (bump_right ? LEFT : RIGHT);
                FALL_L: state <= ground ? LEFT : FALL_L;
                FALL_R: state <= ground ? RIGHT : FALL_R;
            endcase
        end
    end

    assign aaah = (state == FALL_L) || (state == FALL_R);
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule