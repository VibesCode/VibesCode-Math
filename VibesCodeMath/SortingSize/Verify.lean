module

public import VibesCodeMath.SortingSize.Solution

@[expose] public section

/-! Restates the main theorem and the corollary, and prints their axioms. -/

theorem van_voorhis_recurrence_check :
    ∀ m k : ℕ, SortNet.SizeLowerBound m k →
      SortNet.SizeLowerBound (m + 1) (k + Nat.clog 2 (m + 1)) :=
  van_voorhis_recurrence

#print axioms van_voorhis_recurrence_check
#print axioms SortNet.bounds_from_s11
#print axioms SortNet.unconditional_small
