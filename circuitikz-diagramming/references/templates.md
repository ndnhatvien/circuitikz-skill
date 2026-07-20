# CircuiTikZ Templates

Ready-to-paste circuits. All use **american** style and assume **RPvoltages** in the preamble:

```latex
\usepackage[RPvoltages, american]{circuitikz}
```

Relative placement throughout. Load device details from [components.md](components.md) / [active-devices.md](active-devices.md) only if you need to customize.

## Contents

1. [Voltage divider](#1-voltage-divider)
2. [Series RLC with AC source](#2-series-rlc-with-ac-source)
3. [Half-wave rectifier](#3-half-wave-rectifier)
4. [Non-inverting op-amp](#4-non-inverting-op-amp)
5. [Inverting op-amp](#5-inverting-op-amp)
6. [Common-emitter BJT amp](#6-common-emitter-bjt-amp-simplified)
7. [NMOS common-source stage](#7-nmos-common-source-stage-simplified)
8. [RC low-pass filter](#8-rc-low-pass-filter)
9. [Full-wave bridge rectifier](#9-full-wave-bridge-rectifier)
10. [NAND gate with labeled pins](#10-nand-gate-with-labeled-pins)

---

## 1. Voltage divider

**When:** Bias networks, reference dividers, sensor scaling.

```latex
\begin{circuitikz}[american]
  \draw (0,0) node[ground] {}
    to[V, v=$V_{\mathrm{in}}$] ++(0,3) coordinate (top)
    to[R, l=$R_1$, *-*] ++(0,-1.5) coordinate (mid)
    to[R, l=$R_2$] ++(0,-1.5) node[ground] {};
  \draw (mid) to[short, *-o] ++(1.5,0) node[right] {$v_{\mathrm{out}}$};
\end{circuitikz}
```

---

## 2. Series RLC with AC source

**When:** Resonance demos, second-order transient/circuit courses.

```latex
\begin{circuitikz}[american]
  \draw (0,0) coordinate (g)
    to[sV, v=$v_s(t)$] ++(0,2)
    to[R, l=$R$, i>=$i$] ++(2,0)
    to[L, l=$L$] ++(2,0)
    to[C, l=$C$, v=$v_C$, *-*] ++(0,-2)
    -- (g);
\end{circuitikz}
```

---

## 3. Half-wave rectifier

**When:** Intro AC–DC, single-diode peak / filter stages.

```latex
\begin{circuitikz}[american]
  \draw (0,0) node[ground] {}
    to[sV, v=$v_s$] ++(0,2)
    to[D, l=$D$] ++(2,0) coordinate (cath)
    to[R, l=$R_L$, *-*] ++(0,-2) node[ground] {};
  \draw (cath) to[C, l=$C$, *-] ++(1.5,0) -- ++(0,-2) node[ground] {};
  \draw (cath) to[short, *-o] ++(2.5,0) node[right] {$v_{\mathrm{out}}$};
\end{circuitikz}
```

---

## 4. Non-inverting op-amp

**When:** Buffer with gain, sensor front-ends (`G = 1 + R_2/R_1`).

```latex
\begin{circuitikz}[american]
  \draw (0,0) node[op amp, noinv input up] (oa) {};
  % input on +
  \draw (oa.+) to[short, *-] ++(-1.2,0) coordinate (inp)
    to[open, v^=$v_{\mathrm{in}}$] ++(0,-1);
  % feedback divider on -
  \draw (oa.-) -- ++(0,-1) coordinate (fb)
    to[R, l_=$R_1$] ++(0,-1.5) node[ground] {};
  \draw (fb) to[R, l=$R_2$] (fb -| oa.out) -- (oa.out);
  % output
  \draw (oa.out) to[short, *-] ++(1.2,0) coordinate (outp)
    to[open, v^=$v_{\mathrm{out}}$] ++(0,-1);
\end{circuitikz}
```

---

## 5. Inverting op-amp

**When:** Classic inverter `G = -R_f/R_in`, summing junctions (extend with extra input R).

```latex
\begin{circuitikz}[american]
  \draw (0,0) node[op amp, noinv input up] (oa) {};
  \draw (oa.+) -- ++(0,-0.8) node[ground] {};
  \draw (oa.-) to[R, l_=$R_{\mathrm{in}}$, *-] ++(-2,0) coordinate (inp)
    to[open, v^=$v_{\mathrm{in}}$] ++(0,-1);
  \draw (oa.-) to[R, l=$R_f$] ++(0,1.4) -| (oa.out);
  \draw (oa.out) to[short, *-] ++(1.2,0) coordinate (outp)
    to[open, v^=$v_{\mathrm{out}}$] ++(0,-1);
\end{circuitikz}
```

---

## 6. Common-emitter BJT amp (simplified)

**When:** Teaching gain stage without full bias network (add divider as needed).

```latex
\begin{circuitikz}[american]
  \draw (0,0) node[npn] (Q1) {};
  \draw (Q1.B) to[C, l=$C_{\mathrm{in}}$, *-] ++(-1.5,0)
    to[short, -o] ++(-0.8,0) node[left] {$v_{\mathrm{in}}$};
  \draw (Q1.B) to[R, l_=$R_B$] ++(0,-1.8) node[ground] {};
  \draw (Q1.C) to[R, l=$R_C$] ++(0,2) node[vcc] {$V_{CC}$};
  \draw (Q1.C) to[C, l=$C_{\mathrm{out}}$, *-] ++(1.6,0)
    to[short, -o] ++(0.8,0) node[right] {$v_{\mathrm{out}}$};
  \draw (Q1.E) to[R, l=$R_E$] ++(0,-1.5) node[ground] {};
\end{circuitikz}
```

---

## 7. NMOS common-source stage (simplified)

**When:** MOSFET small-signal intro; CS amp with resistive load.

```latex
\begin{circuitikz}[american]
  \draw (0,0) node[nigfete] (M1) {};
  \draw (M1.G) to[short, *-o] ++(-1.5,0) node[left] {$v_{\mathrm{in}}$};
  \draw (M1.D) to[R, l=$R_D$] ++(0,2) node[vcc] {$V_{DD}$};
  \draw (M1.D) to[short, *-o] ++(1.5,0) node[right] {$v_{\mathrm{out}}$};
  \draw (M1.S) -- ++(0,-0.5) node[ground] {};
\end{circuitikz}
```

Alternate compact MOSFET symbol: replace `nigfete` with `nmos` if preferred.

---

## 8. RC low-pass filter

**When:** First-order LPF Bode intros, anti-alias poles, simple sensor filters.

```latex
\begin{circuitikz}[american]
  \draw (0,0) node[left] {$v_{\mathrm{in}}$}
    to[short, o-] ++(0.5,0)
    to[R, l=$R$] ++(2,0) coordinate (out)
    to[C, l=$C$, *-*] ++(0,-2) node[ground] {};
  \draw (out) to[short, *-o] ++(1.2,0) node[right] {$v_{\mathrm{out}}$};
\end{circuitikz}
```

High-pass: swap R and C positions (series C, shunt R to ground).

---

## 9. Full-wave bridge rectifier

**When:** Bridge supply teaching; four-diode AC–DC.

```latex
\begin{circuitikz}[american]
  % AC terminals
  \draw (0,1.5) coordinate (ac+) to[sV, v=$v_s$, invert] (0,-1.5) coordinate (ac-);
  % bridge
  \draw (ac+) to[D, l_=$D_1$] ++(2,1.5) coordinate (dc+);
  \draw (ac-) to[D, l^=$D_2$] ++(2,-1.5) coordinate (dc-);
  \draw (ac+) to[D, l^=$D_3$] (dc-);
  \draw (ac-) to[D, l_=$D_4$] (dc+);
  % load
  \draw (dc+) to[R, l=$R_L$, v=$v_{\mathrm{out}}$, *-*] (dc-);
  \draw (dc-) node[circ] {} -- ++(0,-0.3) node[ground] {};
\end{circuitikz}
```

If diode orientations look wrong for your path directions, flip individual path endpoints or use `invert` on specific diodes—topology above is a starting layout; verify +/− of `v_{\mathrm{out}}` under `RPvoltages`.

---

## 10. NAND gate with labeled pins

**When:** Digital labs, combinational logic figures, IEEE/american gate style demos.

```latex
\begin{circuitikz}
  \ctikzset{logic ports=ieee}
  \draw (0,0) node[nand port] (g) {\small NAND};
  \draw (g.in 1) node[anchor=east] {A} -- ++(-1,0)
    node[left, ocirc] {};
  \draw (g.in 2) node[anchor=east] {B} -- ++(-1,0)
    node[left, ocirc] {};
  \draw (g.out) node[anchor=west] {Y} -- ++(1,0)
    node[right, ocirc] {};
\end{circuitikz}
```

For american/european shapes:

```latex
\ctikzset{logic ports=american} % or european
```

---

## Usage notes

- Paste templates inside a document that already loads `circuitikz` with `RPvoltages`.
- Scale with `\ctikzset{bipoles/length=1.2cm}` rather than `\scalebox` first.
- Extend bias networks / extra stages by chaining more `to[...]` from named coordinates.
- More annotation rules: [labels-voltages-currents.md](labels-voltages-currents.md).
- Compile failures: [troubleshooting.md](troubleshooting.md).
