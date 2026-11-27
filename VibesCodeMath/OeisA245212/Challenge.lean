module

public import FormalConjectures.OEIS.«245212»

@[expose] public section

/-! Challenge: the statement only. The proof is in `Solution.lean`. -/

/-- Partial result toward OEIS A245212's conjecture (formal-conjectures `OeisA245212.conjecture`):
if the odd part m of n = 2^k * m is squarefree, then a(n) = σ(n) holds exactly when n is a power of 2.
`OeisA245212.a` is formal-conjectures' definition (pinned commit 9097e2f), unchanged. -/
theorem a245212_squarefree_odd_part (k m : ℕ) (hm : Odd m) (hsq : Squarefree m) :
    OeisA245212.a (2 ^ k * m) = (ArithmeticFunction.sigma 1 (2 ^ k * m) : ℤ) ↔
      ∃ j : ℕ, 2 ^ k * m = 2 ^ j := by
  sorry
