# An explicit form of Ono's Corollary 1.2, checked in Lean

Let x_n = tan(arctan 1 + arctan 2 + ⋯ + arctan n). Write ∏ₖ₌₁ⁿ (1 + k i) = A_n + B_n i, so x_n = B_n / A_n.

## The theorem

**For every n ≥ 5 that is not in the exceptional set E, x_n is not an integer.**

Here E = {n ≥ 5 : A_n = 0 or |x_n| > n/2 + 1}. This is formal-conjectures' `exceptional`, at the pinned commit 9097e2f, with its definitions unchanged. Ono's E is {n ≥ 5 : |x_n| > n/2 + 1}. The extra case A_n = 0 does not weaken the theorem, because there A_n ∣ B_n would force B_n = 0 as well, and the product ∏(1 + k i) is never 0.

In Lean ([`VibesCodeMath/TanArctanExplicit/Challenge.lean`](../VibesCodeMath/TanArctanExplicit/Challenge.lean)):

```lean
theorem tan_arctan_not_integer_outside_exceptional :
    ∀ n : ℕ, 5 ≤ n → n ∉ Arxiv.«2607.05739».exceptional → ¬ Arxiv.«2607.05739».IsIntegerValue n
```

`IsIntegerValue n` means A_n ∣ B_n.

K. Ono (arXiv:2607.05739, July 2026, Corollary 1.2) proves this for all n ≥ n₀ with an effective but unspecified n₀. The result here makes it explicit, with **n₀ = 5**, and the whole proof is checked by the Lean kernel.

## What it does not say

- **It does not settle the Amdeberhan–Medina–Moll conjecture** that x_n is never an integer for n ≥ 5. It says nothing about n in E.
- **The exceptional set E is untouched.** E is not known to be finite. Its first members are 15, 17, 80, 82, 395, 397, 1904, 1906, 9163, 9165, 44086, 44088. For the members below 1.2·10⁸, see [`../tan-arctan-sum/`](../tan-arctan-sum/RESULT.md), which checks every n up to 1.2·10⁸ directly.
- **The mathematics builds on Ono's lemmas.** The mechanism is his: two distinct primes p > 2n dividing numbers 1 + k² with k ≤ n force |x_n| ≥ 2n + 2, which puts n in E. What is new is the explicit constant, and a complete machine-checked proof.

## How the proof goes ([`Solution.lean`](../VibesCodeMath/TanArctanExplicit/Solution.lean))

1. **Two primes.** If two distinct primes p₁, p₂ > 2n divide 1 + k₁² and 1 + k₂² with k₁, k₂ ≤ n, then |x_n| ≥ 2n + 2, so an integer value of x_n forces n ∈ E. (`TwoPrimes`)
2. **Small n.** Twelve explicit prime certificates, such as 37 | 1 + 6² and 41 | 1 + 9², cover every 5 ≤ n ≤ 499,950,001,250. Each prime and each divisibility is checked by `decide` or `norm_num`. (`Certs`)
3. **Large n.** For n ≥ 499,950,001,251, the two primes exist by a Chebyshev-type argument. It uses valuation counting over the numbers 1 + k², Stirling's bound, Mathlib's θ(x) ≤ x log 4, and a kernel-checked lower bound for the sum of log p / p over primes p ≤ 20000 with p ≢ 1 (mod 4). (`TanH`)

The scripts in `scripts/` produced the data tables used in step 3 (`gencert.py`) and the numeric constants (`constants.py`). Lean rechecks every value they produced. The scripts are only there to show where the numbers came from.

`scripts/fidelity.py` recomputes A_n and B_n in exact Gaussian-integer arithmetic, separately from the Lean definitions. Its output (`scripts/fidelity.out`) matches Ono's Table 1 and gives E ∩ [5, 2000] = {15, 17, 80, 82, 395, 397, 1904, 1906}, as in his Remark 3.3. This checks that the formal definitions say what the paper says.

## Rerun

From the repository root, with [elan](https://github.com/leanprover/elan) installed:

```bash
lake exe cache get   # Mathlib build cache
lake build
```

`lake build` compiles `Challenge.lean` (the statement, ending in `sorry`), `Solution.lean` (the proof) and `Verify.lean`. `Verify.lean` restates the claim word for word, proves it with the theorem from `Solution.lean`, and prints:

```
'target_check' depends on axioms: [propext, Classical.choice, Quot.sound]
```

There are no errors. The expected warnings are the `sorry` in `Challenge.lean` and some style-linter notes. The proof takes about a minute once Mathlib is built.
