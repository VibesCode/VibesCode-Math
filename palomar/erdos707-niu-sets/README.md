# Niu's candidate counterexamples to Erdős Problem 707, in cyclic planes of order divisible by 2 or 3

A **Sidon set** is a set of integers whose pairwise differences are all distinct. A **perfect difference set** modulo n is a set B whose differences a − b (a ≠ b in B) hit every nonzero residue mod n exactly once. If |B| = q + 1, then n = q² + q + 1 and B is a cyclic projective plane of **order** q.

**Erdős Problem 707** asks whether every finite Sidon set is contained in a perfect difference set.
- Every Sidon set of size 3 extends (Sawin, MathOverflow 501983).
- Alexeev and Mixon (arXiv:2510.19804) found Sidon sets of size 5 that do not extend, and proved {1,2,4,8} does not extend for prime orders p.
- Niu (arXiv:2604.25214) proposed {0,1,3,11} and {0,1,4,11} as size-4 counterexamples. Mueller (MathOverflow answer 502053) proved that neither set lies in any Singer (Desarguesian) difference set. Whether they lie in some other cyclic plane is open, because it is not known that every cyclic plane is Desarguesian.

## What this repository proves

Both theorems hold for every modulus n, with no assumption that the order is a prime power or that the plane is Desarguesian. They are checked by Lean with Mathlib, using only the three standard axioms.

1. **`niu_sets_not_in_even_order_pds`.** Neither {0,1,3,11} nor {0,1,4,11} lies in a perfect difference set of even order. Mueller stated this for {0,1,3,11} without proof (Remark 2 of his answer). Here it is proved, and for {0,1,4,11} as well.
2. **`niu_set_not_in_pds_of_order_div_two_or_three`.** {0,1,3,11} lies in no finite perfect difference set whose order is divisible by 2 or by 3. We found no earlier written argument for orders divisible by 3.

## How the proofs work

- **Even order (Baer).** If the order is even, a parity argument (an odd set has no fixed-point-free involution) shows that every translate of 2·B meets B. From this, 2·B is a translate of B. Following the doubling through {0,1,3,11} or {0,1,4,11} forces two equal differences, which a Sidon set cannot have.
- **Order divisible by p = 2 or 3 (Hall).** Hall's multiplier theorem is proved here from scratch for planar difference sets: if a prime p divides the order and is a unit mod n, then p·B is a translate of B. The proof uses the Frobenius map in the group algebra (ZMod p)[ZMod n] and a counting argument. For {0,1,3,11} the multiplier and its translate are then forced:
  - for p = 2, the translate is −1, so 7 ∈ B, but 11 − 7 = 7 − 3;
  - for p = 3, the translate is 0, so 9 ∈ B, but 9 − 1 = 11 − 3.

## What this does not do

It does not settle Erdős 707. Orders whose prime factors are all at least 5 remain open for {0,1,3,11}, and odd orders remain open for {0,1,4,11}. The classical ingredients (Baer 1946, Hall 1947) are not new. What is new is applying them to Niu's sets, the case of orders divisible by 3, and the complete formal proofs, including a Lean proof of Hall's planar multiplier theorem.

## Files and how to check

- `Challenge.lean`: the two statements. The definition `IsPerfectDifferenceSet` is copied verbatim from formal-conjectures at commit 9097e2f.
- `Solution.lean`: the proofs.
- `comparator.json`: Comparator compares the two theorems and allows only `propext`, `Quot.sound` and `Classical.choice`.
- `bash scripts/verify-comparator.sh`: runs `lake comparator` with the kernels bundled in Lean v4.35.0. This needs `bwrap`.

## How it was made

- **AI use.** AI-assisted using Claude models, directed by VibesCode. The proof was written with AI assistance and is checked by Lean.
- **Statements.** The formal statements were compared against the sources.
- **Human review.** No human expert has reviewed it yet.
- **Licence.** Apache-2.0 (see the repository's LICENSE). The copied definition is from formal-conjectures, also Apache-2.0.

## Sources

- Erdős Problem #707, erdosproblems.com/707.
- T. Niu, *Size-4 Counterexamples to the Sidon-Extension Conjecture*, arXiv:2604.25214 (2026).
- P. Mueller and W. Sawin, answers to MathOverflow question 501983 (2025).
- B. Alexeev and D. G. Mixon, *Forbidden Sidon subsets of perfect difference sets, featuring a human-assisted proof*, arXiv:2510.19804.
- R. Baer, *Polarities in finite projective planes*, Bull. Amer. Math. Soc. 52 (1946), 77–93.
- M. Hall Jr., *Cyclic projective planes*, Duke Math. J. 14 (1947), 1079–1090.
