module

public import VibesCodeMath.OeisA135508.Solution

@[expose] public section

/-! Restates the claims of `Challenge.lean` word for word and checks that `Solution.lean` proves them,
using only the standard axioms (propext, Classical.choice, Quot.sound). -/

theorem a135508_family_check :
    ∀ p : ℕ, p.Prime → ¬ (p - 2).Prime → (p - 2).minFac < 400 → OeisA135508.a (p - 1) = p :=
  a135508_conjecture_minFac_lt_400

theorem a135508_bounded_check :
    ∀ p : ℕ, p.Prime → ¬ (p - 2).Prime → p < 160000 → OeisA135508.a (p - 1) = p :=
  a135508_conjecture_lt_160000

#print axioms a135508_family_check
#print axioms a135508_bounded_check
