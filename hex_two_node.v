// hex_two_node.v — Verilog-2001
// Two registered hexagram nodes that transition together via hex_transition.
//
// node_a resets to 6'b111111 (Hexagram 1 — pure Yang)
// node_b resets to 6'b000000 (Hexagram 2 — pure Yin)
//
// On a rising clock edge with trigger high, both nodes flip the bit at
// line_pos using the hex_transition combinational module.

module hex_two_node (
    input  wire       clk,
    input  wire       rst_n,      // active-low synchronous reset
    input  wire [2:0] line_pos,   // bit position to flip (0–5)
    input  wire       trigger,    // high for one cycle to apply transition
    output reg  [5:0] node_a,     // Hexagram 1 state
    output reg  [5:0] node_b      // Hexagram 2 state
);

    // ----------------------------------------------------------------
    // Wires carrying the combinational next-state values
    // ----------------------------------------------------------------
    wire [5:0] next_a;
    wire [5:0] next_b;

    // ----------------------------------------------------------------
    // hex_transition instance for node_a
    // ----------------------------------------------------------------
    hex_transition u_trans_a (
        .hex_in  (node_a),
        .line_pos(line_pos),
        .hex_out (next_a)
    );

    // ----------------------------------------------------------------
    // hex_transition instance for node_b
    // ----------------------------------------------------------------
    hex_transition u_trans_b (
        .hex_in  (node_b),
        .line_pos(line_pos),
        .hex_out (next_b)
    );

    // ----------------------------------------------------------------
    // Registered state — update on trigger, reset to initial hexagrams
    // ----------------------------------------------------------------
    always @(posedge clk) begin
        if (!rst_n) begin
            node_a <= 6'b111111;   // Hexagram 1: pure Yang
            node_b <= 6'b000000;   // Hexagram 2: pure Yin
        end else if (trigger) begin
            node_a <= next_a;
            node_b <= next_b;
        end
    end

endmodule
