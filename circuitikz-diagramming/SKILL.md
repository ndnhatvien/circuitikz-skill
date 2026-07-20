---
name: circuitikz-diagramming
description: Generate publication-quality electronic circuit diagrams with CircuiTikZ (LaTeX/TikZ). Use when drawing, fixing, or explaining circuits in LaTeX—resistors, capacitors, transistors, op-amps, logic gates, sources, labels/voltages/currents—or when the user mentions circuitikz, CircuiTikZ, TikZ circuits, schematic figures for papers, or wants Overleaf/TikZJax-ready circuit code. Targets CircuiTikZ 1.8.x (stable 1.8.6+).
---

# CircuiTikZ Diagramming

Generate clean, publication-ready electronic circuit schematics with **CircuiTikZ** (TikZ package for circuits).

**Target version:** CircuiTikZ **1.8.6+** (stable; master may be 1.8.7-unreleased). Prefer constructs stable since 1.6+.

**Visual helper:** [CircuiTikZ-Designer](https://github.com/Circuit2TikZ/CircuiTikZ-Designer) — GUI that exports clean CircuiTikZ; useful for complex layouts, then refine labels by hand.

Load detailed references only when needed (see table below). Keep output minimal: a compilable `circuitikz` fragment unless the user asks for a full document.

## Workflow

1. **Clarify the circuit** — components, topology, signal flow, which labels/voltages/currents matter.
2. **Pick a style once** — `american` or `european`; always set `RPvoltages` for new work.
3. **Place with relative coords** — start at origin, chain with `--` and `++(dx,dy)`; name key nodes.
4. **Connect with path bipoles and node multipoles** — never mix absolute wanders when a relative step works.
5. **Add labels, v, i** — after topology is correct; brace labels that contain `=` or `,`.
6. **Self-check** — compile mentally against the quality checklist; fix anti-patterns.
7. **Deliver** — fragment for papers/Overleaf, or standalone / TikZJax wrapper if requested.

## References (progressive disclosure)

| File | Load when… |
|------|------------|
| [references/components.md](references/components.md) | Choosing bipole types (R/C/L, sources, diodes, grounds, RF blocks, meters) |
| [references/active-devices.md](references/active-devices.md) | BJT, MOSFET, JFET, op-amps, logic ports, transformers |
| [references/labels-voltages-currents.md](references/labels-voltages-currents.md) | Labels, annotations, voltage/current arrows, poles, `name=`, invert/mirror |
| [references/templates.md](references/templates.md) | Ready-to-paste full circuits (dividers, filters, amps, logic) |
| [references/troubleshooting.md](references/troubleshooting.md) | Parse errors, wrong arrows, missing anchors, scaling, TikZJax limits |

## Document skeleton

### Fragment (papers / include)

```latex
\begin{circuitikz}[american, voltage shift=0.5]
  % circuit here
\end{circuitikz}
```

### Standalone document

```latex
\documentclass[border=2mm]{standalone}
\usepackage[RPvoltages, american]{circuitikz}
\begin{document}
\begin{circuitikz}
  % circuit here
\end{circuitikz}
\end{document}
```

### TikZJax-ready body

Ship only the `circuitikz` environment (plus any `\ctikzset{...}`). Host must load circuitikz; avoid exotic fonts/packages. Prefer simple colors; some hosts mishandle color mixing.

Global package options (once, in preamble):

```latex
\usepackage[RPvoltages, american, siunitx]{circuitikz}
% or european instead of american
```

## Core syntax model

### Path-style bipoles (two-terminal)

Drawn on a TikZ path with `to[type, options]`:

```latex
\draw (0,0) to[R, l=$R_1$, v=$v_R$, i=$i$] (2,0);
\draw (0,0) to[C, l=$C$] ++(0,-2) to[L, l=$L$] ++(2,0);
```

Common types: `R`, `C`, `L`, `D`, `short`, `open`, `battery1`, `V`, `I`, `sV`, `sI`, …

### Node-style multipoles (transistors, op-amps, logic)

Placed as TikZ nodes; connect their anchors:

```latex
\draw (0,0) node[op amp] (oa) {};
\draw (oa.-) to[R, l=$R_1$] ++(-2,0);
\draw (oa.out) to[short, *-] ++(1,0);
```

```latex
\draw (0,0) node[nigfete] (m1) {};
\draw (m1.G) -- ++(-1,0);
\draw (m1.D) to[R, l=$R_D$] ++(0,2) node[vcc] {$V_{DD}$};
\draw (m1.S) -- ++(0,-0.5) node[ground] {};
```

**Rule:** bipoles = path `to[...]`; transistors/op-amps/gates = `node[...]` with named anchors.

## Coordinates that scale

Prefer relative and named geometry over hard-coded absolute points:

```latex
% Relative steps
\draw (0,0) to[V, v=$v_s$] ++(0,2)
             to[R, l=$R$] ++(2,0)
             to[C, l=$C$, *-] ++(0,-2)
             -- (0,0);

% Named coordinates
\draw (0,2) coordinate (in) to[R] (2,2) coordinate (mid)
      to[C] (2,0) node[ground] {};

% Orthogonal intersection (A|-B = x of A, y of B)
\draw (out) |- (mid);   % horizontal then vertical
\draw (a) -| (b);       % vertical then horizontal
```

Use `++(dx,dy)` for chain layout; use `+(dx,dy)` when you need a temporary offset without moving the path current point (know the difference—see troubleshooting).

## Labels / voltages / currents (cheat sheet)

| Key | Meaning | Example |
|-----|---------|---------|
| `l=` | Label (name of component) | `to[R, l=$R_1$]` |
| `a=` | Annotation (other side) | `to[R, a=$1\,\mathrm{k}\Omega$]` |
| `l_=` / `l^=` | Force label below/above | `l_=$R$` |
| `v=` | Voltage across bipole | `v=$v_C$` |
| `i=` | Current through bipole | `i=$i_L$` |
| `i_>` / `i^>` / `i_<` / `i^<` | Current position & direction | `i_>=$i$` |
| `type=text` | Shortcut label (passives) | `to[R=$R_1$]` ≡ `to[R, l=$R_1$]` |
| Active sources `=` | Sets **v** or **i**, not `l` | `to[V=$v_s$]` |
| `*-`, `-*, `o-*`, `*-o` | Connection poles | `to[R, *-o]` |
| `name=foo` | Name bipole for anchors | `to[R, name=R1]` → `(R1.n/s/…)` |

**Brace labels** that contain `=` or `,`:

```latex
to[R, l={$R=1\,\mathrm{k}\Omega$}]
to[C, l={$C_1,\,C_2$}]
```

Stacked:

```latex
to[R, l2=$R_1$ and $1\,\mathrm{k}\Omega$]
```

Details: [references/labels-voltages-currents.md](references/labels-voltages-currents.md).

## Style conventions

Set once near the top of the figure or in the preamble:

```latex
\ctikzset{
  bipoles/length=1.4cm,
  resistors/scale=0.8,
  capacitors/scale=0.8,
  sources/scale=0.9,
  amplifiers/scale=0.9,
}
```

Common package options:

- `american` / `european` — resistor and source symbols
- `RPvoltages` — recommended voltage arrow convention (new work)
- `siunitx` — allows `l=1<\kilo\ohm>` style labels when `siunitx` is loaded

Prefer a **single** style family per figure. Do not mix `american` resistors with ad-hoc European source symbols unless intentional.

## Component quick map

| Need | Path type / node | Notes |
|------|------------------|-------|
| Resistor | `R` or `resistor` | Prefer `R` |
| Capacitor | `C` | `ecapacitor` polar; `cC` curved |
| Inductor | `L` | style depends on american/cute/european |
| DC battery | `battery1`, `battery2` | |
| Independent V / I | `V`, `I` | or `vsource`, `isource` |
| Sinusoidal V / I | `sV`, `sI` | |
| Diode / LED / Zener | `D`, `led`, `zD` | |
| Ground / rail | `ground`, `tlground`, `vcc`, `vee` | nodes on a path end |
| Wire / open / pole | `short`, `open`, `circ` | `ocirc` open pole |
| Op-amp | `node[op amp]` | anchors `+`, `-`, `out` |
| BJT NPN/PNP | `node[npn]`, `node[pnp]` | `B`, `C`, `E` |
| NMOS / PMOS | `node[nmos]`, `node[pmos]` | or `nigfete` / `pigfete` |
| Logic AND/OR/… | `node[and port]`, … | american/european styles |

Full lists: [components.md](references/components.md), [active-devices.md](references/active-devices.md).

## Output formats

| Audience | Deliver |
|----------|---------|
| Paper / Overleaf include | `circuitikz` environment only (+ `\ctikzset` if needed) |
| Standalone compile | Full `standalone` document as above |
| TikZJax | Environment only; avoid rare packages |
| Editable seed | Mention Designer export if layout is very dense |

Default: **american + RPvoltages**, relative placement, math-mode labels (`$R_1$`).

## Quality checklist

- [ ] Compiles with `[RPvoltages, american]{circuitikz}` (or european if chosen)
- [ ] Topology matches the intended circuit (no floating nodes)
- [ ] Grounds/rails present where expected
- [ ] Labels braced if they contain `=` or `,`
- [ ] Voltage/current arrows oriented with the prose description
- [ ] Named nodes for multipoles; anchors used (not guessed line stubs)
- [ ] Consistent scale; no overlapping labels
- [ ] No absolute scatter of coordinates when a chain of `++` would do
- [ ] Minimal preamble in fragments

## Anti-patterns

| Avoid | Prefer |
|-------|--------|
| Absolute coords for every corner | Relative `++` + named coordinates |
| `l=R=1k` unbraced | `l={$R=1\,\mathrm{k}\Omega$}` |
| Default legacy voltages for new figures | Package option `RPvoltages` |
| Drawing multipoles with `to[npn]` | `node[npn] (Q1) {}` + anchors |
| Mixing `american`/`european` in one fig | One style throughout |
| `\scalebox` on whole circuit as first fix | `\ctikzset{bipoles/length=...}` / component scales |
| Labeling active source with `l=` only | `V=$v_s$` / `v=` / `i=` as appropriate |
| Hard-coded crossing lines | `crossing` / jump crossing styles, or re-route |

## Example: series RC

```latex
\begin{circuitikz}[american]
  \draw (0,0) to[V, v=$v_s$] ++(0,2)
               to[R, l=$R$, a=$1\,\mathrm{k}\Omega$] ++(2,0)
               to[C, l=$C$, v=$v_C$, *-*] ++(0,-2)
               -- (0,0);
\end{circuitikz}
```

## Example: non-inverting op-amp

```latex
\begin{circuitikz}[american]
  \draw (0,0) node[op amp, noinv input up] (oa) {};
  \draw (oa.+) to[short, *-] ++(-1,0) coordinate (in)
        to[open, v^=$v_{\mathrm{in}}$] ++(0,-1);
  \draw (oa.-) -- ++(0,-1) coordinate (fb)
        to[R, l_=$R_1$] ++(0,-1.5) node[ground] {};
  \draw (fb) to[R, l=$R_2$] (fb -| oa.out) -- (oa.out);
  \draw (oa.out) to[short, *-] ++(1,0) coordinate (out)
        to[open, v^=$v_{\mathrm{out}}$] ++(0,-1);
\end{circuitikz}
```

More complete circuits: [references/templates.md](references/templates.md).

## When stuck

1. Confirm **path vs node** for the component class.
2. Check label bracing and `RPvoltages` if arrows look wrong.
3. Consult [troubleshooting.md](references/troubleshooting.md).
4. For dense layouts, sketch in [CircuiTikZ-Designer](https://github.com/Circuit2TikZ/CircuiTikZ-Designer), export, then clean labels.
5. Fall back to official CircuiTikZ manual (component name tables) for rare devices.
