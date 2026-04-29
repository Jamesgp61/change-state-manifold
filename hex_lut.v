// hex_lut.v — Verilog-2001
// Combinational lookup table: 6-bit hexagram binary pattern → hexagram number (1–64).
//
// Input:  hex_binary [5:0]  — 6-bit line pattern (bit 0 = bottom line)
// Output: hex_number [6:0]  — hexagram number 1–64; 7'd0 for invalid input
//
// Source: HEXAGRAM_TO_BINARY_MAP in services.py (inverted).
// Bit ordering: services.py stores strings MSB-first (e.g. "111111" for hex 1),
// so hex_binary[5] is the top line and hex_binary[0] is the bottom line.

module hex_lut (
    input  wire [5:0] hex_binary,
    output reg  [6:0] hex_number
);

    always @(*) begin
        case (hex_binary)
            6'b111111: hex_number = 7'd1;
            6'b000000: hex_number = 7'd2;
            6'b010001: hex_number = 7'd3;
            6'b100010: hex_number = 7'd4;
            6'b010111: hex_number = 7'd5;
            6'b111010: hex_number = 7'd6;
            6'b000010: hex_number = 7'd7;
            6'b010000: hex_number = 7'd8;
            6'b110111: hex_number = 7'd9;
            6'b111011: hex_number = 7'd10;
            6'b000111: hex_number = 7'd11;
            6'b111000: hex_number = 7'd12;
            6'b111101: hex_number = 7'd13;
            6'b101111: hex_number = 7'd14;
            6'b000100: hex_number = 7'd15;
            6'b001000: hex_number = 7'd16;
            6'b011001: hex_number = 7'd17;
            6'b100110: hex_number = 7'd18;
            6'b000011: hex_number = 7'd19;
            6'b110000: hex_number = 7'd20;
            6'b101001: hex_number = 7'd21;
            6'b100101: hex_number = 7'd22;
            6'b100000: hex_number = 7'd23;
            6'b000001: hex_number = 7'd24;
            6'b111001: hex_number = 7'd25;
            6'b100111: hex_number = 7'd26;
            6'b100001: hex_number = 7'd27;
            6'b011110: hex_number = 7'd28;
            6'b010010: hex_number = 7'd29;
            6'b101101: hex_number = 7'd30;
            6'b011100: hex_number = 7'd31;
            6'b001110: hex_number = 7'd32;
            6'b111100: hex_number = 7'd33;
            6'b001111: hex_number = 7'd34;
            6'b101000: hex_number = 7'd35;
            6'b000101: hex_number = 7'd36;
            6'b110101: hex_number = 7'd37;
            6'b101011: hex_number = 7'd38;
            6'b010100: hex_number = 7'd39;
            6'b001010: hex_number = 7'd40;
            6'b100011: hex_number = 7'd41;
            6'b110001: hex_number = 7'd42;
            6'b011111: hex_number = 7'd43;
            6'b111110: hex_number = 7'd44;
            6'b011000: hex_number = 7'd45;
            6'b000110: hex_number = 7'd46;
            6'b011010: hex_number = 7'd47;
            6'b010110: hex_number = 7'd48;
            6'b011101: hex_number = 7'd49;
            6'b101110: hex_number = 7'd50;
            6'b001001: hex_number = 7'd51;
            6'b100100: hex_number = 7'd52;
            6'b110100: hex_number = 7'd53;
            6'b001011: hex_number = 7'd54;
            6'b001101: hex_number = 7'd55;
            6'b101100: hex_number = 7'd56;
            6'b110110: hex_number = 7'd57;
            6'b011011: hex_number = 7'd58;
            6'b110010: hex_number = 7'd59;
            6'b010011: hex_number = 7'd60;
            6'b110011: hex_number = 7'd61;
            6'b001100: hex_number = 7'd62;
            6'b010101: hex_number = 7'd63;
            6'b101010: hex_number = 7'd64;
            default:   hex_number = 7'd0;
        endcase
    end

endmodule
