# OEIS A226472: three further terms below 10^11

OEIS [A226472](https://oeis.org/A226472) (Alex Ratushnyak, 2013) lists the numbers n such that n² XOR n(n+1)/2 is a perfect square, where XOR is bitwise exclusive or. The entry has 10 terms:

0, 1, 6, 8, 4086, 24136, 162297, 7868054, 29792904, 22666693375,

and the comment "No other terms below 2^35".

## The result

Three further terms of A226472: **42286731641, 45162001983 and 90220224758**. These are all the terms in (22666693375, 10^11). They were found by exhaustive search with independent programs.

| n | n² XOR n(n+1)/2 | square root |
| --- | --- | --- |
| 42286731641 | 1486703574849384924516 | 38557795254 |
| 45162001983 | 1657443289516732641121 | 40711709489 |
| 90220224758 | 6601669189318553963209 | 81250656547 |

So the terms below 10^11 are exactly the 10 known ones and these 3. Nothing is claimed beyond 10^11.

**Status:** **computer-assisted**. Each value is an exact square, checked with big integers, and completeness below 10^11 rests on three exhaustive scans. It is **not formally verified**, and there is no Lean for this result.

## Evidence

- **Exact roots.** [`scripts/verify.py`](scripts/verify.py) recomputes n² XOR n(n+1)/2 for all 13 terms with Python big integers and confirms each is a perfect square with `math.isqrt`. It also runs a direct brute force below 2·10⁶ and finds exactly the known terms there. Output is in [`logs/python-check.txt`](logs/python-check.txt) and can be regenerated.
- **Three independent scans of every n in [0, 10^11).** Each scan finds exactly the same 13 values.
  - [`scripts/xs.c`](scripts/xs.c) uses 128-bit products. It applies quadratic-residue filters mod 64, 63, 65 and 11, then takes a floating-point root corrected by exact integer steps. Log: [`logs/xs-0-1e11.txt`](logs/xs-0-1e11.txt).
  - [`scripts/xs2.c`](scripts/xs2.c) was written separately and has no 128-bit products. It builds the value from 64-bit words by hand, uses different filters (mod 256, 9, 5, 7, 13, 17) and a Newton root with an exact final check. Log: [`logs/xs2-0-1e11.txt`](logs/xs2-0-1e11.txt).
  - [`scripts/xsq.c`](scripts/xsq.c) was written independently of both and runs multi-threaded. Run it as `xsq LO HI THREADS`; the scan took 3 min 45 s on 4 threads. It was validated against a Python brute force below 2·10⁶. Log: [`logs/xsq-0-1e11.txt`](logs/xsq-0-1e11.txt).
- The residue filters only skip numbers that cannot be squares. A wrong filter table could miss a term but never invent one. The second scan uses different filters, which covers that risk.
- All three scans reproduce the 10 known terms and their roots, and find nothing else below 2^35, in agreement with the OEIS comment.

Usage: `cc -O2 -o xs scripts/xs.c -lm && ./xs 0 100000000000` (the same for `xs2.c`). `check.sh` reruns the exact check and both single-threaded scans over [0, 10^8), where they must give the first nine terms. The full [0, 10^11) scan takes a few minutes per program on a modern CPU.

## Freshness

On 2026-11-27 the OEIS entry still had 10 terms and the 2^35 comment. A search of the web and GitHub found none of the three new terms or their roots. Adding them to the OEIS has not been done.
