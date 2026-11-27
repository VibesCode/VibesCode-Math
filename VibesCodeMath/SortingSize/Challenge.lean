module

public import VibesCodeMath.SortingSize.Basic

@[expose] public section

/-! Challenge: the statement only. The proof is in `Solution.lean`. -/

theorem van_voorhis_recurrence :
    ∀ m k : ℕ, SortNet.SizeLowerBound m k →
      SortNet.SizeLowerBound (m + 1) (k + Nat.clog 2 (m + 1)) := by
  sorry
