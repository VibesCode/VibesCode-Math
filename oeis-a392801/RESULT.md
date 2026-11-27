# OEIS A392801 and A262783: the 14th term

- OEIS [A392801](https://oeis.org/A392801) (G. Martínez, January 2026; a(12)–a(13) by Eldar) lists the k such that the sum of the first k squarefree numbers is a perfect square.
- OEIS [A262783](https://oeis.org/A262783) (M. Marcus, 2015; a(12)–a(13) by G. Resta) lists those square sums.

Each entry has 13 terms. A262783 carries the comment "a(14) > 3*10^21. – Giovanni Resta, Aug 19 2018".

## The result

**A392801(14) = 65200913918** and **A262783(14) = 3496438273878606471921 = 59130688089²**, the sum of the squarefree numbers up to 107251204785. This is the first term beyond Resta's 2018 bound a(14) > 3·10^21. It was found by exhaustive search with independent programs and confirmed by an exact Möbius formula (computer-assisted).

The 65200913918th squarefree number is x = 107251204785 = 3·5·7150080319.

**Status:** **computer-assisted**. It is **not formally verified**, and there is no Lean for this result. The claim that no other term lies between a(13) and a(14) rests on the exhaustive scans. Nothing is claimed for x beyond 1.1·10^11.

## Evidence

- **Exact value, no sieving.** [`scripts/verify.py`](scripts/verify.py) evaluates two closed forms, where μ is the Möbius function:
  - Q(X) = Σ_{d≤√X} μ(d)⌊X/d²⌋ counts the squarefree numbers up to X.
  - S(X) = Σ μ(d)·d²·⌊X/d²⌋(⌊X/d²⌋+1)/2 is their sum.

  The script uses exact integers. It confirms Q(x) = 65200913918, S(x) = 59130688089², and S(x) − S(x−1) = x, so x is squarefree and is the k-th squarefree number. It also checks the known value Q(10^10) = 6079270942. [`scripts/qs.py`](scripts/qs.py) is a second implementation of the same forms ([`logs/formula-checks.txt`](logs/formula-checks.txt)).
- **Three independent exhaustive scans.** Each keeps a running count k and a 128-bit running sum, and tests the sum for being a square at every squarefree x.
  - [`scripts/sq1.c`](scripts/sq1.c) sieves multiples of p² in segments, filters by residues mod 64, 63, 65 and 11, and takes a corrected floating-point root.
  - [`scripts/sq2.c`](scripts/sq2.c) was written separately. It uses a bitset sieve over odd p² with a separate test mod 4, different filters (mod 256, 9, 5, 7, 13, 17) and a Newton root.
  - [`scripts/sqscan.c`](scripts/sqscan.c) is a third sieve, written independently of the other two. It ran in four chunks of x ≤ 1.1·10^11, each seeded from the closed-form (Q, S). Each chunk's end count and sum equal the closed-form values at the next boundary.

  All three find exactly the 13 known terms, then k = 65200913918, and nothing else. Logs are in [`logs/`](logs/). The scans by `sq1.c` and `sq2.c` also continue to x = 2·10^11 with no further hit, but only the range up to 1.1·10^11 was independently rechecked.
- The filters only skip sums that cannot be squares. A wrong filter table could miss a hit but never invent one. The second scan uses different filters, which covers that risk.

Usage for each scan program: `prog LO HI Q(LO) S(LO)` scans the squarefree x in (LO, HI]. For example, `./sq1 0 200000000000 0 0`. `check.sh` reruns `verify.py`, and runs all three scans up to x = 10^8, where they must give the first 11 terms.

## Freshness

On 2026-11-27 both OEIS entries still had 13 terms and no pending edits. A search of the web and GitHub found none of the four numbers. The new terms have not been submitted to the OEIS.
