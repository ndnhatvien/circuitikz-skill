# Labels, Voltages, Currents, and Poles

How to annotate CircuiTikZ bipoles and multipoles correctly. Device lists: [components.md](components.md), [active-devices.md](active-devices.md).

## Contents

1. [Labels and annotations](#labels-and-annotations)
2. [Passive shortcut `type=text`](#passive-shortcut-typetext)
3. [Active sources and `=`](#active-sources-and-)
4. [Bracing special characters](#bracing-special-characters)
5. [Stacked labels](#stacked-labels)
6. [Currents](#currents)
7. [Voltages](#voltages)
8. [Poles on bipoles](#poles-on-bipoles)
9. [Naming bipoles](#naming-bipoles)
10. [Invert and mirror](#invert-and-mirror)
11. [Label alignment](#label-alignment)
12. [siunitx notes](#siunitx-notes)

---

## Labels and annotations

| Key | Role |
|-----|------|
| `l=` | Main label (component name / designator) |
| `a=` | Annotation on the opposite side of the label |
| `l_=` | Force label to the “below” side of the bipole direction |
| `l^=` | Force label to the “above” side |
| `a_=` / `a^=` | Same for annotations |

```latex
\draw (0,0) to[R, l=$R_1$] ++(2,0);
\draw (0,0) to[R, l=$R_1$, a=$1\,\mathrm{k}\Omega$] ++(2,0);
\draw (0,0) to[R, l_=$R_2$] ++(2,0);
\draw (0,0) to[R, l^=$R_3$] ++(2,0);
```

Path direction defines default above/below. When a label lands on the wrong side, flip with `_` / `^` before redesigning coordinates.

---

## Passive shortcut `type=text`

For **passive** bipoles, `to[R=$R_1$]` is shorthand for `to[R, l=$R_1$]`:

```latex
\draw (0,0) to[R=$R_1$] ++(2,0);
\draw (0,0) to[C=$C_{\mathrm{in}}$] ++(0,-2);
\draw (0,0) to[L=$L$] ++(2,0);
```

Works for common passives (`R`, `C`, `L`, many diodes as labels). Prefer explicit `l=` when also setting `v`/`i` for clarity:

```latex
to[R, l=$R$, v=$v_R$, i=$i$]
```

---

## Active sources and `=`

For **active sources**, the `=` shortcut sets the **source quantity** (typically voltage or current display), **not** `l=`:

```latex
\draw (0,0) to[V=$v_s$] ++(0,2);     % source value / v-like
\draw (0,0) to[I=$i_s$] ++(2,0);
\draw (0,0) to[sV=$v(t)$] ++(0,2);
```

To place a designator **and** a value:

```latex
\draw (0,0) to[V, v=$12\,\mathrm{V}$, l=$V_1$] ++(0,2);
% or name with l and let v carry the quantity
```

Do not assume `to[V=$V_1$]` only labels the designator—it annotates the source in the active-source sense.

---

## Bracing special characters

TikZ key–value parsing splits on `,` and treats `=` as separators. **Brace** any label text containing them:

```latex
% BAD — breaks parsing
to[R, l=$R=1k$]
to[C, l=$C_1, C_2$]

% GOOD
to[R, l={$R=1\,\mathrm{k}\Omega$}]
to[C, l={$C_1,\,C_2$}]
to[R, a={$1\,\mathrm{k}\Omega,\,0.25\,\mathrm{W}$}]
```

Also brace nested brackets when needed. When in doubt, brace the whole value.

---

## Stacked labels

Two-line labels with `l2=` … `and` …:

```latex
\draw (0,0) to[R, l2=$R_1$ and $1\,\mathrm{k}\Omega$] ++(2,0);
\draw (0,0) to[C, l2_=$C$ and $100\,\mathrm{nF}$] ++(0,-2);
```

`l2^=` / `l2_=` control side. Keep each line short; long multi-line text collides with wires.

Annotation stacking variants exist (`a2=`); use sparingly.

---

## Currents

| Key | Effect |
|-----|--------|
| `i=` | Current arrow + label, default side/dir |
| `i_=` / `i^=` | Current on below / above side |
| `i>=` / `i<=` | Direction of arrow along / against path conventions |
| Combinations | `i_>=`, `i^>=`, `i_<=`, `i^<=`, `i>_=`, … |

```latex
\draw (0,0) to[R, l=$R$, i=$i_R$] ++(2,0);
\draw (0,0) to[R, l=$R$, i_=$i$] ++(2,0);
\draw (0,0) to[R, l=$R$, i^>=$i_{\mathrm{in}}$] ++(2,0);
\draw (0,0) to[L, l=$L$, i>=$i_L$] ++(2,0);
```

Current direction is relative to path direction (from start coordinate to end). Reverse the path or use opposite arrow modifiers when the prose defines the opposite arrow.

For multipoles, draw current on a `short` or on the bipole feeding the pin:

```latex
\draw (oa.out) to[short, i=$i_{\mathrm{out}}$] ++(1,0);
```

---

## Voltages

| Key | Effect |
|-----|--------|
| `v=` | Voltage annotation across bipole |
| `v_=` / `v^=` | Side selection |
| American/european voltage styles | Arrow vs +/- placement |

```latex
\draw (0,0) to[C, l=$C$, v=$v_C$] ++(0,-2);
\draw (0,0) to[R, l=$R$, v^=$v_R$] ++(2,0);
```

### Voltage conventions (important)

| Convention | Role |
|------------|------|
| **`RPvoltages`** | Recommended for **new** work — consistent RP polarity |
| **`EFvoltages`** | Alternative EF convention |
| **legacy / default historical** | Old documents; arrows may surprise |

```latex
\usepackage[RPvoltages, american]{circuitikz}
```

If voltage arrows point the “wrong” way relative to the textbook intention:

1. Confirm package uses `RPvoltages`.
2. Reverse path endpoints or adjust `v` side modifiers.
3. Avoid mixing documents compiled with different voltage options without re-checking arrows.

Straight / raised voltage styles:

```latex
\ctikzset{voltage=straight}   % or raised, american, european — per manual
```

Pick one convention per paper.

Open bipoles as voltmeters/probes:

```latex
\draw (a) to[open, v=$v_x$] (b);
```

---

## Poles on bipoles

Inline connection dots / open circles:

| Token | Meaning |
|-------|---------|
| `*-` | Filled pole at start |
| `-*` | Filled pole at end |
| `*-*` | Both ends filled |
| `o-` / `-o` / `o-o` | Open poles |
| `*-o`, `o-*` | Mixed |

```latex
\draw (0,0) to[R, l=$R$, *-*] ++(2,0);
\draw (0,0) to[short, *-] ++(1,0) to[C, l=$C$, -*] ++(0,-2);
\draw (0,0) to[R, o-*] ++(2,0);
```

**Do not** also place a separate `node[circ]` on the same joint unless intentional (double dots). Prefer either path poles **or** explicit `circ` nodes.

```latex
% Prefer one approach
\draw (0,0) to[R, *-] (2,0);
% not both:
% \draw (0,0) node[circ] {} to[R, *-] (2,0);
```

---

## Naming bipoles

Give bipoles a `name=` to access geometrical anchors later:

```latex
\draw (0,0) to[R, l=$R_1$, name=R1] ++(2,0);
\draw (R1.n) -- ++(0,0.5);   % anchors like n, s, east-ish — version uses bipole anchors
```

Typical bipole anchors include ends and cardinal points relative to the bipole (consult manual: `left`, `right`, or `n`/`s` depending on orientation helpers). Named bipoles help when dropping a vertical measurement without inventing phantom coordinates:

```latex
\draw (0,2) to[R, name=Rx, l=$R_x$] ++(2,0);
\draw (Rx.s) to[open, v=$v_x$] ++(0,-1);
```

For multipoles, the node name **is** the name:

```latex
\draw (0,0) node[npn] (Q1) {};
\draw (Q1.C) -- ++(0,1);
```

---

## Invert and mirror

| Option | Effect |
|--------|--------|
| `invert` | Swap bipole ends / flip asymmetric symbol along path |
| `mirror` | Mirror symbol across path |

```latex
\draw (0,0) to[eC, invert, l=$C$] ++(2,0);
\draw (0,0) to[D, mirror, l=$D$] ++(2,0);
```

Use when polar capacitors or diodes face the wrong way but path topology (and current definitions) should stay.

---

## Label alignment

```latex
\ctikzset{label/align=smart}    % default-ish smart placement
\ctikzset{label/align=rotate}   % rotate with bipole
\ctikzset{label/align=straight} % keep text upright
```

Per-bipole overrides may exist via label options; when labels collide:

1. Switch `l_` / `l^`.
2. Shorten text or use `l2` stacking.
3. Nudge with small coordinate changes rather than huge absolute shifts.
4. Last resort: leave label off bipole and place a TikZ `node` manually.

---

## siunitx notes

With package option `siunitx` (and `\usepackage{siunitx}`):

```latex
\usepackage[american, RPvoltages, siunitx]{circuitikz}

\draw (0,0) to[R, l_=1<\kilo\ohm>] ++(2,0);
\draw (0,0) to[C, l=100<\nano\farad>] ++(0,-2);
```

Caveats:

- Stacked labels `l2=` with compact siunitx syntax can parse poorly—brace aggressively or use math-mode units instead.
- TikZJax / minimal web hosts may not provide `siunitx`—prefer `$1\,\mathrm{k}\Omega$` for portable fragments.
- Keep unit style consistent within a paper (`\mathrm{k}\Omega` vs siunitx).

Portable math-mode units (always safe):

```latex
l=$1\,\mathrm{k}\Omega$
a=$100\,\mathrm{nF}$
v=$3.3\,\mathrm{V}$
```

---

## Quick annotation recipe

```latex
\begin{circuitikz}[american]
  \draw (0,0)
    to[V, v=$v_s$, name=Vs] ++(0,2)
    to[R, l={$R=1\,\mathrm{k}\Omega$}, i>=$i$, *-*] ++(2,0)
    to[C, l2=$C$ and $100\,\mathrm{nF}$, v=$v_C$] ++(0,-2)
    -- (0,0);
\end{circuitikz}
```

Checklist:

- [ ] Passives: `l=` or `R=$...$` shortcut
- [ ] Actives: `=` means source value
- [ ] Brace `=` and `,` inside labels
- [ ] `RPvoltages` for new figures
- [ ] One pole style (path poles *or* `circ` nodes)
- [ ] Currents oriented with path or explicit `i>` / `i<` family
