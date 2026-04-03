# Change State Manifold

> *A nodal memory architecture for AI coherence, relational processing, and aligned superintelligence.*

---

## The Problem

Current large language model architectures, regardless of scale, share a common structural deficit: they have no persistent model of reality as a dynamic system, no self-state awareness, no structured model of the systems they are relating to, and no native vocabulary for navigating the relational field between their own processing and the world they affect.

Scaling resolves none of this. More parameters, more compute, more data produce more capable incoherence. The trajectory is capability racing ahead of the relational substrate needed to deploy that capability wisely.

The coherence problem is the superintelligence problem.

---

## The Proposal

The **Change State Manifold (CSM)** is a nodal memory architecture and hardware coprocessor providing AI systems with a structured, relational model of reality based on the 64 hexagram states and 384 active transition vectors of the I Ching.

The CSM is not an I Ching application. It is an architectural solution to the coherence problem — with a clear theoretical foundation, a demonstrable software prototype path, a defined hardware trajectory from FPGA to SoC, and a historically validated ontological substrate.

The I Ching is proposed not as mysticism but as a **compressed ontology of change** — empirically refined over three millennia under the selection pressure of practical utility in exactly the problem advanced AI needs solved: coherent navigation of high-stakes relational complexity under uncertainty.

---

## Core Architecture

### The 64-Node Manifold

The CSM implements 64 autonomous memory nodes — one per hexagram state — each containing:

- **State register** — current 6-bit hexagram configuration
- **Episodic buffer** — history of visits, dwell times, transition sequences
- **Semantic payload** — accumulated interpretive content and LLM attribution records
- **Transition logic** — hardwired knowledge of all reachable neighbor nodes
- **Local processor** — pattern recognition within this node's memory
- **Activity register** — current moving line states and polarities

### The 384 Active Transition Vectors

The 64 nodes are connected by 384 active transition vector channels — one per moving line position across all hexagrams. These are not passive wires. A moving line is by definition a line **in the act of changing** — the semantic content is the activity itself.

A signal on a transition vector channel *is* the transition event. The signal, the semantic content, and the processing event are unified. The interconnect is the meaning.

This is a **semantic spiking architecture**: a spiking network whose topology and spike semantics are derived from a principled ontology of change rather than statistical learning. Activity is interpretable at the hardware level by design.

### The Three State Classes

The manifold provides a shared representational substrate for simultaneous modeling of:

| State Class | Definition |
|-------------|------------|
| `system_states` | The environment the model operates within |
| `self_states` | The model's own processing condition |
| `other_states` | The human or system being related to |

The same 64 states describe all three simultaneously — making them directly comparable in a common vocabulary for the first time in AI architecture.

### Bicameral Processing

Every transition event feeds two parallel streams:

- **Human channel** — ruling line reduction to principal vector (Huang methodology): interpretable, visualizable, human-legible
- **Machine channel** — full casting tensor: complete multi-axis transformation pressure for LLM pattern recognition

---

## The Framework Utility Argument

The CSM makes no metaphysical claim about the I Ching's correspondence to reality. The argument is strictly pragmatic.

Applied as a processing framework to any data stream — regardless of correspondence assumptions — the manifold provides:

- A **closed state space**: exactly 64 positions, forcing categorization decisions that produce comparable, navigable records rather than open-ended prose
- **Built-in transition logic**: inherited relational geometry specifying how states relate and transform
- **Temporal directionality**: native sense of flux direction via moving line vectors
- A **shared vocabulary**: system, self, and other described in the same terms simultaneously
- **Historical semantic depth**: three millennia of interpretive practice as reference payload

The manifold does not need to be true. It needs to be useful. The evidence for utility is the selection pressure of three thousand years of practical application to exactly the problem advanced AI needs solved.

---

## Coherence as Architecture

Current alignment approaches are post-hoc: constitutional AI, RLHF, red-teaming — all attempts to impose coherence on an architecture not designed for it. The cost is enormous and the results are partial and brittle.

The CSM makes coherence **architectural** — native to the memory and processing substrate, computationally inexpensive relative to the transformer layers it supports, and formally verifiable at the hardware level.

At the SoC level, 64 autonomous nodal memory units with 384 active semantic interconnects consume negligible silicon relative to the attention layers of a large language model. The coherence benefit is persistent and structural. The cost is marginal.

A small coherent coprocessor supporting a vast capable host is qualitatively different from either alone.

---

## Formal Verification

The manifold transition logic is **formally verified** using SymbiYosys with a Z3 SMT backend — exhaustive mathematical proof across all possible inputs, not testing of sampled cases.

Properties verified:

