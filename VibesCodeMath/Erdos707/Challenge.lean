module

public import FormalConjectures.ErdosProblems.«707»

@[expose] public section

/-! Challenge: the statements only. The proofs are in `Solution.lean`. -/

/-- Niu's two candidate size-4 counterexamples to Erdős 707 (arXiv 2604.25214), {0,1,3,11} and
{0,1,4,11}, lie in no perfect difference set of even order: if B ⊆ ℕ is a perfect difference set
modulo n (any n, formal-conjectures' definition, pinned commit 9097e2f) and B has an odd number
of elements (so its order |B| - 1 is even), then B contains neither set. -/
theorem niu_sets_not_in_even_order_pds :
    ∀ (B : Set ℕ) (n : ℕ), IsPerfectDifferenceSet B n → Odd B.ncard →
      ¬ ({0, 1, 3, 11} : Set ℕ) ⊆ B ∧ ¬ ({0, 1, 4, 11} : Set ℕ) ⊆ B := by
  sorry

/-- Niu's candidate size-4 counterexample {0,1,3,11} to Erdős 707 (arXiv 2604.25214) lies in no
finite perfect difference set whose order |B| - 1 is divisible by 2 or by 3, for any modulus n
(formal-conjectures' definition, pinned commit 9097e2f). -/
theorem niu_set_not_in_pds_of_order_div_two_or_three :
    ∀ (B : Set ℕ) (n : ℕ), IsPerfectDifferenceSet B n → B.Finite →
      (2 ∣ B.ncard - 1 ∨ 3 ∣ B.ncard - 1) → ¬ ({0, 1, 3, 11} : Set ℕ) ⊆ B := by
  sorry
