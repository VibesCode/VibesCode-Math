# Sun's p + 2^x + k·2^y: the k = 47 exceptions below 10^10

In January 2009 Zhi-Wei Sun asked, for odd k from 3 to 61, whether every odd N > 2k + 3 can be written as

N = p + 2^x + k·2^y, with p an odd prime and x, y ≥ 1.

The OEIS records the state of this question in [A155860](https://oeis.org/A155860) (the case k = 3) and [A155904](https://oeis.org/A155904) (k = 5), both by Sun (2009). Sun checked odd N below 10^8 for each k and observed that 353 fails for k = 51. Qing-Hu Hou searched to 2.5·10^7 and found that **22537515** fails for k = 47. For k = 3, Hou and Charles R Greathouse IV continued the check to 2·10^8 and 10^10. No other k = 47 exception and no further range were found published.

## The result

For k = 47, the odd N < 10^10 not of the form p + 2^x + 47·2^y (p an odd prime, x, y ≥ 1) are exactly 143 numbers. The first, 22537515, was found by Q.-H. Hou. All 143 are divisible by 1365, an observation only, with no proof of infinitely many. For every other odd k ≤ 61 except k = 51 (exception 353, Sun), there is no exception below 10^10. For k = 3 this repeats Greathouse's 10^10 check. For k = 5 (A155904) there is none below 2·10^10. Exhaustive search with two independent programs (computer-assisted).

The 143 numbers are listed in [`k47_exceptions_below_1e10.txt`](k47_exceptions_below_1e10.txt). They begin 22537515, 50574615, 67612545, 105570465, 112687575, ... and end with 9939044115.

**Status:** **computer-assisted** and **not formally verified**. There is no Lean for this result. The pattern 1365 = 3·5·7·13 is an observation: no covering-congruence argument was found, so it is not known whether k = 47 has infinitely many exceptions. Nothing is claimed beyond the stated ranges.

## Evidence

- **Exact check of the list.** [`scripts/verify.py`](scripts/verify.py) uses plain Python integers and deterministic Miller–Rabin. For each of the 143 numbers it tries every (x, y) and confirms that N − 2^x − 47·2^y is never an odd prime. It also checks that all 143 are divisible by 1365 and that 353 fails for k = 51. As a control, it confirms that N + 2 is representable for the first 20 listed N. [`scripts/k47check.py`](scripts/k47check.py) (needs gmpy2) and [`scripts/k47_tiny_check.py`](scripts/k47_tiny_check.py) (needs sympy) make the same check independently.
- **Completeness: two exhaustive programs written separately, over every odd N below 10^10 for every odd k from 3 to 61.**
  - [`scripts/sun_multik.c`](scripts/sun_multik.c) (OpenMP) builds an odd-only prime bitset to the limit and handles many k at once. Usage: `sun_multik k1,k2,... 0 N0 N1 THREADS`. Log: [`logs/sun_k3to61_to1e10.log`](logs/sun_k3to61_to1e10.log). It finds 143 exceptions for k = 47, only 353 for k = 51, and none for any other k.
  - [`scripts/sun.c`](scripts/sun.c) (pthreads) was written without reading the first program. It uses its own segmented sieve, and its prime counts are 455052510 odd primes below 10^10 and 882206715 below 2·10^10, both equal to π − 1. It was validated against a brute force for k = 47 and 51 below 2·10^6. Usage: `sun LIMIT THREADS k1 k2 ...`. Log: [`logs/sun-all-k-1e10.txt`](logs/sun-all-k-1e10.txt), 36 minutes. Its k = 47 list is identical to the first program's, and it agrees on every other k.
- **k = 5 (A155904).** [`scripts/sun_win.c`](scripts/sun_win.c), a windowed version with deterministic Miller–Rabin for large p, found no exception below 10^10 ([`logs/a155904_e1_to1e10.log`](logs/a155904_e1_to1e10.log); its only line, N = 13, is not above 2k + 3). Below 2·10^10, `sun.c` found none ([`logs/sun-k5-2e10.txt`](logs/sun-k5-2e10.txt)). So between 10^10 and 2·10^10 the published log for k = 5 comes from `sun.c` alone.
- Both exhaustive programs reproduce Sun's 353 for k = 51 and Hou's 22537515 for k = 47. `check.sh` reruns `verify.py`, plus `sun.c` and `sun_multik.c` for k = 47 and 51 below 3·10^7, where each must give exactly 353 and 22537515.

## Freshness

On 2026-11-27 the OEIS entries A155860 and A155904 named only 22537515 for k = 47 and 353 for k = 51, and gave no range above 10^8 except for k = 3. A search of the web, arXiv and GitHub found none of the other 142 numbers and no infinitude proof for k = 47. Sun's original 2009 mailing-list posts and the full text of one 2026 survey of OEIS conjectures (arXiv:2608.11941) could not be read, so a list there cannot be excluded. Nothing has been submitted to the OEIS.
