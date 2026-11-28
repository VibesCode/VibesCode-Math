# McEachen's conjecture for OEIS A135508: all primes below 160,000 and an infinite family

Let x(1) = 1 and x(n) = 2·x(n−1) + lcm(x(n−1), n), and let a(n) = x(n+1)/x(n) − 2. This is OEIS A135508. In 2025 Bill McEachen conjectured that **a(p − 1) = p for every prime p such that p − 2 is not prime**. Cloitre (arXiv:2510.18891, Section 6) proved this assuming an unproved hypothesis about the values of the recurrence.

## What this repository proves

Both results are unconditional and checked by Lean with Mathlib, using only the three standard axioms.

1. **`a135508_conjecture_lt_160000`:** the conjecture holds for every prime p < 160,000.
2. **`a135508_conjecture_minFac_lt_400`:** the conjecture holds for every prime p, of any size, whose p − 2 has its smallest prime factor below 400. This is an infinite family.

## The idea in plain words

- For p ≥ 5, a(p − 1) = p is equivalent to: the composite number m = p − 2 shares a prime factor with x(m − 1). This reformulation is implicit in Cloitre's argument and also appears in other public notes.
- Once a prime q divides some x(k), it divides every later x(n).
- So it is enough to know that each prime q has entered the sequence by step q² − 1. A composite m whose smallest prime factor is q satisfies m ≥ q², so m then shares the factor q with x(m − 1).
- Lean checks by kernel computation that every prime q < 400 divides x(q² − 1). That gives the infinite family.
- Every composite p − 2 < 160,000 has a prime factor below 400, so the family also covers all primes p < 160,000.

## What this does not do

It does not prove the full conjecture. For primes q ≥ 400, the statement "q divides x(q² − 1)" would follow from a bound on the least prime in an arithmetic progression with exponent below 2, which is beyond current methods. Cloitre reaches the same barrier.

## Files and how to check

- `Challenge.lean`: the two statements. The definitions of x and a are copied verbatim from formal-conjectures at commit 9097e2f.
- `Solution.lean`: the proofs.
- `comparator.json`: Comparator compares the two theorems and allows only `propext`, `Quot.sound` and `Classical.choice`.
- `bash scripts/verify-comparator.sh`: runs `lake comparator` with the kernels bundled in Lean v4.35.0. This needs `bwrap`.

## How it was made

- AI-assisted using Claude models, directed by VibesCode. The proof was written with AI assistance and is checked by Lean.
- The formal statements were compared against the OEIS entry.
- No human expert has reviewed it yet.
- Licence: Apache-2.0. The copied definitions are from formal-conjectures, which is also Apache-2.0.

## Sources

- OEIS A135508, conjecture by Bill McEachen (Sep 26 2025).
- B. Cloitre, *Primes in LCM recurrences*, arXiv:2510.18891.
- Related Lean work: GuillaumeBAUD-coder/open-math-agents (conditional reductions of the same conjecture).
- Related notes: senamakel/conjectures-lean (numerical check for p < 20,000).
