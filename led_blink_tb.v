// led_blink_tb.v — Verilog-2001 testbench for led_blink
// Uses HALF_PERIOD=4 so each LED toggle takes 4 clock cycles.
// Runs for enough cycles to observe several full blink periods.

`timescale 1ns/1ps

module led_blink_tb;

    // ----------------------------------------------------------------
    // Parameters
    // ----------------------------------------------------------------
    localparam HALF_PERIOD  = 4;    // small value for simulation
    localparam CLK_HALF     = 4;    // 4 ns half-period => 8 ns clock (125 MHz)
    localparam RUN_CYCLES   = 100;

    // ----------------------------------------------------------------
    // DUT signals
    // ----------------------------------------------------------------
    reg  clk;
    reg  rst_n;
    wire led;

    // ----------------------------------------------------------------
    // DUT instantiation
    // ----------------------------------------------------------------
    led_blink #(
        .HALF_PERIOD(HALF_PERIOD)
    ) dut (
        .clk   (clk),
        .rst_n (rst_n),
        .led   (led)
    );

    // ----------------------------------------------------------------
    // Clock generation
    // ----------------------------------------------------------------
    initial clk = 1'b0;
    always #(CLK_HALF) clk = ~clk;

    // ----------------------------------------------------------------
    // Edge detection (Verilog-2001: use registered copy, not $past)
    // ----------------------------------------------------------------
    reg led_prev;
    always @(posedge clk) led_prev <= led;

    // ----------------------------------------------------------------
    // Stimulus
    // ----------------------------------------------------------------
    integer cycle;

    initial begin
        $display("=== led_blink simulation start ===");
        $display("  HALF_PERIOD=%0d cycles  LED full period=%0d cycles",
                 HALF_PERIOD, HALF_PERIOD * 2);

        // Assert reset for 3 clock cycles
        rst_n = 1'b0;
        repeat (3) @(posedge clk);
        rst_n = 1'b1;
        $display("  Reset released at time %0t", $time);

        // Run for RUN_CYCLES cycles after reset
        repeat (RUN_CYCLES) @(posedge clk);

        $display("=== simulation complete (%0d post-reset cycles) ===", RUN_CYCLES);
        $finish;
    end

    // ----------------------------------------------------------------
    // Monitor — print a line on every LED transition
    // ----------------------------------------------------------------
    always @(posedge clk) begin
        if (rst_n && (led !== led_prev)) begin
            $display("  t=%0t  LED -> %b", $time, led);
        end
    end

endmodule
