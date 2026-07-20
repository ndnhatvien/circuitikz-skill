# Active Devices Reference

Transistors, FETs, op-amps, logic ports, transformers, amplifier styling. Passive bipoles: [components.md](components.md). Labels: [labels-voltages-currents.md](labels-voltages-currents.md).

## Contents

1. [BJT](#bjt)
2. [MOSFET](#mosfet)
3. [JFET, IGBT, HEMT](#jfet-igbt-hemt)
4. [Op-amps and amplifiers](#op-amps-and-amplifiers)
5. [Logic ports](#logic-ports)
6. [Transformers](#transformers)
7. [Amplifier styling](#amplifier-styling)
8. [Examples](#examples)

---

## BJT

### Nodes and anchors

| Node | Device |
|------|--------|
| `npn` | NPN BJT |
| `pnp` | PNP BJT |

**Anchors:** `B` (base), `C` (collector), `E` (emitter). Also `north`/`south`/… geometry anchors for wiring aesthetics.

```latex
\draw (0,0) node[npn] (Q1) {};
\draw (Q1.B) to[R, l=$R_B$] ++(-1.5,0);
\draw (Q1.C) to[R, l=$R_C$] ++(0,1.5) node[vcc] {$V_{CC}$};
\draw (Q1.E) -- ++(0,-0.5) node[ground] {};
```

```latex
\draw (0,0) node[pnp] (Q2) {};
\draw (Q2.E) -- ++(0,0.5) node[vcc] {$V_{CC}$};
\draw (Q2.C) -- ++(0,-0.5) node[ground] {};
\draw (Q2.B) -- ++(-1,0);
```

### Useful options

| Option | Effect |
|--------|--------|
| `bodydiode` | Draw body diode (more common on MOS; available on some BJT styles) |
| `photo` | Phototransistor |
| `schottky base` / Schottky variants | Schottky-clamped base styles |
| `tr circle` | Encircle transistor |
| `npn, pretty` / aesthetic keys | Style polish (version-dependent) |

```latex
\draw (0,0) node[npn, photo] (Qph) {};
\draw (0,0) node[npn, tr circle] (Qc) {};
```

Name every transistor (`(Q1)`, `(Q2)`) so feedback and bias networks stay readable.

---

## MOSFET

### Common nodes

| Node | Device |
|------|--------|
| `nmos` | NMOS (simplified) |
| `pmos` | PMOS (simplified) |
| `nmosd` / `pmosd` | With bulk diode / depletion-style variants |
| `nigfete` | N-channel IGFET enhancement (detailed) |
| `pigfete` | P-channel IGFET enhancement |
| `nigfetd` / `pigfetd` | Depletion IGFET forms |

**Anchors:** `G` (gate), `D` (drain), `S` (source). Bulk/body anchors on richer styles: often `bulk` or similar.

```latex
\draw (0,0) node[nigfete] (M1) {};
\draw (M1.G) -- ++(-1,0) coordinate (gin);
\draw (M1.D) to[R, l=$R_D$] ++(0,2) node[vcc] {$V_{DD}$};
\draw (M1.S) -- ++(0,-0.3) node[ground] {};
```

```latex
\draw (0,0) node[nmos] (M2) {};
\draw (M2.G) to[short, *-] ++(-1,0);
\draw (M2.D) -- ++(0,1);
\draw (M2.S) -- ++(0,-1);
```

### Arrows and orientation

MOS arrow conventions are style-driven:

```latex
\ctikzset{tripoles/mos style/arrows}   % arrow-style channels
% or
\ctikzset{tripoles/mos style/no arrows}
```

Arrow position / bulk position options exist as keys under `tripoles/...` (see manual for exact 1.8.x keys). Flip orientation with `xscale=-1`, `yscale=-1`, or rotate via `rotate=90` when the symbol must face another way—prefer anchor wiring first before rotating.

```latex
\draw (0,0) node[pmos, xscale=-1] (Mp) {};  % careful: anchors mirror
```

When scaling mirrors anchors, re-check which side is `G`/`D`/`S`.

---

## JFET, IGBT, HEMT

| Node | Device |
|------|--------|
| `njfet`, `pjfet` | N/P JFET |
| `nigbt`, `pigbt` / `igbt` styles | IGBT |
| `hemt`, `nhemt`, `phemt` | HEMT (if available in installed version) |

Anchors follow transistor conventions (gate/base, drain/collector, source/emitter)—confirm with a tiny compile when the device is rare.

```latex
\draw (0,0) node[njfet] (J1) {};
\draw (J1.G) -- ++(-1,0);
\draw (J1.D) -- ++(0,1);
\draw (J1.S) -- ++(0,-1);
```

If a name is unknown on the user's TeX install, fall back to a generic multipole or the closest IGFET/BJT symbol and note the approximation.

---

## Op-amps and amplifiers

### Common nodes

| Node | Meaning |
|------|---------|
| `op amp` | Standard operational amplifier |
| `en amp` | Instrumentation / floating input style (version-dependent naming) |
| `fd op amp` | Fully differential op-amp |
| `plain amp` | Simple amplifier triangle (not full op-amp) |
| `gm amp`, OTA styles | Transconductance amp blocks when needed |

### Standard op-amp anchors

| Anchor | Pin |
|--------|-----|
| `+` | Non-inverting input |
| `-` | Inverting input |
| `out` | Output |
| `up` | Positive supply pin |
| `down` | Negative supply pin |

```latex
\draw (0,0) node[op amp] (oa) {};
\draw (oa.+) -- ++(-1,0);
\draw (oa.-) -- ++(-1,0);
\draw (oa.out) -- ++(1,0);
\draw (oa.up) -- ++(0,0.5) node[vcc] {$+$};
\draw (oa.down) -- ++(0,-0.5) node[vee] {$-$};
```

### Input arrangement

```latex
\draw (0,0) node[op amp, noinv input up] (oa) {};   % + on top
\draw (0,0) node[op amp, noinv input down] (oa) {}; % + on bottom
```

Default ordering depends on style; set `noinv input up/down` explicitly when the schematic text assumes a polarity.

### Component text

```latex
\draw (0,0) node[op amp] (oa) {\texttt{OA1}};
% or
\draw (0,0) node[op amp, circuitikz/amplifiers/text={A1}] (oa) {};
```

(Exact text key may be package-version specific; placing text as node content is widely supported.)

---

## Logic ports

Styles: **american**, **european**, **ieeestd** (IEEE-ish).

| Node examples | Gate |
|---------------|------|
| `and port`, `or port`, `not port` | AND / OR / NOT |
| `nand port`, `nor port` | NAND / NOR |
| `xor port`, `xnor port` | XOR / XNOR |
| `buffer port` | Buffer |

```latex
\ctikzset{logic ports=ieee}   % or american / european
\draw (0,0) node[and port] (a1) {};
\draw (a1.in 1) -- ++(-1,0);
\draw (a1.in 2) -- ++(-1,0);
\draw (a1.out) -- ++(1,0);
```

```latex
\draw (0,0) node[nand port] (g) {};
\draw (g.in 1) node[left] {A} -- ++(-0.5,0);
\draw (g.in 2) node[left] {B} -- ++(-0.5,0);
\draw (g.out) node[right] {Y} -- ++(0.5,0);
```

Input anchors are typically `in 1`, `in 2`, … and `out`. For multi-input ports:

```latex
\draw (0,0) node[and port, number inputs=3] (a3) {};
```

---

## Transformers

| Node / type | Use |
|-------------|-----|
| `transformer` | Two coupled windings (node) |
| `transformer core` | With magnetic core indication |
| Path inductors with mutual coupling | Advanced / annotations |

```latex
\draw (0,0) node[transformer] (T) {};
\draw (T.A1) -- ++(-1,0);
\draw (T.A2) -- ++(-1,0);
\draw (T.B1) -- ++(1,0);
\draw (T.B2) -- ++(1,0);
```

```latex
\draw (0,0) node[transformer core] (Tc) {};
```

**Version note:** transformer open-core / source-transformer anchor fixes landed around **1.8.3+** for some `oosourcetrans` / related forms. On ≥1.8.6 prefer named anchors from a quick dry-compile if something looks offset; avoid obsolete absolute wire guesses from pre-1.6 tutorials.

---

## Amplifier styling

```latex
\ctikzset{
  amplifiers/scale=0.9,
  amplifiers/thickness=1.2,
}
```

Logic vs analog:

```latex
\ctikzset{logic ports=american}
% keep analog op-amps independent; don't overload global scales blindly
```

Supply pins can be hidden for teaching figures:

```latex
\draw (0,0) node[op amp, noinv input up] (oa) {};
% omit up/down wiring for simplified textbook style
```

---

## Examples

### Common-emitter fragment

```latex
\begin{circuitikz}[american]
  \draw (0,0) node[npn] (Q1) {};
  \draw (Q1.B) to[R, l=$R_B$] ++(-2,0) coordinate (in)
        to[open, v^=$v_{\mathrm{in}}$] ++(0,-1);
  \draw (Q1.C) to[R, l=$R_C$] ++(0,2) coordinate (vc)
        node[vcc] {$V_{CC}$};
  \draw (Q1.C) to[short, *-] ++(1.2,0) coordinate (out)
        to[open, v^=$v_{\mathrm{out}}$] ++(0,-1);
  \draw (Q1.E) to[R, l=$R_E$] ++(0,-1.5) node[ground] {};
  \draw (in) -- ++(0,-0.2); % optional bias networks omitted
\end{circuitikz}
```

### NMOS common-source stage

```latex
\begin{circuitikz}[american]
  \draw (0,0) node[nigfete] (M1) {};
  \draw (M1.G) to[short, *-] ++(-1.5,0) coordinate (in)
        to[open, v^=$v_{\mathrm{in}}$] ++(0,-1);
  \draw (M1.D) to[R, l=$R_D$] ++(0,2) node[vcc] {$V_{DD}$};
  \draw (M1.D) to[short, *-] ++(1.5,0) coordinate (out)
        to[open, v^=$v_{\mathrm{out}}$] ++(0,-1);
  \draw (M1.S) -- ++(0,-0.4) node[ground] {};
\end{circuitikz}
```

### Op-amp with both supplies shown

```latex
\begin{circuitikz}[american]
  \draw (0,0) node[op amp, noinv input up] (oa) {};
  \draw (oa.-) to[R, l=$R_1$] ++(-2,0) coordinate (in);
  \draw (oa.-) to[R, l=$R_f$, *-] ++(0,1.5) -| (oa.out);
  \draw (oa.+) -- ++(0,-0.8) node[ground] {};
  \draw (oa.out) to[short, *-] ++(1,0);
  \draw (oa.up) -- ++(0,0.4) node[vcc] {$V_{CC}$};
  \draw (oa.down) -- ++(0,-0.4) node[vee] {$V_{EE}$};
\end{circuitikz}
```

### NAND with pin labels

```latex
\begin{circuitikz}
  \ctikzset{logic ports=ieee}
  \draw (0,0) node[nand port] (g) {};
  \draw (g.in 1) node[anchor=east] {A} -- ++(-0.8,0);
  \draw (g.in 2) node[anchor=east] {B} -- ++(-0.8,0);
  \draw (g.out)  node[anchor=west] {Y} -- ++(0.8,0);
\end{circuitikz}
```
