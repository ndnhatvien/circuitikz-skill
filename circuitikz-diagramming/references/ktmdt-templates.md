# CircuiTikZ Templates — Kỹ thuật Mạch điện tử (KTMDT)

Bộ mạch mẫu dùng cho **bài giảng / giáo trình Kỹ thuật Mạch điện tử** (điện tử tương tự,
điện tử công suất, mạch tích hợp). Tất cả dùng style **american** + **RPvoltages**:

```latex
\usepackage[RPvoltages, american]{circuitikz}
```

Mạch nền tảng (phân áp, RLC, khuếch đại thuật toán cơ bản…) xem
[templates.md](templates.md); ở đây là các mạch **chuyên ngành** thường gặp trong
giáo trình: nguồn, chỉnh lưu, khuếch đại nhiều tầng, vi sai, lọc tích cực, dao động,
công suất, cầu H.

> **Kiểm tra biên dịch:** mọi mẫu dưới đây đã được biên dịch thật với
> `pdflatex` + CircuiTikZ 1.8.x. Muốn tự xác nhận, dùng
> [`../scripts/render.ps1`](../scripts/render.ps1) (xem cuối file).

## Mục lục

1. [Ổn áp dùng diode Zener](#1-ổn-áp-dùng-diode-zener)
2. [Chỉnh lưu cầu + tụ lọc](#2-chỉnh-lưu-cầu--tụ-lọc)
3. [Khuếch đại BJT cực phát chung (phân áp đầy đủ)](#3-khuếch-đại-bjt-cực-phát-chung-phân-áp-đầy-đủ)
4. [Khuếch đại vi sai BJT](#4-khuếch-đại-vi-sai-bjt)
5. [Khuếch đại thuật toán — mạch trừ](#5-khuếch-đại-thuật-toán--mạch-trừ)
6. [Khuếch đại thuật toán — mạch tích phân](#6-khuếch-đại-thuật-toán--mạch-tích-phân)
7. [Schmitt trigger (so sánh hồi tiếp dương)](#7-schmitt-trigger-so-sánh-hồi-tiếp-dương)
8. [Lọc tích cực Sallen–Key](#8-lọc-tích-cực-sallenkey)
9. [Gương dòng điện BJT](#9-gương-dòng-điện-bjt)
10. [Ổn áp nối tiếp dùng BJT + Zener](#10-ổn-áp-nối-tiếp-dùng-bjt--zener)
11. [Khuếch đại công suất đẩy-kéo (class B)](#11-khuếch-đại-công-suất-đẩy-kéo-class-b)
12. [Cầu H điều khiển động cơ (MOSFET)](#12-cầu-h-điều-khiển-động-cơ-mosfet)
13. [Đa hài định thời 555 (astable)](#13-đa-hài-định-thời-555-astable)
14. [Khuếch đại ghép RC hai tầng](#14-khuếch-đại-ghép-rc-hai-tầng)

---

## 1. Ổn áp dùng diode Zener

**Khi dùng:** nguồn tham chiếu đơn giản, ổn áp tải nhỏ.

```latex
\begin{circuitikz}[american]
  \draw (0,0) node[ground] {}
    to[V, v=$V_{\mathrm{in}}$] ++(0,3) coordinate (top);
  \draw (top) to[R, l=$R_S$, *-*] ++(2.6,0) coordinate (vo);
  \draw (vo) to[zD, l=$D_Z$, v=$V_Z$, *-*] ++(0,-3) node[ground] {};
  \draw (vo) to[short, *-] ++(2.0,0) coordinate (rr);
  \draw (rr) to[R, l=$R_L$] ++(0,-3) node[ground] {};
  \draw (rr) to[short, *-o] ++(0.0,0) node[right] {};
\end{circuitikz}
```

---

## 2. Chỉnh lưu cầu + tụ lọc

**Khi dùng:** nguồn DC không điều khiển, mạch nguồn một chiều.

```latex
\begin{circuitikz}[american]
  % AC source
  \draw (0,1.5) coordinate (ac+) to[sV, v=$v_s$, invert] (0,-1.5) coordinate (ac-);
  % diode bridge
  \draw (ac+) to[D, l_=$D_1$] ++(2,1.5) coordinate (dc+);
  \draw (ac-) to[D, l^=$D_2$] ++(2,-1.5) coordinate (dc-);
  \draw (ac+) to[D, l^=$D_3$] (dc-);
  \draw (ac-) to[D, l_=$D_4$] (dc+);
  % take the DC output out to the right
  \draw (dc+) -- ++(1.8,0) coordinate (t1);
  \draw (dc-) -- ++(1.8,0) coordinate (b1);
  % filter cap and load, in parallel
  \draw (t1) to[C, l=$C$, *-*] (b1);
  \draw (t1) -- ++(1.8,0) coordinate (t2);
  \draw (b1) -- ++(1.8,0) coordinate (b2);
  \draw (t2) to[R, l=$R_L$, *-*] (b2);
  \draw (b2) -- ++(0,-0.5) node[ground] {};
  \draw (t2) to[short, *-o] ++(1.0,0) node[right] {$v_{\mathrm{out}}$};
\end{circuitikz}
```

> Đổi hướng một diode: dùng `invert` cho diode đó, hoặc đảo hai điểm đầu-cuối của
> đoạn `to[D]`.

---

## 3. Khuếch đại BJT cực phát chung (phân áp đầy đủ)

**Khi dùng:** tầng khuếch đại tín hiệu nhỏ kinh điển, có cầu phân áp + tụ bypass phát.

```latex
\begin{circuitikz}[american]
  \draw (0,0) node[npn] (Q1) {};
  % input coupling + R1/R2 bias divider
  \draw (Q1.B) to[short, *-] ++(-0.8,0) coordinate (base);
  \draw (base) to[C, l=$C_{\mathrm{in}}$, *-] ++(-1.6,0)
    to[short, -o] ++(-0.8,0) node[left] {$v_{\mathrm{in}}$};
  \draw (base) to[R, l=$R_1$] ++(0,2.6) node[vcc] {$V_{CC}$};
  \draw (base) to[R, l_=$R_2$] ++(0,-2.6) node[ground] {};
  % collector
  \draw (Q1.C) to[R, l=$R_C$] ++(0,2.6) node[vcc] {$V_{CC}$};
  \draw (Q1.C) to[C, l=$C_{\mathrm{out}}$, *-] ++(1.6,0)
    to[short, -o] ++(0.8,0) node[right] {$v_{\mathrm{out}}$};
  % emitter + C_E bypass
  \draw (Q1.E) to[short, *-] ++(0,-0.4) coordinate (e1);
  \draw (e1) to[R, l=$R_E$] ++(0,-1.8) coordinate (e2) node[ground] {};
  \draw (e1) to[C, l=$C_E$, *-] ++(1.6,0) coordinate (e3);
  \draw (e3) -- (e2 -| e3);
\end{circuitikz}
```

---

## 4. Khuếch đại vi sai BJT

**Khi dùng:** tầng vào của khuếch đại thuật toán, khuếch đại vi sai, CMRR.

```latex
\begin{circuitikz}[american]
  \draw (0,0) node[npn] (Q1) {};
  \draw (2.4,0) node[npn, xscale=-1] (Q2) {};
  \draw (Q1.E) -- (Q2.E);
  \draw (Q1.E) to[I, l=$I_0$] ++(0,-1.8) node[ground] {};
  \draw (Q1.C) to[R, l=$R_{C1}$] ++(0,2) node[vcc] {$V_{CC}$};
  \draw (Q2.C) to[R, l=$R_{C2}$] ++(0,2) node[vcc] {$V_{CC}$};
  \draw (Q1.B) to[short, -o] ++(-1,0) node[left] {$v_1$};
  \draw (Q2.B) to[short, -o] ++(1,0) node[right] {$v_2$};
  \draw (Q1.C) to[short, *-o] ++(-1.2,0) node[left] {$v_{o1}$};
  \draw (Q2.C) to[short, *-o] ++(1.2,0) node[right] {$v_{o2}$};
\end{circuitikz}
```

---

## 5. Khuếch đại thuật toán — mạch trừ

**Khi dùng:** `v_o = (R_f/R_1)(v_2 - v_1)` khi `R_2 = R_1`, `R_3 = R_f`.

```latex
\begin{circuitikz}[american]
  \draw (0,0) node[op amp] (oa) {};
  % inverting branch (v1)
  \draw (oa.-) to[R, l_=$R_1$, *-] ++(-2,0) coordinate (n1);
  \draw (n1) to[short, -o] ++(-0.9,0) node[left] {$v_1$};
  \draw (oa.-) to[R, l=$R_f$] ++(0,1.8) -| (oa.out);
  % non-inverting branch (v2)
  \draw (oa.+) to[R, l_=$R_2$] ++(-2,0) coordinate (n2);
  \draw (n2) to[short, -o] ++(-0.9,0) node[left] {$v_2$};
  \draw (n2) to[R, l=$R_3$] ++(0,-1.8) node[ground] {};
  \draw (oa.out) to[short, *-o] ++(1.2,0) node[right] {$v_o$};
\end{circuitikz}
```

---

## 6. Khuếch đại thuật toán — mạch tích phân

**Khi dùng:** `v_o = -\frac{1}{RC}\int v_i\,dt`. (Mạch vi phân: đổi R thành C phía vào.)

```latex
\begin{circuitikz}[american]
  \draw (0,0) node[op amp] (oa) {};
  \draw (oa.+) -- ++(0,-0.8) node[ground] {};
  \draw (oa.-) to[R, l_=$R$, *-] ++(-2,0) to[short, -o] ++(-0.8,0) node[left] {$v_i$};
  \draw (oa.-) to[C, l=$C$] ++(0,1.8) -| (oa.out);
  \draw (oa.out) to[short, *-o] ++(1.2,0) node[right] {$v_o$};
\end{circuitikz}
```

---

## 7. Schmitt trigger (so sánh hồi tiếp dương)

**Khi dùng:** so sánh có trễ (hysteresis), tạo xung vuông từ tín hiệu chậm.

```latex
\begin{circuitikz}[american]
  \draw (0,0) node[op amp] (oa) {};
  \draw (oa.-) to[short, -o] ++(-1,0) node[left] {$v_i$};
  \draw (oa.+) to[short, *-] ++(-0.8,0) coordinate (pin);
  \draw (pin) to[R, l=$R_1$] ++(0,-1.8) node[ground] {};
  % positive feedback from the output back to +
  \draw (oa.out) to[short, *-] ++(0,1.8) coordinate (fb);
  \draw (fb) to[R, l=$R_2$] (fb -| pin) -- (pin);
  \draw (oa.out) to[short, *-o] ++(1.2,0) node[right] {$v_o$};
\end{circuitikz}
```

---

## 8. Lọc tích cực Sallen–Key

**Khi dùng:** lọc thông thấp bậc hai (Butterworth/Chebyshev), đáp ứng Bode.

```latex
\begin{circuitikz}[american]
  \draw (0,0) node[op amp, noinv input up] (oa) {};
  \draw (oa.+) to[short, *-] ++(-0.8,0) coordinate (p);
  \draw (p) to[R, l=$R_2$] ++(-2,0) coordinate (a);
  \draw (a) to[R, l=$R_1$] ++(-2,0) to[short, -o] ++(-0.8,0) node[left] {$v_i$};
  \draw (p) to[C, l_=$C_2$] ++(0,-1.8) node[ground] {};
  \draw (a) to[C, l=$C_1$] ++(0,1.8) -| (oa.out);
  \draw (oa.-) -- ++(0,1.2) coordinate (fbt) -- (fbt -| oa.out) -- (oa.out);
  \draw (oa.out) to[short, *-o] ++(1.2,0) node[right] {$v_o$};
\end{circuitikz}
```

---

## 9. Gương dòng điện BJT

**Khi dùng:** nguồn dòng hằng, mạch phân cực trong IC, `I_OUT ≈ I_REF`.

```latex
\begin{circuitikz}[american]
  \draw (0,0) node[npn] (Q1) {};
  \draw (2.2,0) node[npn] (Q2) {};
  % shared base bus (drops below the transistors)
  \draw (Q1.B) to[short, *-] ++(-0.15,-0.9) coordinate (b1);
  \draw (Q2.B) to[short, *-] ++(-0.15,-0.9) coordinate (b2);
  \draw (b1) -- (b2);
  % Q1 diode-connected: base bus up to its collector
  \draw (b1) to[short, *-] ++(-0.9,0) coordinate (bl) |- (Q1.C);
  % reference and output currents
  \draw (Q1.C) to[I, l=$I_{\mathrm{REF}}$] ++(0,1.8) node[vcc] {$V_{CC}$};
  \draw (Q2.C) to[short, *-o] ++(1.2,0) node[right] {$I_{\mathrm{OUT}}$};
  % emitters
  \draw (Q1.E) -- ++(0,-0.8) node[ground] {};
  \draw (Q2.E) -- ++(0,-0.8) node[ground] {};
\end{circuitikz}
```

---

## 10. Ổn áp nối tiếp dùng BJT + Zener

**Khi dùng:** ổn áp tuyến tính (series pass), diode Zener làm áp tham chiếu.

```latex
\begin{circuitikz}[american]
  \draw (0,0) node[ground] {}
    to[V, v=$V_{\mathrm{in}}$] ++(0,3) coordinate (vin);
  % Zener reference branch off the input rail
  \draw (vin) -- ++(2.4,0) coordinate (topr);
  \draw (topr) to[R, l=$R_B$] ++(0,-1.6) coordinate (nb);
  \draw (nb) to[zD, l=$D_Z$, v=$V_Z$] ++(0,-1.6) node[ground] {};
  % series pass transistor
  \draw (nb) to[short, *-] ++(0.9,0) node[npn, anchor=B] (Q1) {};
  \draw (Q1.C) -- ++(0,0.6) -| (topr);
  \draw (Q1.E) to[short, *-] ++(1.8,0) coordinate (vout);
  \draw (vout) to[R, l^=$R_L$] ++(0,-2) node[ground] {};
  \draw (vout) to[short, *-o] ++(0.9,0) node[right] {$V_{\mathrm{out}}$};
\end{circuitikz}
```

---

## 11. Khuếch đại công suất đẩy-kéo (class B)

**Khi dùng:** tầng ra công suất (bổ phụ NPN/PNP), hiệu suất cao.

```latex
\begin{circuitikz}[american]
  \draw (0,0) node[npn] (Q1) {};
  \draw (0,-2.6) node[pnp] (Q2) {};
  \draw (Q1.E) -- (Q2.E);            % shared output node
  \draw (Q1.C) -- ++(0,1.6) node[vcc] {$+V_{CC}$};
  \draw (Q2.C) -- ++(0,-1.6) node[vee] {$-V_{CC}$};
  \draw (Q1.B) to[short, *-] ++(-1.2,0) coordinate (inb);
  \draw (Q2.B) -- (inb -| Q2.B);
  \draw (inb) to[short, -o] ++(-0.8,0) node[left] {$v_i$};
  \draw (Q1.E) to[short, *-o] ++(1.6,0) node[right] {$v_o$};
\end{circuitikz}
```

---

## 12. Cầu H điều khiển động cơ (MOSFET)

**Khi dùng:** điều khiển chiều quay động cơ DC, điện tử công suất.

```latex
\begin{circuitikz}[american]
  \draw (0,0) node[ground] {}
    to[V, v=$V_{DC}$] ++(0,5) coordinate (top);
  % left leg
  \draw (2,5) node[nigfete, anchor=D] (Q1) {};
  \draw (2,0) node[nigfete, anchor=S] (Q2) {};
  \draw (Q1.S) -- (Q2.D) coordinate (midL);
  % right leg (mirrored)
  \draw (5,5) node[nigfete, xscale=-1, anchor=D] (Q3) {};
  \draw (5,0) node[nigfete, xscale=-1, anchor=S] (Q4) {};
  \draw (Q3.S) -- (Q4.D) coordinate (midR);
  % supply rails
  \draw (top) -| (Q1.D);
  \draw (Q1.D) -- (Q3.D);
  \draw (Q2.S) -- (Q4.S);
  \draw (Q2.S) -- (0,0);
  % load (motor)
  \draw (midL) to[generic, l=$M$] (midR);
  % gate terminals
  \draw (Q1.G) -- ++(-1.0,0) node[left] {$g_1$};
  \draw (Q2.G) -- ++(-1.0,0) node[left] {$g_2$};
  \draw (Q3.G) -- ++(1.0,0) node[right] {$g_3$};
  \draw (Q4.G) -- ++(1.0,0) node[right] {$g_4$};
\end{circuitikz}
```

---

## 13. Đa hài định thời 555 (astable)

**Khi dùng:** tạo xung vuông, `f ≈ 1.44/((R_A+2R_B)C)`.

```latex
\begin{circuitikz}[american]
  \node[dipchip, num pins=8] (U) at (0,0) {555};
  % supply: pin 8 -> VCC
  \draw (U.pin 8) -- ++(0,0.8) node[vcc] {$V_{CC}$};
  % timing network on the right: RA -> RB -> C to ground
  \draw (U.pin 7) to[R, l=$R_A$] ++(0,-1.5) coordinate (d);
  \draw (d) to[R, l=$R_B$] ++(0,-1.5) coordinate (e);
  \draw (e) to[C, l=$C$] ++(0,-1.5) coordinate (cgnd) node[ground] {};
  % tie THRESH (6) and TRIG (2) to the timing node e
  \draw (U.pin 6) -- (U.pin 6 -| e) -- (e);
  \draw (U.pin 2) -- ++(-1.0,0) coordinate (l2) |- (e);
  % ground: pin 1 routed left then down (avoids the unused left pins)
  \draw (U.pin 1) -- ++(-2.4,0) coordinate (g1) -- (g1 |- cgnd) node[ground] {};
  % output: pin 3
  \draw (U.pin 3) -- ++(-1.6,0) node[left] {$v_o$};
\end{circuitikz}
```

> `dipchip` cho hình IC trực quan. Nếu máy chạy CircuiTikZ cũ, thay bằng một node
> chữ nhật `node[draw, minimum width=2.4cm, minimum height=1.8cm] (U) {555};` và gán
> nhãn chân bằng `node[left]` — xem mục "Khi thiếu `dipchip`" bên dưới.

---

## 14. Khuếch đại ghép RC hai tầng

**Khi dùng:** khuếch đại nhiều tầng, tính độ lợi tổng và băng thông.

```latex
\begin{circuitikz}[american]
  % stage 1
  \draw (0,0) node[npn] (Q1) {};
  \draw (Q1.B) to[short, *-] ++(-0.6,0) coordinate (b1);
  \draw (b1) to[R, l=$R_1$] ++(0,2.2) node[vcc] {$V_{CC}$};
  \draw (b1) to[R, l_=$R_2$] ++(0,-2.2) node[ground] {};
  \draw (b1) to[C, l=$C_1$, *-] ++(-1.4,0) to[short, -o] ++(-0.7,0) node[left] {$v_i$};
  \draw (Q1.C) to[R, l=$R_{C1}$] ++(0,2.4) node[vcc] {$V_{CC}$};
  \draw (Q1.E) to[R, l=$R_{E1}$] ++(0,-1.6) node[ground] {};
  % RC coupling into stage 2
  \draw (Q1.C) to[C, l=$C_C$, *-] ++(2.0,0) coordinate (c2);
  % stage 2
  \draw (c2) to[short, *-] ++(0.4,0) node[npn, anchor=B] (Q2) {};
  \draw (c2) to[R, l=$R_3$] ++(0,2.2) node[vcc] {$V_{CC}$};
  \draw (c2) to[R, l_=$R_4$] ++(0,-2.2) node[ground] {};
  \draw (Q2.C) to[R, l=$R_{C2}$] ++(0,2.4) node[vcc] {$V_{CC}$};
  \draw (Q2.E) to[R, l=$R_{E2}$] ++(0,-1.6) node[ground] {};
  \draw (Q2.C) to[C, l=$C_2$, *-] ++(1.8,0) to[short, -o] ++(0.7,0) node[right] {$v_o$};
\end{circuitikz}
```

---

## Nhãn và chú thích tiếng Việt

Tên biến/linh kiện (`$v_i$`, `$R_C$`, `$V_{CC}$`) nên để ở **chế độ toán** — trung tính
ngôn ngữ và đẹp. Chỉ khi cần **chữ tiếng Việt** (chú thích, tên khối) mới phải quan tâm
font:

- Biên dịch bằng **XeLaTeX** và nạp `fontspec` với font có dấu tiếng Việt
  (vd. `Times New Roman` có sẵn trên Windows), **hoặc**
- Dùng `pdflatex` + gói hỗ trợ tiếng Việt (`vntex`/`babel-vietnam`).

`scripts/render.ps1 -Vietnam` tự động chuyển sang `xelatex` + `Times New Roman`:

```latex
% biên dịch với: render.ps1 -Source vn.tex -Vietnam
\begin{circuitikz}[american]
  \draw (0,0) node[ground] {}
    to[V, v=$V_{\mathrm{in}}$] ++(0,2.6) coordinate (top);
  \draw (top) to[R, l={$R_S$ (hạn dòng)}, *-*] ++(2.8,0) coordinate (vo);
  \draw (vo) to[zD, l=$D_Z$, v=$V_Z$, *-*] ++(0,-2.6) node[ground] {};
  \node[right] at (vo) {\small ổn áp};
\end{circuitikz}
```

> Tránh đặt chữ tiếng Việt trong các host **TikZJax/Overleaf tối giản** trừ khi chắc chắn
> engine hỗ trợ Unicode — nên quy về nhãn toán học.

## Khi thiếu `dipchip`

`dipchip` có từ CircuiTikZ 1.5.x; nếu host cũ, thay bằng khối chữ nhật:

```latex
\begin{circuitikz}[american]
  \draw (0,0) node[draw, minimum width=2.4cm, minimum height=1.8cm, label=center:555] (U) {};
  \draw (U.west) -- ++(-0.8,0) node[left] {$2/6$};
  \draw (U.east) -- ++(0.8,0) node[right] {$3$};
  \draw (U.north) -- ++(0,0.6) node[vcc] {$V_{CC}$};
  \draw (U.south) -- ++(0,-0.6) node[ground] {};
\end{circuitikz}
```

## Biên dịch & kiểm tra bằng mắt

Script kèm sẵn dựng PDF **và** PNG để agent (hoặc bạn) tự soi lỗi — không cần đoán:

```powershell
# từ mảnh rời (sẽ tự bọc trong standalone)
pwsh ../scripts/render.ps1 -Source '\begin{circuitikz}\draw (0,0) to[R] ++(2,0);\end{circuitikz}'

# từ file, có nhãn tiếng Việt
pwsh ../scripts/render.ps1 -Source .\mycircuit.tex -Vietnam -Open
```

Kết quả in ra `STATUS=ok` + đường dẫn `PDF`/`PNG`; nếu lỗi in ra dòng log LaTeX cần sửa.

## Ghi chú dùng chung

- Nối thêm tầng / mạng phân cực: móc tiếp `to[...]` từ các tọa độ đã đặt tên.
- Thu phóng: `\ctikzset{bipoles/length=1.3cm, ...}` — đừng lạm dụng `\scalebox`.
- Điện áp/dòng ngược chiều: xem [troubleshooting.md](troubleshooting.md) mục 2.
- Chi tiết linh kiện: [components.md](components.md), [active-devices.md](active-devices.md).
