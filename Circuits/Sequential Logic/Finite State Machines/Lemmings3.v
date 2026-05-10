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
               DIG_R  = 3'b101;

    reg [2:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;  // areset: reset to initial left-walking state
        else begin
            unique case (state)
                LEFT:   state <= !ground ? FALL_L : (dig ? DIG_L : (bump_left ? RIGHT : LEFT));
                RIGHT:  state <= !ground ? FALL_R : (dig ? DIG_R : (bump_right ? LEFT : RIGHT));
                FALL_L: state <= ground ? LEFT : FALL_L;
                FALL_R: state <= ground ? RIGHT : FALL_R;
                DIG_L:  state <= !ground ? FALL_L : DIG_L;
                DIG_R:  state <= !ground ? FALL_R : DIG_R;
            endcase
        end
    end

    assign aaah = (state == FALL_L) || (state == FALL_R);   // aaah: high when in any falling state
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign digging = (state == DIG_L) || (state == DIG_R);  // digging: high when in any digging state

endmodule