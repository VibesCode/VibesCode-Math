# When is tan(arctan 1 + arctan 2 + ⋯ + arctan n) a whole number?

Add up the angles arctan 1, arctan 2, …, arctan n and take the tangent of the total. Call the result x_n.

- **Small cases.** For n = 1, 2, 3, 4 you get the integers 1, −3, 0 and 4. From n = 5 on, every value anyone has computed is a fraction. For example, x_5 = −9/19.
- **The conjecture.** In 2008 Amdeberhan, Medina and Moll conjectured that x_n is never an integer again once n ≥ 5. That is still open.
- **Where it stood.** In July 2026 Ken Ono proved the conjecture holds for almost every n. His Corollary 1.2 says x_n is not an integer for every n ≥ n₀ outside a sparse "exceptional set" E. E holds the indices where |x_n| is unusually large, more than n/2 + 1. Ono shows E is sparse (at most O(log N) members up to N). Its known members come in pairs, roughly one pair for every factor of e^{π/2} ≈ 4.8 in n: 15, 17, 80, 82, 395, 397, …. His n₀ is computable in principle, but he never says what it is.

## What this repository proves

**n₀ = 5.** For every n ≥ 5 outside Ono's exceptional set E, x_n is not an integer. The statement and proof are fully checked by the Lean proof assistant, using Mathlib. Only the three standard axioms are used, and there are no unproved assumptions.

## How the proof works, in plain words

1. **The Gaussian-integer picture.** Write (1 + i)(1 + 2i)⋯(1 + ni) = A + Bi. Then x_n = B/A, and A² + B² = (1 + 1²)(1 + 2²)⋯(1 + n²).
   - If x_n = m is an integer, then B = mA. So the product (1 + 1²)⋯(1 + n²) equals A²(1 + m²).
2. **Big primes force a big m.** Take a prime p larger than 2n that divides one of the numbers 1 + k².
   - It divides only that one, and only once, so it cannot divide A². It must therefore divide 1 + m².
   - Two different such primes force 1 + m² to exceed (2n + 1)(2n + 2).
   - That makes |m| ≥ 2n + 2. This is bigger than n/2 + 1, so n would have to be in the exceptional set E.
3. **Such primes always exist.**
   - For n up to about 5·10¹¹: twelve explicit primes do the job, each checked in Lean. One example is 999,900,002,501 = 1 + 999,950², which covers every n from 999,950 to about 5·10¹¹.
   - For larger n: a counting argument in the style of Chebyshev. If at most one of the numbers 1 + k² had a prime factor above 2n, the product of all of them would be too small. Mathlib supplies the ingredients: Stirling's formula and Chebyshev's bound on primes. The only numerical input is a sum over the primes below 20,000, which Lean verifies itself.

## What this does not do

- **It does not prove the full conjecture.** The exceptional set E is not known to be finite, and its members still have to be handled some other way.
- **It is a modest result.** It makes a published theorem explicit; it is not a new method. The key mechanism, primes above 2n dividing exactly one factor, is already in Ono's paper.

## Relation to the existing formalization

Ono's paper was formalized by AxiomProver ([AxiomMath/TanArctan](https://github.com/AxiomMath/TanArctan)): the kernel divisibility theorem, the proximity lemma for E, and the count #(E ∩ [1, N]) = O(log N). The paper's Appendix A notes that the growth estimate of Lemma 2.3 was not included there, so the half of Corollary 1.2 that says x_n is not an integer for n ≥ n₀, n ∉ E was not formalized. This repository supplies that half, with the explicit value n₀ = 5. It uses none of that repository's code.

## Files and how to check

- `Challenge.lean`: the statement (about 60 lines). The definitions are copied verbatim from formal-conjectures at commit 9097e2f.
- `Solution.lean`: the proof.
- `comparator.json`: Comparator compares `tan_arctan_not_integer_outside_exceptional` and allows only `propext`, `Quot.sound` and `Classical.choice`.
- `bash scripts/verify-comparator.sh` runs `lake comparator` with the Lean, NanoDa and con-ron kernels bundled in Lean v4.35.0. This needs `bwrap`.

## How it was made

- **AI use.** AI-assisted using Claude models, directed by VibesCode. The proof was written with AI assistance and is checked by Lean.
- **Statement.** The formal statement was compared against Corollary 1.2 of Ono's paper. The definitions are formal-conjectures' upstream ones, unchanged. Their only difference from Ono's E is that an index with A_n = 0 (a pole of the tangent) also counts as exceptional. That does not weaken the theorem, because x_n can never be an integer there. A_n and B_n were recomputed exactly for n ≤ 2000, reproducing Ono's Table 1 and his list of exceptional n.
- **Computation.** Exact computer checks found no integer value of x_n for 5 ≤ n ≤ 1.2·10⁸.
- **Human review.** No human expert has reviewed it yet.
- **Licence.** Apache-2.0 (see the repository's LICENSE). The copied definitions are from formal-conjectures, also Apache-2.0.

## Sources

- K. Ono, *Integer values of tan(arctan 1 + arctan 2 + ⋯ + arctan n) are rare*, arXiv:2607.05739 (2026).
- T. Amdeberhan, L. A. Medina, V. H. Moll, *Arithmetical properties of a sequence arising from an arctangent sum*, J. Number Theory 128 (2008), 1807–1846.
- Definitions follow formal-conjectures (google-deepmind/formal-conjectures, Apache 2.0) and AxiomMath/TanArctan.
