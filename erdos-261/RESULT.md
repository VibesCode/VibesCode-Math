# Erdős Problem 261(ii): checked for every n ≤ 10^6

## The problem

[Erdős Problem 261](https://www.erdosproblems.com/261), part (ii), asks whether every positive integer n has a representation

n/2^n = Σ_{k∈S} k/2^k

for some finite set S of at least two distinct positive integers. The problem is open. Tengely, Ulas and Zygadło (J. Number Theory 217 (2020) 445–459, [arXiv:2008.01501](https://arxiv.org/abs/2008.01501)) checked every n ≤ 10^4.

## The result

This is a computer check that Erdős Problem 261(ii) holds for every n ≤ 10^6: each such n/2^n is a sum of k/2^k over at least two distinct k. It extends the published range n ≤ 10^4 (Tengely, Ulas and Zygadło, 2020) and the n ≤ 10^5 reported online by P. White (July 2026, [erdosproblemaday.com/report/261](https://erdosproblemaday.com/report/261), labelled there as a partial, computational report). The hardest case is n = 734946, whose representation uses terms up to n + 7,431,262. It was checked by independent programs.

**Status:** a **computation, not a proof**. The problem remains open.

## How the check works

Every k in S exceeds n: k/2^k decreases for k ≥ 2, and k = n would leave nothing for the other terms.

Write E_m = 2^m·(n/2^n − Σ_{k∈S, k≤m} k/2^k). Then:
- E_m is an integer, and E_n = n.
- At each step E_{m+1} = 2E_m (m+1 is not in S) or E_{m+1} = 2E_m − (m+1) (m+1 is in S).
- A representation exists exactly when some sequence of choices reaches E = 0.
- The tail Σ_{k>m} k/2^k is less than (m+2)/2^m, so any useful E_m satisfies 0 ≤ E_m ≤ m+1. Each program uses this bound, or the looser m+3.

So the search keeps the set of all live values of E at each level, which is never more than a handful. It is exhaustive, not greedy. For n ≥ 2, reaching 0 always uses at least two terms. n = 1 is checked directly: 1/2 = 3/8 + 6/64 + 8/256.

## Programs and logs

| Program | What it does | Range | Log |
| --- | --- | --- | --- |
| [`scripts/mine.c`](scripts/mine.c) | Full live-set walk with bound m+1; at most 2 live values were ever needed | n = 2 … 10^6, in 4 chunks, about 2.7 CPU-hours | `logs/mine-chunk-*.txt` |
| [`scripts/e261.c`](scripts/e261.c) | Separately written walk with bound m+3; at most 4 live values | n = 10001 … 10^6 (smaller n are covered by the published check and by the other programs) | `logs/e261-10001-1e6.txt` |
| [`scripts/check3.c`](scripts/check3.c) | Walk with parent pointers. It reconstructs the set S for each n and verifies n·2^(M−n) = Σ k·2^(M−k) modulo the primes 2^61 − 1 and 4611686018427387847. A mutated version flags every n, so the check can fail. | n = 10001 … 10^6, in overlapping chunks | `logs/c3*.txt` |
| [`scripts/verify_small.py`](scripts/verify_small.py) | Rebuilds S and checks the sum with exact rational arithmetic | n = 1 … 300 | (rerun) |

Every run reported 0 failures. The record depths agree between `mine.c` and `e261.c`: 179881 needs 3,074,405 levels, 644534 needs 4,417,226, and the worst case 734946 needs 7,431,262.

The `check3.c` chunks overlap and together cover 10001 … 10^6. Three of the chunk logs stop at a progress line rather than a final line: 340001 … 590000, 670001 … 890000 and 890001 … 980000. The chunks that follow them start below those progress lines and finish with their final line, so every n in the range is covered.

`check.sh` reruns `verify_small.py`, and runs `mine.c` and `e261.c` over n = 2 … 10^4, with no failures allowed. To rerun the full range: `cc -O2 -o mine scripts/mine.c && ./mine 2 1000000`. That takes roughly 3 CPU-hours.

## What this is not

It is not a proof of 261(ii). The walk behaves like an erratic, Collatz-like orbit, and nothing here bounds the depth needed for general n.

## Freshness

On 2026-11-27, erdosproblems.com/261 cited only n ≤ 10^4, and no forum comment gave a larger range. The only larger claim found was P. White's n ≤ 10^5 report. Searches of GitHub and the web found no claim of 10^6. Nothing has been posted to erdosproblems.com.
