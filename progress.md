# Project Progress — State Machine

<!-- HOW TO USE
  - Update this file whenever a module changes verification state.
  - States: DESIGNED | LINTED | SIMULATED | HARDWARE_TESTED
  - Each state must be reached in order; you cannot skip states.
  - "SIMULATED" requires a clean iverilog compile AND correct vvp output.
  - "HARDWARE_TESTED" requires physical test on Raspberry Pi 5 GPIO.
  - Log entries are append-only. Never delete a log entry.
  - Before starting any task, read this file to avoid repeating completed work.
-->

## Module Registry

| Module | File | State | Last Verified |
|--------|------|--------|---------------|
| led_blink | `led_blink.v` | SIMULATED | 2026-04-27 |
| hex_transition | `hex_transition.v` | SIMULATED | 2026-04-27 |
| hex_two_node | `hex_two_node.v` | SIMULATED | 2026-04-27 |
| hex_lut | `hex_lut.v` | SIMULATED | 2026-04-28 |

---

## State Definitions

```
DESIGNED        Source file exists, not yet linted.
LINTED          verilator --lint-only -Wall passes with zero warnings.
SIMULATED       iverilog -g2001 compile succeeds + vvp output is correct.
HARDWARE_TESTED Module exercised on physical Pi 5 hardware (GPIO observed).
```

Progression rule: `DESIGNED → LINTED → SIMULATED → HARDWARE_TESTED`

---

## Module Detail

### led_blink

- **File**: `led_blink.v`
- **Testbench**: `led_blink_tb.v`
- **State**: `SIMULATED`
- **Interface**:
  - `clk` — input clock (125 MHz target)
  - `rst_n` — active-low synchronous reset
  - `led` — output, toggles every `HALF_PERIOD` cycles
- **Parameter**: `HALF_PERIOD` (default `62_500_000` → ~1 Hz at 125 MHz)
- **Counter width**: 27 bits (covers up to 134 217 727; sufficient for default)

**Verification log**:

```
2026-04-27  LINTED      verilator 5.032 — zero warnings
2026-04-27  SIMULATED   iverilog -g2001 + vvp
                        HALF_PERIOD=4 (testbench override)
                        25 LED edges in 100 post-reset cycles — correct
                        Toggle period = 8 cycles (2 × HALF_PERIOD) ✓
```

**Pending**:
- [ ] Hardware test on Pi 5 — observe LED on GPIO pin at ~1 Hz

---

### hex_transition

- **File**: `hex_transition.v`
- **Testbench**: `hex_transition_tb.v`
- **State**: `SIMULATED`
- **Interface**:
  - `hex_in[5:0]` — 6-bit input value
  - `line_pos[2:0]` — bit position to flip (valid: 0–5; 6–7 are no-ops)
  - `hex_out[5:0]` — `hex_in` XOR `(1 << line_pos)`
- **Type**: purely combinational (`always @(*)`, no clock)
- **Makefile targets**: `make lint-hex`, `make sim-hex`

**Verification log**:

```
2026-04-27  LINTED      verilator 5.032 — zero warnings
2026-04-27  SIMULATED   iverilog -g2001 + vvp
                        hex_in = 101010 (0x2A), all 6 positions tested
                        6/6 PASS — expected vs actual matched every case
```

**Pending**:
- [ ] Hardware test on Pi 5

---

### hex_two_node

- **File**: `hex_two_node.v`
- **Testbench**: `hex_two_node_tb.v`
- **State**: `SIMULATED`
- **Dependencies**: instantiates `hex_transition` (x2) — must be compiled together
- **Interface**:
  - `clk` — input clock
  - `rst_n` — active-low synchronous reset
  - `line_pos[2:0]` — bit position to flip (passed to both hex_transition instances)
  - `trigger` — assert high for one cycle to apply transition
  - `node_a[5:0]` — resets to `111111` (Hexagram 1, pure Yang)
  - `node_b[5:0]` — resets to `000000` (Hexagram 2, pure Yin)
- **Makefile targets**: `make lint-two`, `make sim-two`
- **Toolchain note**: `iverilog` compile must include `hex_transition.v hex_two_node.v hex_two_node_tb.v`; lint passes both design files to Verilator

**Verification log**:

```
2026-04-27  LINTED      verilator 5.032 — zero warnings
2026-04-27  SIMULATED   iverilog -g2001 + vvp
                        After reset:      node_a=111111  node_b=000000
                        After flip bit 0: node_a=111110  node_b=000001  ✓
                        After flip bit 3: node_a=110110  node_b=001001  ✓
                        After flip bit 5: node_a=010110  node_b=101001  ✓
```

