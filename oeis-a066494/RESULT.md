# OEIS A066494 and A066516 are complete, unconditionally

Write p_k for the k-th prime (p_1 = 2), g_k = p_{k+1} − p_k, φ for Euler's totient and σ for the sum of divisors.

- **A066494**: numbers n such that prime(n+1) − prime(n) = φ(n), i.e. g_n = φ(n).
- **A066516**: numbers n such that g(σ(n)) = φ(n), where g(n) = prime(n+1) − prime(n).

## The result

**A066494 is exactly {1, 3, 8, 9, 12, 18, 24}, and A066516 is exactly {1, 4, 5, 15, 18, 30, 36}.**

For A066516 the OEIS had this only on the Riemann hypothesis (comment by Charles R Greathouse IV, 2011). For A066494 a 2006 comment by Franklin T. Adams-Watters called the sequence "certainly finite and very likely complete", with no proof.

For n ≥ 688,383, Dusart's explicit bounds for prime gaps and for p_k, together with the Rosser–Schoenfeld lower bound for φ(n), force the gap to be smaller than φ(n). The range below that is an exact computation. The method is standard. What is new is only the explicit, complete closure.

## What rests on what

1. **The reduction: checked in Lean 4 + Mathlib, with the three published bounds as explicit hypotheses.** [`VibesCodeMath/OeisA066494/Challenge.lean`](../VibesCodeMath/OeisA066494/Challenge.lean) states `a066494_a066516_reduction`: if the three bounds below hold, then for every n ≥ 688,383, prime(n+1) − prime(n) ≠ φ(n) and prime(σ(n)+1) − prime(σ(n)) ≠ φ(n). ([`Solution.lean`](../VibesCodeMath/OeisA066494/Solution.lean) proves it, and [`Verify.lean`](../VibesCodeMath/OeisA066494/Verify.lean) restates it and prints the axioms: `propext`, `Classical.choice`, `Quot.sound` only.) `Nat.nth Nat.Prime (k − 1)` is the k-th prime.
2. **The three bounds: cited, not proved in Lean.** They are true published theorems, so the hypotheses are not vacuous.
   - (D1) P. Dusart, "Estimates of some functions over primes without R.H.", arXiv:1002.0442, Prop. 6.8: for all real x ≥ 396,738 there is a prime p with x < p ≤ x(1 + 1/(25 ln² x)).
   - (D2) Same paper, Prop. 6.6: for k ≥ 688,383, p_k ≤ k(ln k + ln ln k − 1 + (ln ln k − 2)/ln k).
   - (RS) J. B. Rosser and L. Schoenfeld, Illinois J. Math. 6 (1962) 64–94, Theorem 15: for every integer n ≥ 3, n/φ(n) < e^γ ln ln n + 2.50637/ln ln n. We read this as quoted by Axler (arXiv:2404.17165, Theorem 8) and Nicolas (arXiv:1202.0729), since the journal PDF was not accessible to us. The proof has slack: any constant up to 3.125 in place of 2.50637 works, and so does any constant C ≥ 20.06 in place of 25 in (D1).
3. **The range n < 688,383: exact computation.** Two independently written programs, plus a third check, list every term for n ≤ 10⁶ (one of them up to 3·10⁶) and find exactly the seven terms of each sequence.

## The proof in short

- **Gap bound.** For k ≥ 688,383, (D1) at x = p_k and (D2) give g_k ≤ p_k/(25 ln² p_k) ≤ 2k/(25 ln k).
- **Totient bound.** For n ≥ 688,383, with ℓ = ln ln n ≥ 2.59, (RS) and e^γ < 2 give n/φ(n) < B := 2ℓ + 2.50637, and 2B² ≤ 25(1 + ℓ + ℓ²/2) ≤ 25 ln n.
- **A066494.** g_n ≤ 2n/(25 ln n) < n/B < φ(n).
- **A066516.** With m = σ(n): σ(n)φ(n) < n² gives m < n·n/φ(n), so g_m ≤ 2m/(25 ln m) < 2n(n/φ(n))/(25 ln n) ≤ φ(n), since 2(n/φ(n))² ≤ 25 ln n.

## Programs ([`scripts/`](scripts/))

| Program | Method | Log |
| --- | --- | --- |
| `check_a.py` | numpy sieves for φ, σ and the primes | `check_a-1e6.log` (n ≤ 10⁶) |
| `check_b.c` | C, smallest-prime-factor table, written separately from a plain specification | `check_b-1e6.log`, `check_b-3e6.log` (n ≤ 3·10⁶) |
| `finite_check.py` | a third, separately written numpy check | n ≤ 10⁶ |
| `check_links.py` | each numerical link of the proof (constants in interval or exact arithmetic), and, as sanity checks of the transcriptions, (D1), (D2) and (RS) on data, and the full chain on every n in [688,383, 3·10⁶] | `check_links-3e6.log` |

All report S1 = {1, 3, 8, 9, 12, 18, 24} and S2 = {1, 4, 5, 15, 18, 30, 36}. For 100 < n ≤ 3·10⁶ the largest ratios are g_n/φ(n) = 18/48 (n = 180) and g_{σ(n)}/φ(n) = 14/32 (n = 120).

```bash
cc -O2 -o check_b oeis-a066494/scripts/check_b.c -lm && ./check_b 1000000   # compare with check_b-1e6.log
```

## Credits and status

The questions come from the OEIS entries and their comments, in particular Franklin T. Adams-Watters's 2006 comment on A066494, the search bounds recorded on A066516 (to 10⁶ in 2002, to 2·10¹⁷ by Charles R Greathouse IV in 2011) and Greathouse's RH-conditional completeness comment. The analytic input is Dusart's and Rosser–Schoenfeld's. We found no earlier unconditional proof (OEIS entries and histories, GitHub, the web, Nov 27 2026). This is a small result.
