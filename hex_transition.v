// hex_transition.v — Verilog-2001
// Combinational module: flips the bit at line_pos in hex_in using XOR.
// hex_in  [5:0] — 6-bit input value
// line_pos[2:0] — bit position to flip (valid range 0–5)
// hex_out [5:0] — hex_in with bit line_pos inverted

module hex_transition (
    input  wire [5:0] hex_in,
    input  wire [2:0] line_pos,
    output reg  [5:0] hex_out
);

    always @(*) begin
        case (line_pos)
            3'd0: hex_out = hex_in ^ 6'b000001;
            3'd1: hex_out = hex_in ^ 6'b000010;
            3'd2: hex_out = hex_in ^ 6'b000100;
            3'd3: hex_out = hex_in ^ 6'b001000;
            3'd4: hex_out = hex_in ^ 6'b010000;
            3'd5: hex_out = hex_in ^ 6'b100000;
            default: hex_out = hex_in; // line_pos 6-7: no-op (out of range)
        endcase
    end

endmodule
