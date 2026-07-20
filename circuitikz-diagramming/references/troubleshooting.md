# CircuiTikZ Troubleshooting

Symptom → cause → fix. Prefer these checks before rewriting an entire schematic.

## Contents

1. [Label parse errors](#1-label-parse-errors-with--or-)
2. [Wrong voltage arrow direction](#2-wrong-voltage-arrow-direction)
3. [Component not found / path vs node](#3-component-not-found--path-vs-node)
4. [Unknown anchor](#4-unknown-anchor)
5. [Poles drawing twice](#5-poles-drawing-twice)
6. [Scaling issues](#6-scaling-issues)
7. [Mixing styles](#7-mixing-styles)
8. [TikZ `to` / `+` / `++` quirks](#8-tikz-to--quirks)
9. [siunitx with stacked labels](#9-siunitx-with-stacked-labels)
10. [Externalize issues](#10-externalize-issues)
11. [TikZJax limitations](#11-tikzjax-limitations)
12. [Designer export differences](#12-designer-export-differences)

---

## 1. Label parse errors with `=` or `,`

| | |
|--|--|
| **Problem** | `Package pgfkeys Error: ...` / runaway argument near a bipole label |
| **Cause** | Unbraced `=` or `,` inside `l=`, `a=`, `v=`, `i=` values — keyval parser splits the option list |
| **Fix** | Brace the whole value |

```latex
% breaks
to[R, l=$R=1k$]
to[C, l=$C_1, C_2$]

% works
to[R, l={$R=1\,\mathrm{k}\Omega$}]
to[C, l={$C_1,\,C_2$}]
```

Also brace siunitx-ish content with commas.

---

## 2. Wrong voltage arrow direction

| | |
|--|--|
| **Problem** | Voltage arrow / polarity opposite to textbook or prose |
| **Cause** | Legacy voltage convention; or path direction opposite to intended +/−; or missing `RPvoltages` |
| **Fix** | Use `RPvoltages` for new work; reverse path ends or adjust `v`/`v_`/`v^` |

```latex
\usepackage[RPvoltages, american]{circuitikz}
```

| Convention | Guidance |
|------------|----------|
| `RPvoltages` | Prefer for new figures |
| `EFvoltages` | Only if matching an EF-based legacy document |
| default legacy | Recheck every `v=` when upgrading old code |

If still wrong after `RPvoltages`: flip start/end of the `to[...]` segment, or place voltage on an `open` bipole between named nodes with intentional order.

---

## 3. Component not found / path vs node

| | |
|--|--|
| **Problem** | `unknown to path` / shape unknown / nothing draws |
| **Cause** | Using path syntax for multipoles or node syntax for bipoles; typo; feature needs newer CircuiTikZ |
| **Fix** | Match class; upgrade package; check alias |

```latex
% WRONG
\draw (0,0) to[npn] (1,0);
\draw (0,0) node[R] {};

% RIGHT
\draw (0,0) node[npn] (Q1) {};
\draw (0,0) to[R, l=$R$] (2,0);
```

| Class | Syntax |
|-------|--------|
| Bipoles (R,C,L,D,V,…) | `to[TYPE]` |
| Transistors, op-amps, logic | `node[TYPE] (id) {}` |
| Grounds, vcc | `node[ground] {}` often at path end |

Version-gated names (some RF blocks, exotic FETs): confirm against installed 1.8.x manual; substitute a supported synonym.

---

## 4. Unknown anchor

| | |
|--|--|
| **Problem** | `Unknown anchor` on transistors/op-amps/logic |
| **Cause** | Wrong pin name; mirrored/rotated node; transformer anchors changed by version |
| **Fix** | Use official anchors; re-check after `xscale=-1` |

| Device | Typical anchors |
|--------|-----------------|
| BJT | `B`, `C`, `E` |
| MOSFET | `G`, `D`, `S` (bulk on richer styles) |
| Op-amp | `+`, `-`, `out`, `up`, `down` |
| Logic port | `in 1`, `in 2`, `out` |
| Transformer | `A1`, `A2`, `B1`, `B2` (verify on ≥1.8.3 if offsets look odd) |

```latex
\draw (0,0) node[op amp] (oa) {};
\draw (oa.-) -- ++(-1,0);   % not (oa.inverting) unless defined
```

After `xscale=-1` on FETs, mentally re-map which physical side is gate.

---

## 5. Poles drawing twice

| | |
|--|--|
| **Problem** | Double dots at joints; thick blobs |
| **Cause** | Both path poles (`*-`) and explicit `node[circ]` on the same point; or two bipoles each placing an end pole |
| **Fix** | Use **one** mechanism |

```latex
% prefer
\draw (0,0) to[R, *-] (2,0) to[C, -*] (2,-2);

% or
\draw (0,0) node[circ] {} to[R] (2,0) node[circ] {};

% avoid combining both on the same joint
```

For T-junctions, place a single `*-` / `circ` at the shared coordinate.

---

## 6. Scaling issues

| | |
|--|--|
| **Problem** | Huge/tiny symbols; labels not scaling; fences clipped; ugly `\scalebox` |
| **Cause** | Outer `scale=` without `transform shape`; wrong lever (`bipoles/length` vs component scale) |
| **Fix** | Scale with CircuiTikZ keys first |

```latex
\ctikzset{
  bipoles/length=1.2cm,
  resistors/scale=0.85,
  capacitors/scale=0.85,
  sources/scale=0.9,
  amplifiers/scale=0.85,
  tripoles/scale=0.9,
}
```

| Approach | Notes |
|----------|-------|
| `bipoles/length` | Primary overall size control |
| per-family `.../scale` | Fine-tune R vs sources vs amps |
| `scale=0.8, transform shape` on `circuitikz` | Scales nodes too; use carefully |
| `\scalebox` whole figure | Last resort; font/line inconsistency |

---

## 7. Mixing styles

| | |
|--|--|
| **Problem** | European resistors next to american sources; inconsistent voltage marks |
| **Cause** | Package option + mid-document `\ctikzset` overrides; copy-paste from multiple templates |
| **Fix** | Pick one style family per figure |

```latex
\usepackage[american, RPvoltages]{circuitikz}
% don't later set resistor=european unless intentional contrast
```

Logic ports can use `ieee` while analog stays `american`—that mix is fine if intentional; random bipole mixes look unprofessional.

---

## 8. TikZ `to` / `+` / `++` quirks

| | |
|--|--|
| **Problem** | Next segment starts at unexpected point; components skewed; “modern” path needed |
| **Cause** | Confusion between `+(dx,dy)` (relative, keep current point) and `++(dx,dy)` (relative, move current point); old tutorials; need recent circuitikz path construction |
| **Fix** | Prefer `++` for chain layout; name coordinates; use circuitikz ≥1.6 / 1.8.x |

```latex
% chain that advances
\draw (0,0) to[R] ++(2,0) to[C] ++(0,-2);

% temporary offset without permanently moving: use + carefully / coordinates
\draw (0,0) -- +(1,1) -- (2,0);  % + does not update the same way as ++
```

Orthogonal connectors:

```latex
\draw (a) |- (b);  % H then V
\draw (a) -| (b);  % V then H
\draw (P1) -- (P1 |- P2);  % vertical align helper
```

If `to[R] (x,y)` ignores expected intermediate geometry, split into explicit coordinates.

---

## 9. siunitx with stacked labels

| | |
|--|--|
| **Problem** | Errors on `l2=` with `1<\kilo\ohm>` or similar |
| **Cause** | Nested key parsing + siunitx angle brackets inside circuitikz stacked labels |
| **Fix** | Brace, simplify, or use math-mode units |

```latex
% safer portable
to[R, l2=$R_1$ and $1\,\mathrm{k}\Omega$]

% siunitx often ok simple
to[R, l=1<\kilo\ohm>]

% if stacked+siunitx fails, don't stack siunitx tokens
to[R, l2={$R_1$} and {$1\,\mathrm{k}\Omega$}]
```

For TikZJax / Overleaf minimal setups without `siunitx`, never rely on `siunitx` package option.

---

## 10. Externalize issues

| | |
|--|--|
| **Problem** | TikZ externalize fails on circuit figures; stale MD5; missing images |
| **Cause** | Shell escape; list-and-make mode; fragile mode interaction with circuitikz |
| **Fix** | Enable shell escape; re-export; or disable externalize for that figure |

```latex
\tikzexternaldisable
\begin{circuitikz}
  ...
\end{circuitikz}
\tikzexternalenable
```

Compile once with `-shell-escape` when externalize is on. Clear `*.pdf` / `*.md5` for that figure if content changed but image did not.

---

## 11. TikZJax limitations

| | |
|--|--|
| **Problem** | Figure fails only in browser TikZJax; works in local TeX |
| **Cause** | Host lacks packages (siunitx, fonts); limited PGF; **color mixing** fragile depending on host build |
| **Fix** | Ship a pure `circuitikz` fragment; math-mode units; simple colors |

Guidelines for TikZJax delivery:

- No extra `\usepackage` inside the snippet (host loads TikZ/circuitikz).
- Prefer default ink colors; avoid complex `\colorlet` / blending.
- Avoid rare components if host freezes on old circuitikz.
- Test with fewer labels if the engine times out.

---

## 12. Designer export differences

| | |
|--|--|
| **Problem** | Export from [CircuiTikZ-Designer](https://github.com/Circuit2TikZ/CircuiTikZ-Designer) compiles but labels, scales, or absolute coords differ from hand style in this skill |
| **Cause** | GUI absolute placement; different default styles; verbose component names |
| **Fix** | Treat export as topology seed; normalize |

Cleanup recipe:

1. Set package options to `[RPvoltages, american]` (or chosen standard).
2. Rename multipoles to short ids (`oa`, `Q1`, `M1`).
3. Prefer short bipole aliases (`R`, `C`, `L`, `D`).
4. Replace absolute spaghetti with `++` chains where readability wins.
5. Brace labels; convert unit text to math-mode if needed.
6. Drop duplicate poles / redundant `short`s.

Designer remains excellent for dense interconnect discovery; final paper style should match this skill’s conventions.

---

## Fast triage checklist

1. Braced labels with `=` / `,`?
2. Bipole `to` vs multipole `node`?
3. `RPvoltages` loaded for new voltage arrows?
4. Anchors spelled `B/C/E`, `G/D/S`, `+/-/out`, `in 1`?
5. Single pole style at each joint?
6. Scale via `\ctikzset` not nested scale hacks?
7. Portable units if not using full TeX stack?

Still stuck: minimize to a 3-component MWE; compare against a template in [templates.md](templates.md).
