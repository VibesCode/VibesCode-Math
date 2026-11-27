module

public import VibesCodeMath.TanArctanExplicit.Solution

@[expose] public section

/-! Restates the claim of `Challenge.lean` word for word and checks that `Solution.lean` proves it,
using only the standard axioms (propext, Classical.choice, Quot.sound). -/

theorem target_check :
    ∀ n : ℕ, 5 ≤ n → n ∉ Arxiv.«2607.05739».exceptional → ¬ Arxiv.«2607.05739».IsIntegerValue n :=
  tan_arctan_not_integer_outside_exceptional

#print axioms target_check
