module

public import FormalConjectures.OEIS.«135508»

@[expose] public section

/-! Challenge: the statements only. The proofs are in `Solution.lean`. -/

/-- McEachen's A135508 conjecture for every prime p whose p - 2 has smallest prime factor
(Mathlib's `Nat.minFac`) below 400: then a(p - 1) = p. An infinite family. Definitions
`OeisA135508.x` and `OeisA135508.a` are formal-conjectures' (pinned commit 9097e2f), unchanged. -/
theorem a135508_conjecture_minFac_lt_400 :
    ∀ p : ℕ, p.Prime → ¬ (p - 2).Prime → (p - 2).minFac < 400 → OeisA135508.a (p - 1) = p := by
  sorry

/-- McEachen's A135508 conjecture for all primes below 160000: if p < 160000 is prime and
p - 2 is not prime, then a(p - 1) = p. Definitions `OeisA135508.x` and `OeisA135508.a` are
formal-conjectures' (pinned commit 9097e2f), unchanged. -/
theorem a135508_conjecture_lt_160000 :
    ∀ p : ℕ, p.Prime → ¬ (p - 2).Prime → p < 160000 → OeisA135508.a (p - 1) = p := by
  sorry
