module

public import VibesCodeMath.OeisA120121.Solution

@[expose] public section

/-! Restates the claim of `Challenge.lean` word for word and checks that `Solution.lean` proves it,
using only the standard axioms. -/

theorem a120121_bound_check (m : ℕ) (hm : 0 < m)
    (h : m = Nat.totient ((Nat.digits 10 m).prod * (Nat.digits 10 m).sum) ∨
         m = Nat.totient (Nat.digits 10 m).prod * (Nat.digits 10 m).sum ∨
         m = (Nat.digits 10 m).prod * Nat.totient (Nat.digits 10 m).sum) :
    0 ∉ Nat.digits 10 m ∧ m < 10 ^ 84 :=
  digit_phi_terms_bound m hm h

#print axioms a120121_bound_check
