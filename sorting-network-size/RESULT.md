# Van Voorhis's recurrence for the size of sorting networks, in Lean

## The result

A Lean 4 formalization of Van Voorhis's 1972 recurrence for the size of sorting networks:

**s(n) ≥ s(n−1) + ⌈log₂ n⌉,**

where s(n) is the minimum number of comparators in a sorting network on n inputs. Combined with Harder's verified value s(11) = 35 (given as an explicit hypothesis), it yields the lower bounds s(12) ≥ 39, …, s(32) ≥ 135 listed in Dobbelaere's table.

This is a formalization of a known theorem; it gives no new bound. We found no earlier formal proof of this recurrence.

**Status:** **Proved** in Lean 4 + Mathlib (standard axioms only). The corollary bounds assume s(11) ≥ 35 as an explicit hypothesis; that value is not proved here.

## What is machine-checked

- `van_voorhis_recurrence` (in [`VibesCodeMath/SortingSize/Solution.lean`](../VibesCodeMath/SortingSize/Solution.lean)): for all m, k, if every standard sorting network on m wires has at least k comparators, then every standard sorting network on m + 1 wires has at least k + ⌈log₂(m+1)⌉ comparators (`Nat.clog 2` is ⌈log₂⌉).
- `SortNet.bounds_from_s11`: from the hypothesis `SizeLowerBound 11 35` (s(11) ≥ 35), the bounds s(12) ≥ 39, s(13) ≥ 43, s(14) ≥ 47, s(15) ≥ 51, s(16) ≥ 55, and then +5 per step up to s(32) ≥ 135.
- `SortNet.unconditional_small`: from s(1) ≥ 0 alone, s(2) ≥ 1, s(3) ≥ 3, s(4) ≥ 5, s(5) ≥ 8, s(6) ≥ 11 (these are weaker than the known exact values for n = 5, 6).

All three depend only on `propext`, `Classical.choice` and `Quot.sound`; `Verify.lean` prints this, and `check.sh` checks it.

## Definitions

The statement is in [`VibesCodeMath/SortingSize/Basic.lean`](../VibesCodeMath/SortingSize/Basic.lean) and [`Challenge.lean`](../VibesCodeMath/SortingSize/Challenge.lean). A comparator (a, b) on n wires writes the minimum of the two values on wire a and the maximum on wire b; a network is a list of comparators applied in order. A network is *standard* when a < b for every comparator, and it *sorts* when its output is nondecreasing for every input of natural numbers. `SizeLowerBound n k` says every standard sorting network on n wires has at least k comparators, that is, k ≤ s(n).

Two remarks on the definitions:

- Restricting to standard networks is the usual definition of s(n) and loses nothing for size: every sorting network can be untangled into a standard one of the same size (Floyd and Knuth; Knuth, *TAOCP* Vol. 3, §5.3.4). The Lean proof also uses an untangling step internally.
- Sorting every input of natural numbers is equivalent to sorting every 0-1 input (the 0-1 principle), so the definition is neither stronger nor weaker than the usual one.

## The argument

The proof follows Van Voorhis. Feed the network an input whose minimum sits on one wire and follow that minimum through the comparators. Over all n starting wires, the paths form a binary tree, so some starting wire's path meets at least ⌈log₂ n⌉ comparators (a Kraft-inequality count). Remove that wire and every comparator on its path, then untangle; what remains is a standard sorting network on n − 1 wires, so it has at least s(n − 1) comparators.

## Independent computation

[`scripts/check.py`](scripts/check.py) (output in [`scripts/check.out`](scripts/check.out)) checks the steps of the argument outside Lean: it computes s(n) exactly for n ≤ 6 by breadth-first search over sets of reachable 0-1 outputs (0, 1, 3, 5, 9, 12, matching the known values), confirms the recurrence on these, checks the Kraft count and the depth bound on random sorting networks, and checks the strip-and-untangle step on random sorting networks. Lean does not rely on it.

## Credits and sources

- **The recurrence:** D. C. Van Voorhis, "Toward a Lower Bound for Sorting Networks", in *Complexity of Computer Computations*, Plenum, 1972 (Springer chapter [10.1007/978-1-4684-2001-2_12](https://doi.org/10.1007/978-1-4684-2001-2_12)). Harder states it as Lemma 17 and credits it to Van Voorhis.
- **s(11) = 35 and s(12) = 39:** J. Harder, [arXiv:2012.04400](https://arxiv.org/abs/2012.04400), with a certificate checked by a program formally verified in Isabelle/HOL. Here s(11) ≥ 35 is an explicit hypothesis.
- **The table of bounds:** B. Dobbelaere, [Smallest and fastest sorting networks](https://bertdobbelaere.github.io/sorting_networks.html). The current lower bounds for 12 ≤ n ≤ 32 there are exactly the values obtained from s(11) = 35 (or s(12) = 39) by the recurrence. On 2026-11-20 that page reverted, for 13 or more inputs, a 2025 tightening of the bounds that was based on principles in Van Voorhis's paper; the bounds reproduced here are the ones that remain.

## Rebuild

From the repository root, `bash check.sh` builds everything and checks the axioms. For this result alone: `lake build VibesCodeMath.SortingSize.Verify`.
