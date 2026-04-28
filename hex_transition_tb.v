// hex_transition_tb.v — Verilog-2001 testbench for hex_transition
// Tests all six valid line_pos values against input 6'b101010.
// Purely combinational: no clock required.

`timescale 1ns/1ps

module hex_transition_tb;

    // ----------------------------------------------------------------
    // DUT signals
    // ----------------------------------------------------------------
    reg  [5:0] hex_in;
    reg  [2:0] line_pos;
    wire [5:0] hex_out;

    // ----------------------------------------------------------------
    // DUT instantiation
    // ----------------------------------------------------------------
    hex_transition dut (
        .hex_in  (hex_in),
        .line_pos(line_pos),
        .hex_out (hex_out)
    );

    // ----------------------------------------------------------------
    // Expected value — computed combinationally in the testbench
    // ----------------------------------------------------------------
    reg  [5:0] expected;
    integer    pos;
    integer    errors;

    // ----------------------------------------------------------------
    // Stimulus and self-check
    // ----------------------------------------------------------------
    initial begin
        errors  = 0;
        hex_in  = 6'b101010;   // fixed input throughout all tests

        $display("=== hex_transition testbench ===");
        $display("  Fixed input: hex_in = %06b (0x%02X)", hex_in, hex_in);
        $display("");
        $display("  pos | hex_in   | expected | hex_out  | result");
        $display("  ----|----------|----------|----------|-------");

        for (pos = 0; pos < 6; pos = pos + 1) begin
            line_pos = pos[2:0];
            expected = hex_in ^ (6'b000001 << pos);
            #1; // allow combinational logic to settle

            if (hex_out === expected)
                $display("   %0d  | %06b | %06b | %06b | PASS",
                         pos, hex_in, expected, hex_out);
            else begin
                $display("   %0d  | %06b | %06b | %06b | FAIL ***",
                         pos, hex_in, expected, hex_out);
                errors = errors + 1;
            end
        end

        $display("");
        if (errors == 0)
            $display("=== All %0d tests PASSED ===", 6);
        else
            $display("=== %0d test(s) FAILED ===", errors);

        $finish;
    end

endmodule
