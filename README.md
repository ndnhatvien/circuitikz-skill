# circuitikz-skill

Agent skill for generating **publication-quality electronic circuit diagrams** with [CircuiTikZ](https://github.com/circuitikz/circuitikz) (LaTeX/TikZ).

Targets CircuiTikZ **1.8.6+**. Designed for AI coding agents (Claude Code, Cursor, Codex, etc.) that need reliable schematic code for papers, teaching notes, Overleaf, and TikZJax hosts.

## What you get

| Path | Purpose |
|------|---------|
| [`circuitikz-diagramming/SKILL.md`](circuitikz-diagramming/SKILL.md) | Core workflow, syntax model, style rules, quality checklist |
| [`circuitikz-diagramming/references/`](circuitikz-diagramming/references/) | Progressive references (components, active devices, labels/V/I, templates, troubleshooting, KTMDT course circuits) |
| [`circuitikz-diagramming/scripts/render.ps1`](circuitikz-diagramming/scripts/render.ps1) | Compile a snippet/file to PDF + PNG for visual verification |
| [`circuitikz-diagramming.skill`](circuitikz-diagramming.skill) | Packaged skill archive |

Agents load only the core skill first, then open reference files when the circuit needs deeper detail.

## Install

### Claude Code / skills CLI

```bash
npx skills add ndnhatvien/circuitikz-skill@circuitikz-diagramming
```

Or clone and point your agent at the skill folder:

```bash
git clone https://github.com/ndnhatvien/circuitikz-skill.git
# then install/copy circuitikz-diagramming/ into your agent skills directory
```

### Manual

Copy `circuitikz-diagramming/` into your agent’s skills path (for example `~/.claude/skills/` or project `.claude/skills/`).

## When the skill triggers

Use it when you need to:

- Draw or fix CircuiTikZ / TikZ circuit figures
- Produce Overleaf-ready schematics (R, C, L, sources, diodes, transistors, op-amps, logic)
- Add labels, voltages, currents, poles consistently
- Export TikZJax / Obsidian-friendly circuit blocks
- Match clean export style similar to [CircuiTikZ-Designer](https://github.com/Circuit2TikZ/CircuiTikZ-Designer)

## Quick example

```latex
% preamble: \usepackage[RPvoltages, american]{circuitikz}
\begin{circuitikz}[american]
  \draw (0,0)
    to[battery2, l=$V_s$, invert] ++(0,2)
    to[R=$R$, i=$i$] ++(3,0)
    to[C=$C$, v=$v_C$] ++(0,-2)
    -- (0,0);
\end{circuitikz}
```

Note: `RPvoltages` is a **package option** (goes in `\usepackage[...]{circuitikz}`), not an environment option — putting it in `\begin{circuitikz}[...]` is a pgfkeys error.

Defaults encouraged by the skill:

- Style: `american` or `european` (one per document)
- Voltage direction: `RPvoltages` for new figures
- Placement: one absolute origin + relative `++` + named anchors
- Short aliases: `R`, `C`, `L`, `D`

## Skill layout

```text
circuitikz-diagramming/
├── SKILL.md
├── references/
│   ├── components.md
│   ├── active-devices.md
│   ├── labels-voltages-currents.md
│   ├── templates.md
│   ├── ktmdt-templates.md
│   └── troubleshooting.md
└── scripts/
    └── render.ps1
```

### Templates included

1. Voltage divider  
2. Series RLC  
3. Half-wave rectifier  
4. Non-inverting op-amp  
5. Inverting op-amp  
6. Common-emitter BJT amp  
7. NMOS common-source stage  
8. RC low-pass filter  
9. Full-wave bridge rectifier  
10. NAND gate with labeled pins  

### KTMDT course circuits (`references/ktmdt-templates.md`)

Bộ mạch cho môn Kỹ thuật Mạch điện tử (14 mạch, đã biên dịch kiểm chứng):

1. Zener regulator
2. Bridge rectifier with filter capacitor
3. Common-emitter BJT amplifier (full bias + bypass)
4. BJT differential pair
5. Op-amp difference amplifier
6. Op-amp integrator
7. Schmitt trigger
8. Sallen–Key active filter
9. BJT current mirror
10. Series-pass linear regulator
11. Class-B push–pull output stage
12. MOSFET H-bridge
13. 555 astable timer
14. Two-stage RC-coupled amplifier

Also covers Vietnamese labels: compile with `render.ps1 -Vietnam`.

## Verify by compiling

`scripts/render.ps1` wraps a bare CircuiTikZ snippet (or a `.tex` file) in a `standalone`
document, compiles it, and rasterises page 1 to PNG so the figure can be checked visually
instead of trusting a mental compile:

```powershell
pwsh circuitikz-diagramming/scripts/render.ps1 -Source '\begin{circuitikz}\draw (0,0) to[R] ++(2,0);\end{circuitikz}'
pwsh circuitikz-diagramming/scripts/render.ps1 -Source .\fig.tex -Vietnam -Open
```

Requires a TeX distribution (`pdflatex` + `pdftoppm`; TeX Live ships both; on MiKTeX
install poppler for `pdftoppm`).

## Related tools

| Resource | Role |
|----------|------|
| [circuitikz/circuitikz](https://github.com/circuitikz/circuitikz) | Official package + manual |
| [CircuiTikZ-Designer](https://github.com/Circuit2TikZ/CircuiTikZ-Designer) | Visual editor → CircuiTikZ export |
| Live designer | https://circuit2tikz.tf.fau.de/designer/ |

## License

MIT — see [LICENSE](LICENSE).
