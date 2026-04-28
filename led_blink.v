// led_blink.v — Verilog-2001
// Blinks an LED by toggling it every time a counter reaches HALF_PERIOD.
// At 125 MHz with HALF_PERIOD=62_500_000 the LED toggles at ~1 Hz.
// In simulation a small HALF_PERIOD (e.g. 4) keeps run-time short.

module led_blink #(
    parameter HALF_PERIOD = 62_500_000  // counts per half-period
) (
    input  wire clk,
    input  wire rst_n,   // active-low synchronous reset
    output reg  led
);

    reg [26:0] counter;

    always @(posedge clk) begin
        if (!rst_n) begin
            counter <= 27'd0;
            led     <= 1'b0;
        end else begin
            if (counter == HALF_PERIOD - 1) begin
                counter <= 27'd0;
                led     <= ~led;
            end else begin
                counter <= counter + 27'd1;
            end
        end
    end

endmodule
