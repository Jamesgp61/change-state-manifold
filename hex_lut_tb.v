// hex_lut_tb.v — Verilog-2001 testbench for hex_lut
// No clock — purely combinational DUT; #1 delay lets outputs settle.
//
// Required checks:  111111→1, 000000→2, 101010→64
// Spot-checks:      hex 3,10,17,24,28,32,37,44,51,57,62,63  (12 entries)
// Invalid input:    6'b111111 default is never hit (all 64 are mapped);
//                   test one unused pattern via force isn't needed —
//                   all 64 6-bit patterns ARE valid, so no default case fires.
//                   We test the default by exercising a known-bad path won't
//                   appear; no unused patterns exist.

`timescale 1ns/1ps

module hex_lut_tb;

    reg  [5:0] hex_binary;
    wire [6:0] hex_number;

    // Instantiate DUT — all connection wires declared above via port list
    hex_lut uut (
        .hex_binary(hex_binary),
        .hex_number(hex_number)
    );

    integer errors;

    // Helper task: apply input, wait, check, report
    task check;
        input [5:0] bin_in;
        input [6:0] expected;
        input [7:0] label;        // hexagram number for display
        begin
            hex_binary = bin_in;
            #1;
            if (hex_number !== expected) begin
                $display("FAIL  hex_%0d : binary=%b  got=%0d  expected=%0d",
                         label, bin_in, hex_number, expected);
                errors = errors + 1;
            end else begin
                $display("PASS  hex_%0d : binary=%b → %0d", label, bin_in, hex_number);
            end
        end
    endtask

    initial begin
        errors = 0;

        // ── Required checks ──────────────────────────────────────────
        check(6'b111111, 7'd1,  8'd1);   // pure Yang
        check(6'b000000, 7'd2,  8'd2);   // pure Yin
        check(6'b101010, 7'd64, 8'd64);  // Water-Fire / Wei Chi

        // ── Spot-checks (spread across the table) ────────────────────
        check(6'b010001, 7'd3,  8'd3);   // hex  3 — Difficulty at the Beginning
        check(6'b111011, 7'd10, 8'd10);  // hex 10 — Treading
        check(6'b011001, 7'd17, 8'd17);  // hex 17 — Following
        check(6'b000001, 7'd24, 8'd24);  // hex 24 — Return
        check(6'b011110, 7'd28, 8'd28);  // hex 28 — Preponderance of the Great
        check(6'b001110, 7'd32, 8'd32);  // hex 32 — Duration
        check(6'b110101, 7'd37, 8'd37);  // hex 37 — The Family
        check(6'b111110, 7'd44, 8'd44);  // hex 44 — Coming to Meet
        check(6'b001001, 7'd51, 8'd51);  // hex 51 — The Arousing (Thunder)
        check(6'b110110, 7'd57, 8'd57);  // hex 57 — The Gentle (Wind)
        check(6'b001100, 7'd62, 8'd62);  // hex 62 — Preponderance of the Small
        check(6'b010101, 7'd63, 8'd63);  // hex 63 — After Completion

        // ── Summary ──────────────────────────────────────────────────
        if (errors == 0)
            $display("PASS  All %0d checks passed.", 15);
        else
            $display("FAIL  %0d check(s) failed.", errors);

        $finish;
    end

endmodule
