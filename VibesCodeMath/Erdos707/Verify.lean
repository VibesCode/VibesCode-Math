module

public import VibesCodeMath.Erdos707.Solution

@[expose] public section

/-! Restates the claims of `Challenge.lean` word for word and checks that `Solution.lean` proves them,
using only the standard axioms (propext, Classical.choice, Quot.sound). -/

theorem erdos707_even_order_check :
    ∀ (B : Set ℕ) (n : ℕ), IsPerfectDifferenceSet B n → Odd B.ncard →
      ¬ ({0, 1, 3, 11} : Set ℕ) ⊆ B ∧ ¬ ({0, 1, 4, 11} : Set ℕ) ⊆ B :=
  niu_sets_not_in_even_order_pds

theorem erdos707_order_div_two_or_three_check :
    ∀ (B : Set ℕ) (n : ℕ), IsPerfectDifferenceSet B n → B.Finite →
      (2 ∣ B.ncard - 1 ∨ 3 ∣ B.ncard - 1) → ¬ ({0, 1, 3, 11} : Set ℕ) ⊆ B :=
  niu_set_not_in_pds_of_order_div_two_or_three

#print axioms erdos707_even_order_check
#print axioms erdos707_order_div_two_or_three_check
