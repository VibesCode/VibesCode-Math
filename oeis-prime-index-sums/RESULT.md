# Three OEIS entries on sums of the first primes, scanned to 10^13

One exhaustive pass over every prime p ≤ 10^13 (so every index up to π(10^13) = 346065536839) settles the state of three OEIS entries that are defined by running sums of the primes p_1 = 2, p_2 = 3, p_3 = 5, ...

- [A263546](https://oeis.org/A263546) (Alkan, 2015): j such that j divides p_2 + p_4 + … + p_{2j}. The entry lists 35 terms ending 164914949, with no search bound.
- [A263076](https://oeis.org/A263076) (2015): n such that the fractional part of (p_1 + … + p_n)/n is 1/2. The entry lists 10 terms ending 172616042, with the comment that there are no other terms below 10^9.
- [A153022](https://oeis.org/A153022) (Zizka, 2008): k such that k+1 divides 1 + p_1² + … + p_k². Its example is k = 6: 1 + 4 + 9 + 25 + 49 + 121 + 169 = 378 = 7·54. Terms were extended by Donovan Johnson, who also gave the bound a(11) > π(10^11) in 2010, and a(11)–a(13) were added by Robert Price in 2013.

## The results

**A263546.** Thirteen further terms of A263546 (275164386, 508494896, 522696353, 1487052875, 2995727915, 3070481703, 6925423062, 7161822550, 7631924173, 29158504547, 61241028049, 92197136467, 100242148211). These are all terms with j ≤ 173032768419 (all primes up to 10^13), by exhaustive search with independent programs (computer-assisted).

**A263076.** Two further terms of A263076, 1528366198 and 96227062386. These are all terms with n ≤ π(10^13) = 346065536839, by exhaustive search with independent programs (computer-assisted). The corresponding primes are p_n = 35528856841 and 2652721330313.

**A153022.** Under the entry's definition (k+1 divides 1 + the sum of the squares of the first k primes, as in its example), the listed a(11)–a(13) do not qualify. Exact residues: 21015366399, 34587694346, 3633680201. Each of them satisfies the condition with the index shifted by one, (k+1) | 1 + p_1² + … + p_{k+1}². The terms after a(10) up to k = π(10^13) are exactly one, 41425567038. Computer-assisted, two independent programs.

This is how we read the definition. The listed values are 33256634229, 66874977806 and 68066767730. That they come from a sum taken one prime further is our inference from the residues, not something the entry says. Under the stated definition and example, the term after a(10) = 790546908 is 41425567038 (p_k = 1105680866959), and there is no other term with k ≤ 346065536839. The 2013 search that produced the listed values is credited to its author in the entry.

**Status:** all three are **computer-assisted** and **not formally verified**. There is no Lean for these results. Nothing is claimed beyond p ≤ 10^13.

## Evidence

All programs keep exact 128-bit running sums. Each scan splits the primes into chunks, and each chunk's end state (count of primes and exact sums) must equal the next chunk's start state. The final count is π(10^13) = 346065536839, which is the published value.

- **Engine 1** uses the primesieve library. [`scripts/sums.cpp`](scripts/sums.cpp) computes each chunk's start state, and [`scripts/scan2.cpp`](scripts/scan2.cpp) (A263546, A153022) and [`scripts/scan3.cpp`](scripts/scan3.cpp) (A263076) test every prime in 40 chunks of 2.5·10^11. Logs: [`logs/engine1/`](logs/engine1/) and [`logs/engine1-batch2/`](logs/engine1-batch2/), with the start states in `chunk-start-states.txt`.
- **Engine 2**, [`scripts/e2.c`](scripts/e2.c), uses its own odd-only segmented sieve, no outside libraries, plain 128-bit remainders. It ran over all 40 chunks for A263546 and A153022, and its hits and end states are identical to engine 1's in every chunk ([`logs/engine2/`](logs/engine2/)). For A263076, [`scripts/e3.c`](scripts/e3.c) checked the two chunks that hold the new terms ([`logs/engine2-batch2/`](logs/engine2-batch2/)).
- **A third program**, [`scripts/both.c`](scripts/both.c), was written separately from the three definitions alone. It is a two-pass, multi-threaded sieve. It ran over every prime ≤ 10^13 in 224 minutes and tests all three conditions ([`logs/both-1e13.txt`](logs/both-1e13.txt)). It reproduces every listed term in range and finds exactly the new terms above, and nothing else. Its total p_1 + … + p_{π(10^13)} = 1699246443377779418889494 equals the value from a separate primesieve run. This program gives full independent coverage for A263076 as well.
- **Fixed-target checks.** [`scripts/target263546.cpp`](scripts/target263546.cpp), [`scripts/target153022.cpp`](scripts/target153022.cpp) and [`scripts/target263076.cpp`](scripts/target263076.cpp) recompute the condition at chosen indices with 64-bit modular sums from the first prime, using no saved state. Outputs: [`logs/target263546.txt`](logs/target263546.txt) (all 13 new A263546 terms give 0), [`logs/target153022.txt`](logs/target153022.txt) (the three listed values and their neighbours k ± 1 fail; 41425567038 gives 0) and [`logs/target263076.txt`](logs/target263076.txt).
- **Exact arithmetic.** [`scripts/verify.py`](scripts/verify.py) uses plain Python integers. It brute-forces all three conditions over the first 10^6 primes, where the hits must be exactly the listed terms. It then reads the exact sums of squares Q_{k−1}, Q_k, Q_{k+1} that `both.c` printed at the listed a(11)–a(13). It checks that they differ by the squares of the right primes, that (Q_k + 1) mod (k+1) gives the three residues above, and that (Q_{k+1} + 1) mod (k+1) = 0. It also checks that 41425567038 gives 0.
- The logs published here keep only the lines for these three entries and the chunk end lines. The scans tested other entries at the same time, and those lines are left out.

`check.sh` reruns `verify.py`, then `both.c`, `e2.c` and `e3.c` over all primes ≤ 2·10^8. Each must reproduce exactly the listed terms in that range ([`logs/expected-below-2e8.txt`](logs/expected-below-2e8.txt)). The full scans need several CPU-hours each: engine 1 needs primesieve (`g++ -O3 … -lprimesieve`), and `both.c` takes `HI CHUNK THREADS`.

## Freshness

On 2026-11-28 none of the new numbers appeared in the OEIS, on GitHub or on the web, apart from mirror copies of the existing data. The entries had no pending edits. A263546 had no search bound or extension. No comment on A153022 mentions another convention for its index. Nothing has been submitted to the OEIS.
