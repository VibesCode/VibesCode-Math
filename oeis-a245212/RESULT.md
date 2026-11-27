# OEIS A245212: the case of a squarefree odd part

**Status: a partial result on an open conjecture.** The full conjecture remains open.

## The conjecture

Let a(n) = n·τ(n) − Σ d·τ(d), where the sum runs over the divisors d of n with d < n, and τ counts divisors. This is OEIS [A245212](https://oeis.org/A245212). The conjecture recorded there (2014) says that a(n) = σ(n), the sum of the divisors of n, exactly when n is a power of 2. It is formalised in DeepMind's formal-conjectures as `OeisA245212.conjecture`, which is marked open.

## The theorem

**Write n = 2^k·m with m odd. If m is squarefree, then a(n) = σ(n) holds exactly when n is a power of 2.**

In Lean ([`VibesCodeMath/OeisA245212/Challenge.lean`](../VibesCodeMath/OeisA245212/Challenge.lean)), using formal-conjectures' definition of `a` unchanged (commit 9097e2f):

```lean
theorem a245212_squarefree_odd_part (k m : ℕ) (hm : Odd m) (hsq : Squarefree m) :
    OeisA245212.a (2 ^ k * m) = (ArithmeticFunction.sigma 1 (2 ^ k * m) : ℤ) ↔
      ∃ j : ℕ, 2 ^ k * m = 2 ^ j
```

## Why it is true

Let G(n) = Σ_{d ∣ n} d·τ(d). Then a(n) = 2n·τ(n) − G(n), so a(n) = σ(n) is the same as G(n) + σ(n) = 2n·τ(n), and G(n) + σ(n) would have to be even. Both G and σ are multiplicative. G(2^k) = k·2^(k+1) + 1 is odd. For an odd prime p, G(p) = 1 + 2p is odd and σ(p) = p + 1 is even. So when the odd part is squarefree and greater than 1, G(n) is odd and σ(n) is even, and equality is impossible. Powers of 2 do satisfy it: a(2^k) = 2^(k+1) − 1 = σ(2^k).

## What is left open

Odd parts with a repeated prime factor. The parity argument settles some of them but not all. A search over every odd part m ≤ 5·10⁷, with every power of 2, found no counterexample, but it did find near misses as close as 2 parts in 10⁸ (m = 5,983,569, k = 3). This is `engine/oddpart.c`, with its output in `engine/run50M.out`.

## Novelty

This is a short parity argument. We found no earlier proof of this case, but we cannot rule out that it is folklore. Earlier formal work we know of covers only prime powers.

## Rerun

`lake build` from the repository root compiles `Challenge.lean`, `Solution.lean` and `Verify.lean`. The last prints `'a245212_target_check' depends on axioms: [propext, Classical.choice, Quot.sound]`. `scripts/fidelity.py` checks the definition directly for n ≤ 20000 (output in `scripts/fidelity.out`). To rerun the search: `cc -O2 -o oddpart engine/oddpart.c && ./oddpart 50000000`.
