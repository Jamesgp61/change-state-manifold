// hex_two_node_tb.v — Verilog-2001 testbench for hex_two_node
//
// Drives inputs at negedge and reads outputs at the following negedge to
// avoid setup/hold races with the DUT's posedge sensitivity.
// (In iverilog, driving at posedge then immediately deasserting in the same
// active region can cause the DUT to see the deasserted value.)
//
// Sequence:
//   1. Reset both nodes (node_a → 111111, node_b → 000000)
//   2. Trigger transition on line_pos = 0
//   3. Trigger transition on line_pos = 3
//   4. Trigger transition on line_pos = 5

`timescale 1ns/1ps

module hex_two_node_tb;

    // ----------------------------------------------------------------
    // DUT signals
    // ----------------------------------------------------------------
    reg        clk;
    reg        rst_n;
    reg  [2:0] line_pos;
    reg        trigger;
    wire [5:0] node_a;
    wire [5:0] node_b;

    // ----------------------------------------------------------------
    // DUT instantiation (hex_transition compiled in the same unit)
    // ----------------------------------------------------------------
    hex_two_node dut (
        .clk     (clk),
        .rst_n   (rst_n),
        .line_pos(line_pos),
        .trigger (trigger),
        .node_a  (node_a),
        .node_b  (node_b)
    );

    // ----------------------------------------------------------------
    // Clock: 8 ns period (125 MHz equivalent)
    // ----------------------------------------------------------------
    initial clk = 1'b0;
    always #4 clk = ~clk;

    // ----------------------------------------------------------------
    // Task: apply one triggered transition and display result.
    // Drive inputs at negedge so they are stable and settled before
    // the next posedge.  Read outputs at the following negedge after
    // the NBA update has long committed.
    // ----------------------------------------------------------------
    task apply_transition;
        input [2:0] pos;
        begin
            @(negedge clk);        // safe drive point — clock is low
            line_pos = pos;
            trigger  = 1'b1;
            @(posedge clk);        // DUT captures trigger=1 here, uncontested
            @(negedge clk);        // NBAs committed; safe to read outputs
            trigger  = 1'b0;
            $display("  After flip bit %0d: node_a=%06b (0x%02X)  node_b=%06b (0x%02X)",
                     pos, node_a, node_a, node_b, node_b);
        end
    endtask

    // ----------------------------------------------------------------
    // Stimulus
    // ----------------------------------------------------------------
    initial begin
        $display("=== hex_two_node simulation ===");

        rst_n    = 1'b0;
        trigger  = 1'b0;
        line_pos = 3'd0;

        // Hold reset for 3 rising edges
        repeat (3) @(posedge clk);
        rst_n = 1'b1;
        #1;    // let NBA reset values settle before displaying
        $display("  After reset:      node_a=%06b (0x%02X)  node_b=%06b (0x%02X)",
                 node_a, node_a, node_b, node_b);

        apply_transition(3'd0);
        apply_transition(3'd3);
        apply_transition(3'd5);

        $display("=== simulation complete ===");
        $finish;
    end

endmodule
