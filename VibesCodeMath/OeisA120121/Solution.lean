module

public import Mathlib

@[expose] public section

/-! Proof of `digit_phi_terms_bound` (statement in `Challenge.lean`). -/

namespace OeisA120121


/-- 10·9^(n+1)·n < 10^n for n ≥ 85. -/
private lemma key_ineq (n : ℕ) (hn : 85 ≤ n) : 10 * 9 ^ (n + 1) * n < 10 ^ n := by
  induction n, hn using Nat.le_induction with
  | base => norm_num
  | succ n hn ih =>
    have h1 : 9 * (n + 1) ≤ 10 * n := by omega
    calc 10 * 9 ^ (n + 1 + 1) * (n + 1) = 10 * 9 ^ (n + 1) * (9 * (n + 1)) := by ring
      _ ≤ 10 * 9 ^ (n + 1) * (10 * n) := Nat.mul_le_mul_left _ h1
      _ = 10 * (10 * 9 ^ (n + 1) * n) := by ring
      _ < 10 * 10 ^ n := by omega
      _ = 10 ^ (n + 1) := by ring

private lemma le_PS (m : ℕ)
    (h : m = Nat.totient ((Nat.digits 10 m).prod * (Nat.digits 10 m).sum) ∨
         m = Nat.totient (Nat.digits 10 m).prod * (Nat.digits 10 m).sum ∨
         m = (Nat.digits 10 m).prod * Nat.totient (Nat.digits 10 m).sum) :
    m ≤ (Nat.digits 10 m).prod * (Nat.digits 10 m).sum := by
  rcases h with h | h | h
  · calc m = _ := h
      _ ≤ _ := Nat.totient_le _
  · calc m = _ := h
      _ ≤ _ := Nat.mul_le_mul_right _ (Nat.totient_le _)
  · calc m = _ := h
      _ ≤ _ := Nat.mul_le_mul_left _ (Nat.totient_le _)

theorem bound_proof (m : ℕ) (hm : 0 < m)
    (h : m = Nat.totient ((Nat.digits 10 m).prod * (Nat.digits 10 m).sum) ∨
         m = Nat.totient (Nat.digits 10 m).prod * (Nat.digits 10 m).sum ∨
         m = (Nat.digits 10 m).prod * Nat.totient (Nat.digits 10 m).sum) :
    0 ∉ Nat.digits 10 m ∧ m < 10 ^ 84 := by
  set L := Nat.digits 10 m with hL
  have hle := le_PS m h
  rw [← hL] at hle
  have hdig : ∀ x ∈ L, x ≤ 9 := fun x hx => by
    have := Nat.digits_lt_base (by norm_num : 1 < 10) hx; omega
  have hP : L.prod ≤ 9 ^ L.length := List.prod_le_pow_card L 9 hdig
  have hS : L.sum ≤ L.length * 9 := by
    have := List.sum_le_card_nsmul L 9 hdig; simpa using this
  have hlow : 10 ^ L.length ≤ 10 * m := Nat.base_pow_length_digits_le 10 m (by norm_num) hm.ne'
  have hup : m < 10 ^ L.length := Nat.lt_base_pow_length_digits (by norm_num)
  refine ⟨?_, ?_⟩
  · intro h0
    have hp0 : L.prod = 0 := List.prod_eq_zero h0
    rw [hp0, zero_mul] at hle
    omega
  · by_contra hc
    have hlen : 85 ≤ L.length := by
      by_contra hl
      have : 10 ^ L.length ≤ 10 ^ 84 := Nat.pow_le_pow_right (by norm_num) (by omega)
      omega
    have hk := key_ineq L.length hlen
    have : 10 * m ≤ 10 * 9 ^ (L.length + 1) * L.length := by
      calc 10 * m ≤ 10 * (L.prod * L.sum) := by omega
        _ ≤ 10 * (9 ^ L.length * (L.length * 9)) :=
            Nat.mul_le_mul_left _ (Nat.mul_le_mul hP hS)
        _ = 10 * 9 ^ (L.length + 1) * L.length := by ring
    omega

end OeisA120121

open OeisA120121 in
/-- OEIS A120121, A120122, A120123 (digit bound). Let P and S be the product and the sum of the decimal
digits of m (`Nat.digits 10 m` lists them, least significant first). If m > 0 and m = φ(P·S), or
m = φ(P)·S, or m = P·φ(S), then no digit of m is 0 and m < 10^84 (m has at most 84 digits). -/
theorem digit_phi_terms_bound (m : ℕ) (hm : 0 < m)
    (h : m = Nat.totient ((Nat.digits 10 m).prod * (Nat.digits 10 m).sum) ∨
         m = Nat.totient (Nat.digits 10 m).prod * (Nat.digits 10 m).sum ∨
         m = (Nat.digits 10 m).prod * Nat.totient (Nat.digits 10 m).sum) :
    0 ∉ Nat.digits 10 m ∧ m < 10 ^ 84 :=
  bound_proof m hm h
