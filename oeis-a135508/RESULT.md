# OEIS A135508: McEachen's conjecture for an infinite family of primes

**Status: a partial result on an open conjecture.** The full conjecture remains open.

## The conjecture

Let x(1) = 1 and x(n) = 2·x(n−1) + lcm(x(n−1), n) for n > 1, and let a(n) = x(n+1)/x(n) − 2. This is OEIS [A135508](https://oeis.org/A135508) (B. Cloitre, 2008). B. McEachen conjectured (OEIS, Sep 26 2025) that **for every prime p such that p − 2 is not prime, a(p − 1) = p.** It is formalised in DeepMind's formal-conjectures as `OeisA135508.conjecture`, which is marked open.

## The theorem

**The conjecture holds for every prime p such that p − 2 has a prime factor below 400.** That is an infinite family of primes.

As a corollary, it holds for **every prime p < 160,000**. If p < 160,000 = 400² and p − 2 is composite, then p − 2 has a prime factor at most √(p − 2) < 400. So this is one result, with a bounded consequence, not two separate ones.

In Lean ([`VibesCodeMath/OeisA135508/Challenge.lean`](../VibesCodeMath/OeisA135508/Challenge.lean)), using formal-conjectures' definitions of `x` and `a` unchanged (commit 9097e2f):

```lean
theorem a135508_conjecture_minFac_lt_400 :
    ∀ p : ℕ, p.Prime → ¬ (p - 2).Prime → (p - 2).minFac < 400 → OeisA135508.a (p - 1) = p

theorem a135508_conjecture_lt_160000 :
    ∀ p : ℕ, p.Prime → ¬ (p - 2).Prime → p < 160000 → OeisA135508.a (p - 1) = p
```

## How the proof goes

1. **Mechanism.** A prime p ≥ 5 can divide x(p − 1) only through the factor added at step p − 2. That factor is p exactly when p − 2 is coprime to x(p − 3). So if gcd(x(p − 3), p − 2) ≠ 1, then a(p − 1) = p.
2. **Reduction.** It is enough to know that every prime q divides x(q² − 1). A prime factor q of p − 2 with q² ≤ p − 2 then divides x(p − 3).
3. **Finite table.** For every prime q < 400, a listed index E(q) ≤ q² − 1 with q ∣ x(E(q)) is checked by the Lean kernel (`decide +kernel`, no `native_decide`).

## Credits and what is not new

- Cloitre, "Primes in LCM recurrences", arXiv:2510.18891 (§6), proves the conjecture conditionally on a hypothesis about the factors added at each step. He also identifies the obstacle: a bound on the least prime in an arithmetic progression.
- The reduction in step 2, in the form "every composite m with m + 2 prime shares a factor with x(m − 1)", is already known. It appears in public Lean work by open-math-agents and in senamakel/conjectures-lean, and it is implicit in Cloitre's argument. Ours is an independent re-derivation.
- Earlier checks covered p < 20,000 (senamakel/conjectures-lean, numerical). We found no earlier statement of the infinite family, or of the range p < 160,000.

## What is left open

The primes p for which p − 2 is composite and all its prime factors are at least 400. Closing those along these lines would need every prime q to enter x before step q². That is a least-prime-in-progression bound beyond current methods.

## Rerun

`lake build` from the repository root compiles `Challenge.lean`, `Solution.lean` and `Verify.lean`. `Verify.lean` prints the axioms of both theorems, `[propext, Classical.choice, Quot.sound]`.

**Memory: the kernel check of the table needs about 10 GB of free memory** (peak measured at about 8.5 GB). It takes under a minute.

`scripts/fidelity.py` recomputes a(n) from the definition, independently of the proof. Its output, in `scripts/fidelity.out`, matches the OEIS data for n ≤ 30 and confirms a(p − 1) = p for primes p ≤ 200 with p − 2 not prime.
