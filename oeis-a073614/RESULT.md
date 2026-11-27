# OEIS A073614: a(23) = 55185648700

OEIS [A073614](https://oeis.org/A073614) (Benoit Cloitre, 2002) lists the numbers m such that m·(prime(m) + 1) is a perfect square. The entry has 22 terms, the last being a(22) = 31374585176, with the comment "a(23) > pi(10^12). [Donovan Johnson, Feb 26 2010]". Johnson also computed a(6)–a(22), and Francois Jooste added terms in 2003.

## The result

**a(23) = 55185648700** (prime(m) = 1489415921531, m·(p+1) = 286695629220²), found by exhaustive search with independent programs (computer-assisted). It extends the 2010 bound a(23) > π(10^12).

The square has a clear structure: m = 7·(2·5·13·683)² and p + 1 = 7·(2·3·11·29·241)².

**Status:** **computer-assisted** and **not formally verified**. There is no Lean for this result. Nothing is claimed about later terms.

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
- [`scripts/ps.cpp`](scripts/ps.cpp) uses the primesieve library to step through the primes. It reproduces all 22 known terms and finds a(23) as the next hit. See [`logs/ps-excerpt-to-1.5e12.txt`](logs/ps-excerpt-to-1.5e12.txt), an excerpt of its run up to 1.5·10^12.
- [`scripts/seg2.c`](scripts/seg2.c) is a short segmented sieve with an exact 128-bit integer square root and no outside libraries. It was run over (8·10^11, 10^12], which contains a(22)'s prime, and then over (10^12, 1.5·10^12]. It found exactly a(21), a(22) and then a(23). Logs: [`logs/seg2-8e11-1e12.txt`](logs/seg2-8e11-1e12.txt) and [`logs/seg2-1e12-1.5e12.txt`](logs/seg2-1e12-1.5e12.txt).
- [`scripts/mysieve.c`](scripts/mysieve.c) is a third sieve, written independently of both. It is odd-only, multi-threaded and makes two passes. It was run over (10^11, 1.5·10^12], starting from the published π(10^11) = 4118054813, and took 30 minutes on 4 cores. It found exactly a(18)–a(22), then m = 55185648700 at p = 1489415921531, and nothing else. Log: [`logs/mysieve-1e11-1.5e12.txt`](logs/mysieve-1e11-1.5e12.txt).
- The prime counts at the ends of the sieve runs match the published values: π(10^12) = 37607912018, and π(1.5·10^12) = 55563209929 (as computed by primecount). So no prime was missed or invented.

`check.sh` reruns `verify.py` and a `seg2.c` scan up to 2·10^8. That scan must reproduce the known terms there and π(2·10^8) = 11078937.

Running the full scans:
- `ps.cpp` needs primesieve: `c++ -O2 ps.cpp -lprimesieve`, then `./a.out LIMIT REPORT`.
- `seg2.c` takes `LO HI π(LO)`.
- `mysieve.c` takes `LO HI π(LO) CHUNKS THREADS`.

## Freshness

On 2026-11-27 the OEIS entry still had 22 terms and the 2010 comment, with no pending edit. A search of the web and GitHub found none of these numbers. The new term has not been submitted to the OEIS.
