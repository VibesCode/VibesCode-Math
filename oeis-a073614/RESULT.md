# OEIS A073614: a(23) = 55185648700 and a(24) = 332955594488

OEIS [A073614](https://oeis.org/A073614) (Benoit Cloitre, 2002) lists the numbers m such that m·(prime(m) + 1) is a perfect square. The entry has 22 terms, the last being a(22) = 31374585176, with the comment "a(23) > pi(10^12). [Donovan Johnson, Feb 26 2010]". Johnson also computed a(6)–a(22), and Francois Jooste added terms in 2003.

## The result

**a(23) = 55185648700** (prime(m) = 1489415921531, m·(p+1) = 286695629220²), found by exhaustive search with independent programs (computer-assisted). It extends the 2010 bound a(23) > π(10^12).

The square has a clear structure: m = 7·(2·5·13·683)² and p + 1 = 7·(2·3·11·29·241)².

**Addendum (2026-11-28).** a(24) = 332955594488 (prime(m) = 9607832872831, m·(p+1) = 1788569737504²), and no further term with prime(m) ≤ 10^13, so a(25) > π(10^13). Found by exhaustive search with independent programs (computer-assisted). Here m = 62·(2·11·3331)² and p + 1 = 62·(2³·49207)². The evidence is in the section [a(24) and the range to 10^13](#a24-and-the-range-to-1013) below.

**Status:** **computer-assisted** and **not formally verified**. There is no Lean for this result. Nothing is claimed beyond prime(m) ≤ 10^13.

## Evidence

There are two separate claims, and each is checked on its own.

**1. p is the m-th prime, and the product is a square.**
- [`scripts/verify.py`](scripts/verify.py) checks the square and the factor forms exactly. It uses plain Python integers.
- The same script shows p is prime by deterministic Miller–Rabin. The prime was also confirmed by BPSW and by full trial division up to √p.
- π(p) = m was computed four ways:
  - primecount 9.1, with its default algorithm and with Legendre's formula ([`logs/primecount-a23.txt`](logs/primecount-a23.txt));
  - the sieve in `seg2.c`;
  - the sieve in `mysieve.c` (both described below).

**2. No term lies between a(22) and a(23).** Three scans with no shared code each test every prime in the gap.
- [`scripts/ps.cpp`](scripts/ps.cpp) uses the primesieve library to step through the primes. It reproduces all 22 known terms and finds a(23) as the next hit. See [`logs/ps-excerpt-to-1e13.txt`](logs/ps-excerpt-to-1e13.txt), an excerpt of its run (the A073614 lines and progress lines) up to 10^13.
- [`scripts/seg2.c`](scripts/seg2.c) is a short segmented sieve with an exact 128-bit integer square root and no outside libraries. It was run over (8·10^11, 10^12], which contains a(22)'s prime, and then over (10^12, 1.5·10^12]. It found exactly a(21), a(22) and then a(23). Logs: [`logs/seg2-8e11-1e12.txt`](logs/seg2-8e11-1e12.txt) and [`logs/seg2-1e12-1.5e12.txt`](logs/seg2-1e12-1.5e12.txt).
- [`scripts/mysieve.c`](scripts/mysieve.c) is a third sieve, written independently of both. It is odd-only, multi-threaded and makes two passes. It was run over (10^11, 1.5·10^12], starting from the published π(10^11) = 4118054813, and took 30 minutes on 4 cores. It found exactly a(18)–a(22), then m = 55185648700 at p = 1489415921531, and nothing else. Log: [`logs/mysieve-1e11-1.5e12.txt`](logs/mysieve-1e11-1.5e12.txt).
- The prime counts at the ends of the sieve runs match the published values: π(10^12) = 37607912018, and π(1.5·10^12) = 55563209929 (as computed by primecount). So no prime was missed or invented.

`check.sh` reruns `verify.py` and a `seg2.c` scan up to 2·10^8. That scan must reproduce the known terms there and π(2·10^8) = 11078937.

Running the full scans:
- `ps.cpp` needs primesieve: `c++ -O2 ps.cpp -lprimesieve`, then `./a.out LIMIT REPORT`.
- `seg2.c` takes `LO HI π(LO)`.
- `mysieve.c` takes `LO HI π(LO) CHUNKS THREADS`.

## a(24) and the range to 10^13

- [`scripts/verify.py`](scripts/verify.py) also checks the a(24) square and factor forms exactly, and shows p = 9607832872831 is prime by deterministic Miller–Rabin. It was also confirmed by BPSW and full trial division to √p.
- π(p) = 332955594488 and π(p − 1) = 332955594487 by primecount (default algorithm and Legendre's formula), with π(10^13) = 346065536839: [`logs/primecount-a24.txt`](logs/primecount-a24.txt).
- **Three scans of (1.5·10^12, 10^13].**
  - [`scripts/seg3.c`](scripts/seg3.c) is `seg2.c` plus exact quadratic-residue pre-filters (mod 64, 63, 65, 11) and an odd-only sieve. It ran in 17 chunks of 5·10^11, listed in [`logs/seg3/jobs.txt`](logs/seg3/jobs.txt). The prime count at the end of each chunk equals the start count of the next, and the last ends at π(10^13) = 346065536839. The only hit is m = 332955594488 at p = 9607832872831. Logs: [`logs/seg3/`](logs/seg3/). Usage: `seg3 LO HI π(LO)`.
  - [`scripts/mysieve.c`](scripts/mysieve.c), the independent sieve, ran over (1.5·10^12, 10^13] starting from the π(1.5·10^12) = 55563209929 it computed itself in the a(23) run. Pass 1 ended at π(10^13) = 346065536839, the published value, and pass 2 found exactly the one hit, which also gives π(p) = m independently. It took 283 minutes. Log: [`logs/mysieve-1.5e12-1e13.txt`](logs/mysieve-1.5e12-1e13.txt).
  - `ps.cpp` (primesieve) ran to 10^13 and agrees: the same single hit after a(23), ending at π(10^13) = 346065536839.
- Together with the a(23) runs this covers (10^11, 10^13] with no term other than a(18)–a(24).

`check.sh` also reruns `seg3.c` over (10^8, 2·10^8] from π(10^8) = 5761455, where it must find a(8) = 8751645 and end at π(2·10^8).

## Freshness

On 2026-11-27 the OEIS entry still had 22 terms and the 2010 comment, with no pending edit. A search of the web and GitHub found none of these numbers, for either new term. The new terms have not been submitted to the OEIS.
