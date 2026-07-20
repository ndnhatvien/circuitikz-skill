# CircuiTikZ Components Reference

Bipoles, grounds, wires, meters, and RF blocks. For transistors, op-amps, logic, transformers see [active-devices.md](active-devices.md). Labels/v/i details: [labels-voltages-currents.md](labels-voltages-currents.md).

## Contents

1. [Path vs node components](#path-vs-node-components)
2. [Resistive bipoles](#resistive-bipoles)
3. [Capacitors](#capacitors)
4. [Inductors](#inductors)
5. [Sources](#sources)
6. [Diodes and switches](#diodes-and-switches)
7. [Grounds and rails](#grounds-and-rails)
8. [Wires, poles, crossings](#wires-poles-crossings)
9. [Meters](#meters)
10. [RF and functional blocks](#rf-and-functional-blocks)
11. [Style aliases](#style-aliases)
12. [Alias preference](#alias-preference)

---

## Path vs node components

| Class | Syntax | Examples |
|-------|--------|----------|
| Bipole (2-terminal) | `\draw (a) to[TYPE, opts] (b);` | `R`, `C`, `L`, `D`, `V`, `short` |
| Multipole / block | `\draw (x,y) node[TYPE] (name) {};` then connect anchors | `npn`, `op amp`, `and port` |

Almost everything in this file is **path bipoles** (or terminal **nodes** like `ground`).

```latex
\draw (0,0) to[R, l=$R$] (2,0) to[C, l=$C$] (2,-2) node[ground] {};
```

---

## Resistive bipoles

| Type | Symbol / use |
|------|----------------|
| `R`, `resistor` | Standard resistor (style: american zig-zag / european rectangle) |
| `vR`, `variable resistor` | Variable resistor (arrow) |
| `pR`, `potentiometer` | Potentiometer (3rd terminal anchor) |
| `sR` / `resistivesens` | Generic resistive sensor |
| `phR`, `photoresistor` | Photoresistor |
| `thR`, `thermistor` | Thermistor |
| `tR` | Tunable / adjustable styles (see manual) |
| `cR` | Cute resistor (when cute style active) |

```latex
\draw (0,0) to[R, l=$R_1$] ++(2,0);
\draw (0,0) to[vR, l=$R_{\mathrm{var}}$] ++(2,0);
\draw (0,0) to[pR, l=$R_P$, name=P1] ++(2,0);
% third terminal of potentiometer:
\draw (P1.wiper) -- ++(0,-0.8);
```

American vs European controlled by package option / `\ctikzset{resistor=american}` etc.

```latex
to[R=$R_1$]   % shortcut ≡ l=$R_1$ for passives
```

---

## Capacitors

| Type | Use |
|------|-----|
| `C`, `capacitor` | Standard capacitor |
| `eC`, `ecapacitor` | Electrolytic / polar capacitor |
| `cC`, `curved capacitor` | Curved-plate style |
| `vC`, `variable capacitor` | Variable capacitor |
| `cC` / cute variants | Depend on style settings |

```latex
\draw (0,0) to[C, l=$C$, v=$v_C$] ++(0,-2);
\draw (0,0) to[eC, l=$C_E$] ++(2,0);          % polar
\draw (0,0) to[vC, l=$C_{\mathrm{tune}}$] ++(2,0);
```

Polar electrolytic: orientation follows path direction; use `invert` if the plate is on the wrong end.

---

## Inductors

| Type | Use |
|------|-----|
| `L`, `inductor` | Default inductor for current style |
| `american inductor` | Loopy american coil |
| `cute inductor` | “Cute” rounded coils |
| `european inductor` | Rectangular european inductor |
| `vL`, `variable inductor` | Variable inductor |
| `L` + core styles | Some styles show magnetic core |

```latex
\draw (0,0) to[L, l=$L$, i=$i_L$] ++(2,0);
\draw (0,0) to[american inductor, l=$L$] ++(2,0);
```

Style switch:

```latex
\ctikzset{inductor=cute}      % or american / european
```

---

## Sources

### DC batteries and independent sources

| Type | Meaning |
|------|---------|
| `battery1` | Single-cell battery |
| `battery2` | Multi-cell battery |
| `V`, `vsource`, `voltage source` | Independent voltage source |
| `I`, `isource`, `current source` | Independent current source |
| `vsourceAM` / european variants | Style-dependent forms |

```latex
\draw (0,0) to[battery2, l=$V_{CC}$] ++(0,2);
\draw (0,0) to[V, v=$v_s$] ++(0,2);
\draw (0,0) to[I, i=$i_s$] ++(2,0);
```

**Active-source `=` shortcut:** `to[V=$v_s$]` sets the source value (voltage/current annotation), **not** `l=`.

### Sinusoidal / controlled / special

| Type | Meaning |
|------|---------|
| `sV`, `vsourcesin` | Sinusoidal voltage |
| `sI`, `isourcesin` | Sinusoidal current |
| `squareV` / square voltage | Square-wave voltage |
| `noise` sources | Noise source bipoles |
| `pvsource` | Photovoltaic source |
| `cV`, `cI` | Controlled sources (diamond) |
| `sV` controlled variants | Dependent sinusoidal forms |

```latex
\draw (0,0) to[sV, v=$v_s(t)$] ++(0,2);
\draw (0,0) to[sI, i=$i_s$] ++(2,0);
\draw (0,0) to[square voltage, v=$v_{\mathrm{clk}}$] ++(0,2);
```

Empty source shell for generic independent: often `V` / `I` is enough.

---

## Diodes and switches

| Type | Device |
|------|--------|
| `D`, `Diode` | Standard diode |
| `Do`, `ododiode` / empty | Empty diode (outline) |
| `led` | LED |
| `zD`, `zener` | Zener diode |
| `sD`, `Schottky diode` | Schottky |
| `pD`, `pDiode` | Photodiode |
| `Tu`, `tunnel diode` | Tunnel diode |
| `VC`, `varcap` | Varicap |
| `Ty`, `thyristor` | Thyristor / SCR |
| `Tr`, `triac` | TRIAC |
| `cspst`, `spst`, … | Switches (path styles) |
| `nos`, `ncs`, … | Make/break switches |

```latex
\draw (0,0) to[D, l=$D_1$] ++(2,0);
\draw (0,0) to[led, l=LED] ++(2,0);
\draw (0,0) to[zD, l=$D_Z$] ++(0,-2);
\draw (0,0) to[thyristor, l=SCR] ++(2,0);
```

Direction of the triangle follows path direction; reverse path or use `invert` to flip.

---

## Grounds and rails

These are typically **nodes** at the end of a wire:

| Node | Symbol |
|------|--------|
| `ground` | Standard ground |
| `tlground` | Tailless / chassis-like ground |
| `rground` | Reference / signal ground variant |
| `sground` | Signal ground |
| `cground` | Chassis ground |
| `nground` | Noiseless ground |
| `pground` | Protective earth variants (see manual) |
| `vcc` | VCC rail arrow (up) |
| `vee` | VEE rail arrow (down) |

```latex
\draw (0,0) -- ++(0,-0.5) node[ground] {};
\draw (0,2) node[vcc] {$V_{CC}$};
\draw (0,0) node[vee] {$V_{EE}$};
\draw (2,0) -- ++(0,-0.5) node[tlground] {};
```

Power flags often sit directly on a coordinate without an extra stub if spacing allows.

---

## Wires, poles, crossings

| Type / option | Role |
|---------------|------|
| `short` | Plain wire segment (for poles/labels on wires) |
| `open` | Open bipole (gap; good for voltage probes) |
| `circ` | Filled connection dot (also `*-` style poles) |
| `ocirc` | Open circle pole |
| `*-`, `-*, `*-*`, `o-*`, `*-o`, `o-o` | Inline poles on bipoles |
| crossing styles | Jump / bridge at wire crossings |

```latex
\draw (0,0) to[short, *-] (1,0) to[R, l=$R$] (3,0);
\draw (0,0) to[open, v=$v_x$] ++(0,-1.5);
\draw (0,1) -- (2,1);
\draw (1,0) to[crossing] (1,2);   % style name may be jump crossing per version
```

Prefer re-routing with orthogonal `-|` / `|-` over dense crossings when readable.

---

## Meters

| Type | Instrument |
|------|------------|
| `ammeter` | Ammeter |
| `voltmeter` | Voltmeter |
| `ohmmeter` | Ohmmeter |
| `oscope` | Oscilloscope probe-style block |

```latex
\draw (0,0) to[ammeter, l=A] ++(2,0);
\draw (0,2) to[voltmeter] ++(0,-2);
```

---

## RF and functional blocks

| Type | Use |
|------|-----|
| `tline`, `transmission line` | Transmission line |
| `antenna` | Antenna |
| `twoport` | Generic two-port |
| `lowpass`, `highpass`, `bandpass`, `bandstop` | Filter blocks |
| `mixer` | Mixer |
| `coupler`, directional coupler styles | Couplers |
| `amp`, plain amplifiers (block) | Functional amp triangle (not full op-amp) |

```latex
\draw (0,0) to[tline, l=TL] ++(2,0);
\draw (0,0) to[antenna] ++(0,1.5);
\draw (0,0) node[twoport, t=HPF] (f1) {};
\draw (0,0) to[lowpass] ++(2,0);
```

Exact filter/coupler option names track the CircuiTikZ manual version; if a type fails, check spelling against the installed version (1.8.x).

---

## Style aliases

CircuiTikZ switches whole families of symbols:

| Setting | Effect |
|---------|--------|
| `american` | Zigzag R, circular sources, american inductors often |
| `european` | Rectangular R, european sources |
| `cute` | Softer “cute” bipole drawings |

```latex
\usepackage[american, RPvoltages]{circuitikz}
% or
\ctikzset{resistor=european, inductor=cute}
```

Keep one family per figure unless deliberately contrasting standards.

---

## Alias preference

Prefer **short aliases** in generated code:

| Prefer | Avoid (verbose synonym) |
|--------|-------------------------|
| `R` | `resistor` (unless teaching full names) |
| `C` | `capacitor` |
| `L` | `inductor` |
| `D` | `Diode` |
| `V`, `I` | `vsource`, `isource` unless needed |
| `sV`, `sI` | long sinusoidal names |
| `ground` | exotic grounds unless symbol matters |

Use long names only when two styles collide or the short form is ambiguous in context.

---

## Minimal multi-family example

```latex
\begin{circuitikz}[american]
  \draw (0,0) node[ground] {}
    to[V, v=$v_s$] ++(0,2)
    to[R, l=$R$] ++(2,0)
    to[L, l=$L$] ++(2,0)
    to[C, l=$C$, *-*] ++(0,-2)
    to[D, l=$D$] ++(-2,0)
    -- (0,0);
\end{circuitikz}
```
