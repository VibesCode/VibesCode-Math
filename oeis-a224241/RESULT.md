# OEIS A224241: three further terms below 1.4·10^12

OEIS [A224241](https://oeis.org/A224241) (Alex Ratushnyak, 2013) lists the numbers k such that k² XOR (k+1)² and k² XOR (k+2)² are both perfect squares, where XOR is bitwise exclusive or. The entry has 10 terms:

0, 3, 130456, 342096, 1226720, 291575011, 379894587, 523040160, 15216609776, 136622606520,

no stated search bound, and the comment "Conjecture: the sequence is infinite."

## The result

Three further terms of A224241: **248040136995, 790113072584 and 1176347566499**. These are all the terms in (136622606520, 1.4·10^12), found by exhaustive search with independent programs (computer-assisted). This is consistent with, but no evidence of proof for, the entry's conjecture that the sequence is infinite.

| k | k² XOR (k+1)² | k² XOR (k+2)² |
| --- | --- | --- |
| 248040136995 | 2019429² | 1864044² |
| 790113072584 | 1362263² | 1854790² |
| 1176347566499 | 1550565² | 2173164² |

So the terms below 1.4·10^12 are exactly the 10 known ones and these 3. Nothing is claimed beyond 1.4·10^12.

**Status:** **computer-assisted**. Each new value is checked exactly with big integers, and completeness below 1.4·10^12 rests on three exhaustive scans. It is **not formally verified**, and there is no Lean for this result.

## Evidence

- **Exact roots.** [`scripts/verify.py`](scripts/verify.py) recomputes both XOR values with Python big integers for all 13 terms and confirms the roots with `math.isqrt` (including (526887, 1962550) for the last known term). It also runs a direct brute force below 2·10⁶ and finds exactly the known terms there. Output of the original check: [`logs/python-check.txt`](logs/python-check.txt).
- **Three scans of every k in [0, 1.4·10^12).** Each finds exactly the same 13 values.
  - [`scripts/x2.c`](scripts/x2.c) uses 128-bit products, quadratic-residue filters mod 64, 63, 65 and 11, and a floating-point root corrected by exact integer steps. Run in 14 chunks; logs in [`logs/x2/`](logs/x2/), each ending with its END line.
  - [`scripts/x2b.c`](scripts/x2b.c) was written separately. It builds the 128-bit squares from 64-bit words by hand, uses different filters (mod 256, 9, 5, 7, 13, 17) and a Newton root with an exact final check. Same 14 chunks; logs in [`logs/x2b/`](logs/x2b/). Its hit list is identical to x2's.
  - [`scripts/xsq2.c`](scripts/xsq2.c) was written independently of both and runs multi-threaded (`xsq2 LO HI THREADS`). It was validated against a Python brute force on [0, 3·10⁶) and scanned the whole range in 103 minutes, printing each hit with its two roots. Log: [`logs/xsq2-0-1.4e12.txt`](logs/xsq2-0-1.4e12.txt).
- The residue filters only skip numbers that cannot be squares. A wrong filter table could miss a term but never invent one; the scans use different filters, which covers that risk.

Usage: `cc -O2 -o x2 scripts/x2.c -lm && ./x2 0 1400000000000` (the same for `x2b.c`; `xsq2.c` needs `-pthread` and a thread count). `check.sh` reruns the exact check and all three scans over [0, 2·10^7), where they must give the first five terms.

## Freshness

On 2026-11-27 the OEIS entry still had 10 terms, unchanged since April 2013, with no pending edit. A search of the web and GitHub found none of the three new terms. Adding them to the OEIS has not been done.
