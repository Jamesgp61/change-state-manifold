// hex_csm_node_tb.v — Verilog-2001 testbench for hex_csm_node
//
// Test sequence (stimulus driven at negedge, outputs read at next negedge):
//   1. Assert reset — confirm node_a=111111 (hex 1), node_b=000000 (hex 2)
//   2. Trigger line_pos=0 — node_a → 111110 (hex 44), node_b → 000001 (hex 24)
//   3. Trigger line_pos=2 — node_a → 111010 (hex  6), node_b → 000101 (hex 36)
//   4. Trigger line_pos=5 — node_a → 011010 (hex 47), node_b → 100101 (hex 22)
//   5. Re-assert reset mid-sequence — confirm return to hex 1 / hex 2
//
// Stimulus is driven at negedge clk and outputs sampled at the following negedge
// to avoid the Icarus active-region race documented in AGENTS.md.

`timescale 1ns/1ps

module hex_csm_node_tb;

    // ----------------------------------------------------------------
    // DUT signals
    // ----------------------------------------------------------------
    reg        clk;
    reg        rst_n;
    reg  [2:0] line_pos;
    reg        trigger;
    wire [5:0] node_a;
    wire [5:0] node_b;
    wire [6:0] hex_num_a;
    wire [6:0] hex_num_b;

    // ----------------------------------------------------------------
    // DUT instantiation
    // ----------------------------------------------------------------
    hex_csm_node dut (
        .clk      (clk),
        .rst_n    (rst_n),
        .line_pos (line_pos),
        .trigger  (trigger),
        .node_a   (node_a),
        .node_b   (node_b),
        .hex_num_a(hex_num_a),
        .hex_num_b(hex_num_b)
    );

    // ----------------------------------------------------------------
    // Clock — 10 ns period (5 ns half-period) for fast simulation
    // ----------------------------------------------------------------
    initial clk = 0;
    always #5 clk = ~clk;

    // ----------------------------------------------------------------
    // Error counter
    // ----------------------------------------------------------------
    integer errors;

    // ----------------------------------------------------------------
    // Check task: sample at negedge, compare, report
    // ----------------------------------------------------------------
    task check;
        input [5:0]  exp_node_a;
        input [5:0]  exp_node_b;
        input [6:0]  exp_num_a;
        input [6:0]  exp_num_b;
        input [63:0] test_id;
        begin
            if (node_a !== exp_node_a) begin
                $display("FAIL [%0d] node_a: got %06b, expected %06b",
                         test_id, node_a, exp_node_a);
                errors = errors + 1;
            end
            if (node_b !== exp_node_b) begin
                $display("FAIL [%0d] node_b: got %06b, expected %06b",
                         test_id, node_b, exp_node_b);
                errors = errors + 1;
            end
            if (hex_num_a !== exp_num_a) begin
                $display("FAIL [%0d] hex_num_a: got %0d, expected %0d",
                         test_id, hex_num_a, exp_num_a);
                errors = errors + 1;
            end
            if (hex_num_b !== exp_num_b) begin
                $display("FAIL [%0d] hex_num_b: got %0d, expected %0d",
                         test_id, hex_num_b, exp_num_b);
                errors = errors + 1;
            end
            if (node_a === exp_node_a && node_b === exp_node_b &&
                hex_num_a === exp_num_a && hex_num_b === exp_num_b) begin
                $display("PASS [%0d] node_a=%06b(%0d) node_b=%06b(%0d)",
                         test_id, node_a, hex_num_a, node_b, hex_num_b);
            end
        end
    endtask

    // ----------------------------------------------------------------
    // Stimulus
    // ----------------------------------------------------------------
    initial begin
        errors   = 0;
        rst_n    = 0;
        trigger  = 0;
        line_pos = 3'd0;

        // ---- Test 1: reset state ----------------------------------------
        // Drive at negedge, sample at following negedge
        @(negedge clk);
        rst_n = 0; trigger = 0;
        @(negedge clk);
        // node_a=111111 (hex 1), node_b=000000 (hex 2)
        check(6'b111111, 6'b000000, 7'd1, 7'd2, 1);

        // ---- Release reset -----------------------------------------------
        @(negedge clk);
        rst_n = 1;

        // ---- Test 2: trigger line_pos=0 ---------------------------------
        // node_a: 111111 ^ bit0 = 111110 (hex 44)
        // node_b: 000000 ^ bit0 = 000001 (hex 24)
        @(negedge clk);
        line_pos = 3'd0; trigger = 1;
        @(negedge clk);
        trigger = 0;          // deassert after one cycle
        @(negedge clk);
        check(6'b111110, 6'b000001, 7'd44, 7'd24, 2);

        // ---- Test 3: trigger line_pos=2 ---------------------------------
        // node_a: 111110 ^ bit2 = 111010 (hex 6)
        // node_b: 000001 ^ bit2 = 000101 (hex 36)
        @(negedge clk);
        line_pos = 3'd2; trigger = 1;
        @(negedge clk);
        trigger = 0;
        @(negedge clk);
        check(6'b111010, 6'b000101, 7'd6, 7'd36, 3);

        // ---- Test 4: trigger line_pos=5 ---------------------------------
        // node_a: 111010 ^ bit5 = 011010 (hex 47)
        // node_b: 000101 ^ bit5 = 100101 (hex 22)
        @(negedge clk);
        line_pos = 3'd5; trigger = 1;
        @(negedge clk);
        trigger = 0;
        @(negedge clk);
        check(6'b011010, 6'b100101, 7'd47, 7'd22, 4);

        // ---- Test 5: mid-sequence reset ---------------------------------
        // After any number of transitions, reset must restore hex 1 / hex 2
        @(negedge clk);
        rst_n = 0; trigger = 0;
        @(negedge clk);
        check(6'b111111, 6'b000000, 7'd1, 7'd2, 5);

        // ---- Report -----------------------------------------------------
        @(negedge clk);
        if (errors == 0)
            $display("ALL TESTS PASSED (%0d errors)", errors);
        else
            $display("FAILED: %0d error(s)", errors);

        $finish;
    end

endmodule
