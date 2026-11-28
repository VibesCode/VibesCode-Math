# Van Voorhis's recurrence for the size of sorting networks, in Lean

Let s(n) be the minimum number of comparators in a sorting network on n inputs. Van Voorhis proved

**s(n) ≥ s(n−1) + ⌈log₂ n⌉**

(D. C. Van Voorhis, "An Improved Lower Bound for Sorting Networks", IEEE Trans. Comput. C-21(6), 1972, pp. 612–613). This package proves it in Lean 4 with Mathlib, using only the standard axioms.

## What is proved

- `van_voorhis_recurrence`: for all m and k, if every standard sorting network on m wires has at least k comparators, then every standard sorting network on m + 1 wires has at least k + ⌈log₂(m+1)⌉ comparators (`Nat.clog 2` is ⌈log₂⌉).
- `SortNet.bounds_from_s11`: from the hypothesis s(11) ≥ 35 (Harder, arXiv:2012.04400, verified with an Isabelle/HOL-checked certificate checker), the bounds s(12) ≥ 39, s(13) ≥ 43, …, s(16) ≥ 55, then +5 per step up to s(32) ≥ 135. These are the lower bounds in Dobbelaere's table. The value s(11) ≥ 35 is an explicit hypothesis, not proved here.

This is a formalization of a known theorem. It gives no new bound. We found no earlier formal proof of the recurrence.

## Definitions

A comparator (a, b) on n wires writes the minimum of the two values on wire a and the maximum on wire b; a network is a list of comparators applied in order. A network is *standard* when a < b for every comparator, and it *sorts* when its output is nondecreasing for every input of natural numbers. `SizeLowerBound n k` says every standard sorting network on n wires has at least k comparators, that is, k ≤ s(n).

Restricting to standard networks is the usual definition of s(n) and loses nothing for size, since any sorting network can be untangled into a standard one of the same size (Knuth, *TAOCP* Vol. 3, §5.3.4); the proof itself also untangles. Sorting every input of natural numbers is equivalent to sorting every 0-1 input.

## The argument

Feed the network an input whose minimum sits on one wire and follow that minimum through the comparators. Over all n starting wires the paths form a binary tree, so a Kraft-type count gives a starting wire whose path meets at least ⌈log₂ n⌉ comparators. Remove that wire and every comparator on its path, and untangle: what remains is a standard sorting network on n − 1 wires.

## Checking

`Challenge.lean` holds the definitions and the statements; `Solution.lean` holds the same definitions and the proofs. `scripts/verify-comparator.sh` runs `lake comparator` with the kernels bundled in the Lean toolchain (Lean, NanoDa and con-ron), as Palomar does.

## Credits

The recurrence is Van Voorhis's (1972); Harder states it as Lemma 17 of arXiv:2012.04400. s(11) = 35 is Harder's. The table of bounds is Bert Dobbelaere's. The Lean proof was written with AI assistance (Claude models, directed by VibesCode) and is checked by Lean; no human mathematician has reviewed it.

Licence: Apache-2.0 (see the repository root).
