# Makefile — Icarus Verilog simulation
# Commands follow AGENTS.md conventions.
# Simulation output is always ds_sim.vvp (overwritten per run).

SIM_OUT = ds_sim.vvp

.PHONY: all lint sim lint-hex sim-hex lint-two sim-two lint-lut sim-lut lint-csm sim-csm lint-all sim-all clean

all: sim-all

# ── led_blink ────────────────────────────────────────────────────────
lint:
	verilator --lint-only -Wall led_blink.v

sim: led_blink.v led_blink_tb.v
	iverilog -g2001 -o $(SIM_OUT) led_blink.v led_blink_tb.v
	vvp $(SIM_OUT)

# ── hex_transition ───────────────────────────────────────────────────
lint-hex:
	verilator --lint-only -Wall hex_transition.v

sim-hex: hex_transition.v hex_transition_tb.v
	iverilog -g2001 -o $(SIM_OUT) hex_transition.v hex_transition_tb.v
	vvp $(SIM_OUT)

# ── hex_two_node (depends on hex_transition) ─────────────────────────
lint-two:
	verilator --lint-only -Wall hex_transition.v hex_two_node.v

sim-two: hex_transition.v hex_two_node.v hex_two_node_tb.v
	iverilog -g2001 -o $(SIM_OUT) hex_transition.v hex_two_node.v hex_two_node_tb.v
	vvp $(SIM_OUT)

# ── hex_lut ──────────────────────────────────────────────────────────
lint-lut:
	verilator --lint-only -Wall hex_lut.v

sim-lut: hex_lut.v hex_lut_tb.v
	iverilog -g2001 -o $(SIM_OUT) hex_lut.v hex_lut_tb.v
	vvp $(SIM_OUT)

# ── hex_csm_node (depends on hex_transition, hex_two_node, hex_lut) ──
lint-csm:
	verilator --lint-only -Wall hex_transition.v hex_two_node.v hex_lut.v hex_csm_node.v

sim-csm: hex_transition.v hex_two_node.v hex_lut.v hex_csm_node.v hex_csm_node_tb.v
	iverilog -g2001 -o $(SIM_OUT) \
	    hex_transition.v hex_two_node.v hex_lut.v \
	    hex_csm_node.v hex_csm_node_tb.v
	vvp $(SIM_OUT)

# ── all modules ──────────────────────────────────────────────────────
lint-all: lint lint-hex lint-two lint-lut lint-csm

sim-all: sim sim-hex sim-two sim-lut sim-csm

# ── housekeeping ─────────────────────────────────────────────────────
clean:
	rm -f $(SIM_OUT)
