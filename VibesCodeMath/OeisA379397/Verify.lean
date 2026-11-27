module

public import VibesCodeMath.OeisA379397.Reduction

@[expose] public section

/-! Restates the bound of `Reduction.lean` and prints its axioms. Dickson's theorem enters only as the
hypothesis `DicksonEight`; it is cited, not proved here. -/

open OeisA379397 in
theorem a379397_bound_check (hD : DicksonEight) (k : ℕ) :
    ∀ n, (∃ T : Finset (Multiset ℕ), T.card = k ∧ ∀ s, IsRep n s ↔ s ∈ T) →
      n < 240 + (9 * k + 1) ^ 3 :=
  exactly_k_bounded hD k

#print axioms a379397_bound_check
