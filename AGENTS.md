# Verilog Project Rules for Raspberry Pi 5

## Context
- **Hardware**: Raspberry Pi 5 (aarch64), Debian 13 (trixie)
- **Language**: Verilog-2001 (`.v`) and SystemVerilog (`.sv`)
- **Simulation tools**: Icarus Verilog (`iverilog`/`vvp`), Verilator 5.032

## Tool Installation
Not pre-installed on a fresh system:
```
sudo apt install iverilog verilator
```

## Makefile Targets
```
make lint       # verilator --lint-only -Wall led_blink.v
make sim        # compile + run led_blink simulation
make lint-hex   # verilator --lint-only -Wall hex_transition.v
make sim-hex    # compile + run hex_transition simulation
make lint-two   # verilator --lint-only -Wall hex_transition.v hex_two_node.v  (BOTH required)
make sim-two    # compile + run hex_two_node simulation (includes hex_transition.v)
make lint-all   # all three lint targets in sequence
make sim-all    # all three sim targets in sequence (default: make all)
make clean      # remove ds_sim.vvp
```
All sim targets write to the **shared** `ds_sim.vvp` — each run overwrites it.

Direct commands when no Makefile exists:
- Lint: `verilator --lint-only -Wall <module>.v`
- Compile: `iverilog -g2001 -o ds_sim.vvp <module>.v <module>_tb.v`
- Run: `vvp ds_sim.vvp`
- Verilator sim: `verilator --binary --build -j 4 --top-module <top> <files>.v && ./obj_dir/V<top>`

## Coding Style
- **`.v` files (Verilog-2001)**: use `always @(posedge clk)` and `always @(*)` — NOT `always_ff`/`always_comb`.
- **`.sv` files (SystemVerilog)**: use `always_ff @(posedge clk)` and `always_comb`.
- `$past()` is SystemVerilog-only. In `.v` testbenches, use a registered copy for edge detection:
  ```verilog
  reg sig_prev;
  always @(posedge clk) sig_prev <= sig;
  ```
- **Submodule wires**: always declare all connection wires explicitly (with width) before the instantiation. Implicit net declarations cause Verilator warnings and can mask connection errors.

## Toolchain Quirks
- Verilator lints **design modules only** — do not pass testbench files to `--lint-only` (testbenches use constructs Verilator rejects).
- `lint-two` must pass **both** `hex_transition.v hex_two_node.v` — `hex_two_node` instantiates `hex_transition`, so Verilator needs both files to resolve the module reference.
- `sim-two` must also include `hex_transition.v` on the iverilog command line for the same reason.
- Icarus Verilog requires `-g2001` for Verilog-2001 files; omitting it causes parse errors on some syntax.
- Simulation output is hardcoded as `ds_sim.vvp` in the Makefile.
- Verilator binary output is always `./obj_dir/V<top>`.
- **iverilog active-region race**: driving a signal at `posedge clk` and deasserting it in the same timestep races with the DUT's `always @(posedge clk)` block — the DUT may see the deasserted value. Fix: drive inputs at `negedge clk` and read outputs at the next `negedge clk`.

## Testbench Conventions
- Every module `foo.v` must have a paired testbench `foo_tb.v`.
- Testbenches **override** slow `HALF_PERIOD` / timing parameters to small values so simulation finishes quickly.
- The default `HALF_PERIOD=62_500_000` in `led_blink.v` is for real 125 MHz hardware — always override in simulation.

## Project Structure
```
led_blink.v           — LED blink module (parameterised, active-low sync reset rst_n)
led_blink_tb.v        — testbench (HALF_PERIOD=4, 100 post-reset cycles)
hex_transition.v      — combinational bit-flip via XOR (no clock)
hex_transition_tb.v   — tests all 6 line positions against 101010
hex_two_node.v        — two registered hexagram nodes; instantiates hex_transition x2
hex_two_node_tb.v     — reset + 3 triggered transitions (negedge-driven stimulus)
Makefile              — lint/sim/clean; per-module targets: lint-hex, sim-hex, lint-two, sim-two
progress.md           — module state machine and verification log
```

`hex_two_node` reset values: `node_a=6'b111111` (pure Yang), `node_b=6'b000000` (pure Yin). The `trigger` input must be held high for exactly one clock cycle to apply a transition; it is not self-clearing.

`progress.md` is the append-only project log. Update it when a module advances state: `DESIGNED → LINTED → SIMULATED → HARDWARE_TESTED`. Record simulation results and known gotchas there.

Remote: `https://github.com/Jamesgp61/change-state-manifold.git` (branch `main`). A `.gitignore` is present covering `*.vvp`, `*.vcd`, `*.fst`, bitstreams, and OS/editor files.

## Hardware Notes
- GPIO access on Pi 5: `/dev/gpiomem` — no `sudo` required.
- Target clock: 125 MHz. Counter width must be ≥ log2(HALF_PERIOD) bits.