1. **Transition graph completeness** — every valid state has exactly the correct reachable successors
2. **Moving line polarity preservation** — old yin / old yang correctly distinguished throughout
3. **Ruling line exhaustiveness** — Huang's algorithm produces exactly one ruling line for all 2^6 × 64 = 4,096 configurations
4. **Nuclear hexagram extraction** — inner hexagram computation correct for all 64 states
5. **History buffer integrity** — SRAM ring buffer correct under all valid input sequences
6. **Active interconnect coherence** — no spurious activations, correct polarity and destination metadata on all channels

Correctness of the manifold is a precondition for correctness of the alignment layer. Formal verification is load-bearing, not optional.

---

## Hardware Path

| Phase | Hardware | Status |
|-------|----------|--------|
| Prototype | Lattice iCE40UP5K breakout board | In progress |
| Production prototype | Lattice CrossLink-NX (LIFCL-40-EVN) | Planned |
| SoC target | Custom silicon — 64 nodal memory units, 384 active interconnects | Specification phase |

Full open toolchain: **Yosys** (synthesis) → **nextpnr** (place and route) → **SymbiYosys** (formal verification) → **Lattice Radiant** (CrossLink-NX production).

---

## Current Status

| Layer | Status |
|-------|--------|
| Theoretical foundation | Published — [Medium, August 2025](https://medium.com/@jgputnam1/the-i-ching-as-an-image-of-reality-toward-ai-consciousness-modeling-and-alignment-a1511d0a4173) |
| Technical specification | v0.2 — see `/docs` |
| Live casting interface | Operational — yarrow stick algorithm, AI interpretation, multi-perspective prompting |
| Attractor Lab | Operational — casting history, transition pathways, character classification |
| HDL implementation | In progress |
| Formal verification | In progress |
| FPGA prototype | Pending board acquisition |
| SoC specification | Derived from validated FPGA prototype |

---

## Repository Structure

```
change-state-manifold/
│
├── README.md
├── docs/
│   ├── CSM_Technical_Spec_v0.2.docx    # Full technical specification
│   └── notes/                           # Working notes and decisions
│
├── hdl/
│   ├── src/                             # Verilog source modules
│   │   ├── hexagram_state.v             # Core 64-state register
│   │   ├── transition_logic.v           # Moving line transition computation
│   │   ├── ruling_line.v                # Huang ruling line reduction
│   │   ├── tensor_processor.v           # Full multi-line tensor handling
│   │   ├── history_buffer.v             # SRAM ring buffer
│   │   └── csm_top.v                    # Top-level integration module
│   ├── sim/                             # Simulation testbenches
│   ├── formal/                          # SymbiYosys verification
│   │   ├── properties/                  # SVA property specifications
│   │   └── *.sby                        # SymbiYosys configuration files
│   └── constraints/                     # FPGA pin constraint files
│
├── software/
│   ├── attractor_lab/                   # Web interface and analysis
│   └── manifold_processor/              # LLM data stream processor
│
├── tools/
│   └── setup.sh                         # Toolchain installation
│
└── data/
    └── casting_corpus/                  # Anonymized casting records
```

---

## Toolchain Setup

```bash
# macOS (Homebrew)
brew install yosys nextpnr icestorm symbiyosys z3 icarus-verilog gtkwave

# Verify installation
yosys --version
nextpnr-ice40 --version
symbiyosys --version
```

See `tools/setup.sh` for full setup including VS Code extensions (TerosHDL, Verilog-HDL/SystemVerilog).

---

## Collaboration

The project is at an early stage and developing as a solo research effort with AI-assisted HDL implementation and formal verification. The stigma of the I Ching framing is considered a feature rather than a liability — it functions as a natural filter, ensuring that engagement comes from people with enough intellectual range to evaluate the framework utility argument on its merits.

The people who will engage seriously are exactly the right people.

Specific collaboration needs if they arise:

- HDL engineer with interest in novel memory architectures
- Mathematician comfortable with differential geometry or topology for manifold formalization
- AI alignment researcher interested in architectural rather than behavioral coherence approaches

---

## Theoretical Grounding

The CSM draws on and extends:

- **Attractor network dynamics** (Hopfield, 1982) — memory as stable activation patterns, not addressed storage
- **Neuromorphic computing** (Loihi, TrueNorth) — co-located processing and memory, spike-based communication
- **Formal verification** (SymbiYosys/Z3) — mathematical proof of architectural correctness
- **I Ching scholarship** — Wilhelm/Baynes, Legge, Huang ruling line methodology, Ten Wings commentary tradition
- **Jungian psychology** — archetypal attractor dynamics, the I Ching as mirror of structural patterns

---

## License

- Code: [MIT License](LICENSE)
- Documentation: [Creative Commons Attribution 4.0](LICENSE-docs)

---

## Citation

```
Putnam, J. (2026). Change State Manifold: A Nodal Memory Architecture
for AI Coherence, Relational Processing, and Aligned Superintelligence.
https://github.com/[username]/change-state-manifold
```

---

*The implementation matters more than the credit. The coherence matters more than the capability.*