**Testbench quirk**: inputs driven at negedge, outputs read at the following negedge.
Driving trigger at posedge and deasserting immediately in the same active region
causes iverilog to race and present the deasserted value to the DUT.

**Pending**:
- [ ] Hardware test on Pi 5

---

### hex_lut

- **File**: `hex_lut.v`
- **Testbench**: `hex_lut_tb.v`
- **State**: `SIMULATED`
- **Interface**:
  - `hex_binary[5:0]` — 6-bit line pattern (bit 5 = top line, bit 0 = bottom line)
  - `hex_number[6:0]` — hexagram number 1–64; `7'd0` for invalid input
- **Type**: purely combinational (`always @(*)`, no clock)
- **Source**: inverse of `HEXAGRAM_TO_BINARY_MAP` from `services.py`
- **Makefile targets**: `make lint-lut`, `make sim-lut`

**Verification log**:

```
2026-04-28  LINTED      verilator 5.032 — zero warnings
2026-04-28  SIMULATED   iverilog -g2001 + vvp
                        15 checks: required (111111→1, 000000→2, 101010→64)
                        + spot-checks hex 3,10,17,24,28,32,37,44,51,57,62,63
                        15/15 PASS ✓
```

**Pending**:
- [ ] Hardware test on Pi 5

---

## Task Log

<!-- Append tasks here as they are completed. Format: DATE | ACTION | OUTCOME -->

| Date | Action | Outcome |
|------|--------|---------|
| 2026-04-27 | Create `led_blink.v` | Done — parameterised counter, active-low sync reset |
| 2026-04-27 | Create `led_blink_tb.v` | Done — Verilog-2001, registered edge detection (no `$past`) |
| 2026-04-27 | Create `Makefile` | Done — `lint`, `sim`, `clean` targets |
| 2026-04-27 | Lint `led_blink.v` | PASS — zero Verilator warnings |
| 2026-04-27 | Simulate `led_blink` | PASS — 25 correct edges, `$finish` clean |
| 2026-04-27 | Create `hex_transition.v` | Done — combinational XOR, case statement, default no-op |
| 2026-04-27 | Create `hex_transition_tb.v` | Done — self-checking, all 6 positions, PASS/FAIL per case |
| 2026-04-27 | Update `Makefile` | Done — added `lint-hex`, `sim-hex`, `lint-all`, `sim-all` |
| 2026-04-27 | Lint `hex_transition.v` | PASS — zero Verilator warnings |
| 2026-04-27 | Simulate `hex_transition` | PASS — 6/6 cases correct, `$finish` clean |
| 2026-04-27 | Create `hex_two_node.v` | Done — 2 nodes, 2 hex_transition instances, registered on trigger |
| 2026-04-27 | Create `hex_two_node_tb.v` | Done — negedge-driven stimulus, 3 transitions verified |
| 2026-04-27 | Update `Makefile` | Done — added `lint-two`, `sim-two`; updated `lint-all`, `sim-all` |
| 2026-04-27 | Lint `hex_two_node.v` | PASS — zero Verilator warnings |
| 2026-04-27 | Simulate `hex_two_node` | PASS — all 3 transitions correct, `$finish` clean |
| 2026-04-28 | Create `hex_lut.v` | Done — 64-entry combinational case LUT, 7-bit output, default 0 |
| 2026-04-28 | Create `hex_lut_tb.v` | Done — 15 checks (3 required + 12 spot-checks), self-checking |
| 2026-04-28 | Update `Makefile` | Done — added `lint-lut`, `sim-lut`; updated `lint-all`, `sim-all` |
| 2026-04-28 | Lint `hex_lut.v` | PASS — zero Verilator warnings |
| 2026-04-28 | Simulate `hex_lut` | PASS — 15/15 checks passed, `$finish` clean |

---

## Known Constraints and Gotchas

- `$past()` is SystemVerilog-only. `.v` testbenches must use a registered copy:
  `reg sig_prev; always @(posedge clk) sig_prev <= sig;`
- Verilator lints design files only — never pass `_tb.v` to `--lint-only`.
- `iverilog` requires `-g2001`; omitting it causes parse errors.
- Counter width in `led_blink.v` is hard-coded at 27 bits. If `HALF_PERIOD` exceeds
  `2^27 - 1 = 134 217 727`, widen the counter register before use.
- Default `HALF_PERIOD=62_500_000` is for 125 MHz hardware. Testbenches must override
  to a small value (e.g. 4) or simulation will not finish in reasonable time.
- In iverilog, driving a signal at posedge then deasserting it immediately in the same
  active region races with the DUT's always block. Drive inputs at negedge and read
  outputs at the following negedge to avoid this. (Affected: `hex_two_node_tb.v`.)
