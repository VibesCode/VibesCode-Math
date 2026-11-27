module

public import Mathlib

@[expose] public section

/-! Challenge: the statement only. The proof is in `Solution.lean`. -/

/-- OEIS A120121, A120122, A120123 (digit bound). Let P and S be the product and the sum of the decimal
digits of m (`Nat.digits 10 m` lists them, least significant first). If m > 0 and m = φ(P·S), or
m = φ(P)·S, or m = P·φ(S), then no digit of m is 0 and m < 10^84 (m has at most 84 digits). -/
theorem digit_phi_terms_bound (m : ℕ) (hm : 0 < m)
    (h : m = Nat.totient ((Nat.digits 10 m).prod * (Nat.digits 10 m).sum) ∨
         m = Nat.totient (Nat.digits 10 m).prod * (Nat.digits 10 m).sum ∨
         m = (Nat.digits 10 m).prod * Nat.totient (Nat.digits 10 m).sum) :
    0 ∉ Nat.digits 10 m ∧ m < 10 ^ 84 := by
  sorry
