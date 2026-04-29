// hex_csm_node.v — Verilog-2001
// Integrates hex_two_node with two hex_lut instances so that every triggered
// transition resolves immediately to hexagram numbers in the same clock cycle.
//
// Registered state (hex_two_node):
//   node_a resets to 6'b111111  → hexagram  1 (pure Yang)
//   node_b resets to 6'b000000  → hexagram  2 (pure Yin)
//
// Combinational resolution (hex_lut × 2):
//   hex_num_a and hex_num_b are valid one gate delay after node_a / node_b settle,
//   i.e. within the same clock cycle that a triggered transition is registered.
//
// Ports:
//   clk        — clock
//   rst_n      — active-low synchronous reset
//   line_pos   — bit position to flip (0–5); passed straight to hex_two_node
//   trigger    — hold high for exactly one cycle to apply a transition
//   node_a     — raw 6-bit pattern for node A (pass-through for observability)
//   node_b     — raw 6-bit pattern for node B (pass-through for observability)
//   hex_num_a  — hexagram number for node A (1–64; 0 = invalid, should never occur)
//   hex_num_b  — hexagram number for node B (1–64; 0 = invalid, should never occur)

module hex_csm_node (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [2:0] line_pos,
    input  wire       trigger,
    output wire [5:0] node_a,
    output wire [5:0] node_b,
    output wire [6:0] hex_num_a,
    output wire [6:0] hex_num_b
);

    // ----------------------------------------------------------------
    // hex_two_node — registered state for both nodes
    // ----------------------------------------------------------------
    hex_two_node u_two_node (
        .clk     (clk),
        .rst_n   (rst_n),
        .line_pos(line_pos),
        .trigger (trigger),
        .node_a  (node_a),
        .node_b  (node_b)
    );

    // ----------------------------------------------------------------
    // hex_lut for node A — combinational, resolves same cycle as register
    // ----------------------------------------------------------------
    hex_lut u_lut_a (
        .hex_binary(node_a),
        .hex_number(hex_num_a)
    );

    // ----------------------------------------------------------------
    // hex_lut for node B — combinational, resolves same cycle as register
    // ----------------------------------------------------------------
    hex_lut u_lut_b (
        .hex_binary(node_b),
        .hex_number(hex_num_b)
    );

endmodule
