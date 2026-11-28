/-
The definitions `OeisA135508.x` and `OeisA135508.a` below are copied verbatim from
google-deepmind/formal-conjectures, FormalConjectures/OEIS/135508.lean
at commit 9097e2f90e66d2f6244209cb1c07f7120d17ec53.
Copyright 2025 The Formal Conjectures Authors. Licensed under the Apache License, Version 2.0.
-/
module

public import Mathlib

@[expose] public section

namespace OeisA135508

/-- Auxiliary sequence $x(n)$ with $x(1)=1$ and $x(n) = 2 x(n-1) + \operatorname{lcm}(x(n-1),n)$. -/
def x : ℕ → ℕ
  | 0 => 0
  | 1 => 1
  | n + 1 => 2 * x n + Nat.lcm (x n) (n + 1)

/-- $a(n) = x(n+1)/x(n) - 2$ for $n \ge 1$, and $a(0) = 0$. -/
def a (n : ℕ) : ℕ :=
  if n = 0 then 0 else (x (n + 1) / x n) - 2

end OeisA135508


namespace OeisA135508

theorem x_one : x 1 = 1 := rfl

theorem x_succ (n : ℕ) (hn : 1 ≤ n) : x (n + 1) = 2 * x n + Nat.lcm (x n) (n + 1) := by
  obtain ⟨k, rfl⟩ : ∃ k, n = k + 1 := ⟨n - 1, by omega⟩
  rfl

theorem x_pos (n : ℕ) (hn : 1 ≤ n) : 0 < x n := by
  induction n, hn using Nat.le_induction with
  | base => decide
  | succ k hk ih => rw [x_succ k hk]; omega

theorem x_succ_mul (n : ℕ) (hn : 1 ≤ n) :
    x (n + 1) = x n * (2 + (n + 1) / Nat.gcd (x n) (n + 1)) := by
  rw [x_succ n hn, Nat.lcm, Nat.mul_div_assoc _ (Nat.gcd_dvd_right _ _)]
  ring

theorem a_eq (n : ℕ) (hn : 1 ≤ n) : a n = (n + 1) / Nat.gcd (x n) (n + 1) := by
  have h0 : n ≠ 0 := by omega
  have e : x (n + 1) / x n = 2 + (n + 1) / Nat.gcd (x n) (n + 1) := by
    rw [x_succ_mul n hn, Nat.mul_div_cancel_left _ (x_pos n hn)]
  unfold a
  rw [if_neg h0, e]
  exact Nat.add_sub_cancel_left 2 _

theorem x_dvd_of_le (i j : ℕ) (hi : 1 ≤ i) (hij : i ≤ j) : x i ∣ x j := by
  induction j, hij using Nat.le_induction with
  | base => exact dvd_rfl
  | succ k hk ih =>
    rw [x_succ_mul k (le_trans hi hk)]
    exact Dvd.dvd.mul_right ih _

/-- The key step: a prime p ≥ 5 can divide x (p - 1) only through the factor added at
step p - 2, and that factor is p exactly when p - 2 is coprime to x (p - 3). -/
theorem not_dvd (p : ℕ) (hp : p.Prime) (h5 : 5 ≤ p)
    (H : Nat.gcd (x (p - 3)) (p - 2) ≠ 1) : ∀ k, 1 ≤ k → k ≤ p - 1 → ¬ p ∣ x k := by
  intro k hk
  induction k, hk using Nat.le_induction with
  | base =>
    intro _ h
    rw [x_one] at h
    exact hp.one_lt.ne' (Nat.dvd_one.mp h)
  | succ k hk ih =>
    intro hkp hdiv
    have hk2 : k + 2 ≤ p := by omega
    rw [x_succ_mul k hk] at hdiv
    rcases (Nat.Prime.dvd_mul hp).mp hdiv with h | h
    · exact ih (by omega) h
    · have hgd : Nat.gcd (x k) (k + 1) ∣ k + 1 := Nat.gcd_dvd_right _ _
      have hdle : (k + 1) / Nat.gcd (x k) (k + 1) ≤ k + 1 := Nat.div_le_self _ _
      have hdd : (k + 1) / Nat.gcd (x k) (k + 1) ∣ k + 1 := Nat.div_dvd_of_dvd hgd
      have hmul : Nat.gcd (x k) (k + 1) * ((k + 1) / Nat.gcd (x k) (k + 1)) = k + 1 :=
        Nat.mul_div_cancel' hgd
      generalize hG : Nat.gcd (x k) (k + 1) = g at hgd hdle hdd hmul h
      generalize (k + 1) / g = d at hdle hdd hmul h
      obtain ⟨t, ht⟩ := h
      have hdp : 2 + d = p := by
        rcases t with _ | _ | t
        · simp at ht
        · simpa using ht
        · nlinarith
      obtain ⟨s, hs⟩ := hdd
      have hks : k + 1 = d := by
        rcases s with _ | _ | s
        · simp at hs
        · simpa using hs
        · nlinarith
      have hg1 : g = 1 := by
        rw [← hks] at hmul
        have : g * (k + 1) = 1 * (k + 1) := by rw [hmul, one_mul]
        exact Nat.eq_of_mul_eq_mul_right (by omega) this
      apply H
      have e1 : p - 3 = k := by omega
      have e2 : p - 2 = k + 1 := by omega
      rw [e1, e2]
      rw [hG]; exact hg1

/-- Reduction 1 (exact form): the conjecture follows from "every composite m ≥ 3 with
m + 2 prime shares a factor with x (m - 1)". (For p ≥ 5 the two are equivalent.) -/
theorem reduction_composite
    (H : ∀ m : ℕ, 3 ≤ m → ¬ m.Prime → (m + 2).Prime → Nat.gcd (x (m - 1)) m ≠ 1) :
    ∀ (p : ℕ), p.Prime → ¬ (p - 2).Prime → a (p - 1) = p := by
  intro p hp htw
  have h2 := hp.two_le
  by_cases hp2 : p = 2
  · subst hp2; decide
  by_cases hp3 : p = 3
  · subst hp3; decide
  have h4 : p ≠ 4 := by rintro rfl; exact absurd hp (by decide)
  have h5 : 5 ≤ p := by omega
  have Hm := H (p - 2) (by omega) htw (by rw [show p - 2 + 2 = p by omega]; exact hp)
  rw [show p - 2 - 1 = p - 3 by omega] at Hm
  have hnd := not_dvd p hp h5 Hm (p - 1) (by omega) le_rfl
  rw [a_eq (p - 1) (by omega), show p - 1 + 1 = p by omega]
  have hc : Nat.Coprime p (x (p - 1)) := (Nat.Prime.coprime_iff_not_dvd hp).mpr hnd
  rw [Nat.gcd_comm, hc, Nat.div_one]

/-- If a prime q divides x (q^2 - 1), every multiple m ≥ q^2 of q shares the factor q
with x (m - 1). -/
theorem gcd_ne_one_of_entry (m q : ℕ) (hq : q.Prime) (hqm : q ∣ m) (hsq : q ^ 2 ≤ m)
    (hE : q ∣ x (q ^ 2 - 1)) : Nat.gcd (x (m - 1)) m ≠ 1 := by
  have h2 := hq.two_le
  have h4 : 4 ≤ q ^ 2 := by nlinarith
  have hx : x (q ^ 2 - 1) ∣ x (m - 1) := x_dvd_of_le _ _ (by omega) (by omega)
  intro h1
  have : q ∣ Nat.gcd (x (m - 1)) m := Nat.dvd_gcd (dvd_trans hE hx) hqm
  rw [h1] at this
  exact hq.one_lt.ne' (Nat.dvd_one.mp this)

/-- Reduction 2 (entry-time form): the conjecture follows from "every prime q divides
x (q^2 - 1)", that is, every prime has entered x by step q^2 - 1. -/
theorem reduction_entry (H : ∀ q : ℕ, q.Prime → q ∣ x (q ^ 2 - 1)) :
    ∀ (p : ℕ), p.Prime → ¬ (p - 2).Prime → a (p - 1) = p := by
  apply reduction_composite
  intro m hm hnp _
  have hm1 : m ≠ 1 := by omega
  exact gcd_ne_one_of_entry m m.minFac (Nat.minFac_prime hm1) (Nat.minFac_dvd m)
    (Nat.minFac_sq_le_self (by omega) hnp) (H _ (Nat.minFac_prime hm1))

/-- Entry steps found by the engine, (q, E q): the first n with q ∣ x n. -/
def entryTab : List (ℕ × ℕ) := [(2, 2), (3, 4), (5, 3), (7, 47), (11, 53), (13, 11), (17, 83), (19, 17), (23, 67), (29, 317), (31, 29), (37, 257), (41, 367), (43, 41), (47, 233), (53, 157), (59, 293), (61, 59), (67, 467), (71, 211), (73, 71), (79, 709), (83, 911), (89, 443), (97, 677), (101, 503), (103, 101), (107, 2459), (109, 107), (113, 337), (127, 379), (131, 653), (137, 409), (139, 137), (149, 743), (151, 149), (157, 1097), (163, 487), (167, 499), (173, 863), (179, 2683), (181, 179), (191, 953), (193, 191), (197, 983), (199, 197), (211, 631), (223, 1559), (227, 6581), (229, 227), (233, 1163), (239, 1193), (241, 239), (251, 751), (257, 769), (263, 787), (269, 2957), (271, 269), (277, 4153), (281, 3089), (283, 281), (293, 877), (307, 919), (311, 1553), (313, 311), (317, 1583), (331, 991), (337, 1009), (347, 1039), (349, 347), (353, 3881), (359, 3229), (367, 6971), (373, 1117), (379, 5683), (383, 1913), (389, 3499), (397, 2777)]

def entryOf (q : ℕ) : ℕ := (entryTab.lookup q).getD 0

theorem entry_small : ∀ q < 400, q.Prime →
    1 ≤ entryOf q ∧ entryOf q ≤ q ^ 2 - 1 ∧ x (entryOf q) % q = 0 := by
  decide +kernel

theorem dvd_small (q : ℕ) (hq : q.Prime) (hQ : q < 400) : q ∣ x (q ^ 2 - 1) := by
  obtain ⟨h1, h2, h3⟩ := entry_small q hQ hq
  exact dvd_trans (Nat.dvd_of_mod_eq_zero h3) (x_dvd_of_le _ _ h1 h2)

/-- Reduction 2 with the primes below 400 discharged by kernel computation. -/
theorem reduction_entry_large (H : ∀ q : ℕ, q.Prime → 400 ≤ q → q ∣ x (q ^ 2 - 1)) :
    ∀ (p : ℕ), p.Prime → ¬ (p - 2).Prime → a (p - 1) = p := by
  apply reduction_entry
  intro q hq
  by_cases hQ : q < 400
  · exact dvd_small q hq hQ
  · exact H q hq (by omega)

/-- Unconditional partial result: the conjecture holds whenever the smallest prime factor
of p - 2 is below 400. -/
theorem conjecture_of_minFac_lt (p : ℕ) (hp : p.Prime) (htw : ¬ (p - 2).Prime)
    (hsmall : (p - 2).minFac < 400) : a (p - 1) = p := by
  have h2 := hp.two_le
  by_cases hp2 : p = 2
  · subst hp2; decide
  by_cases hp3 : p = 3
  · subst hp3; decide
  have h4 : p ≠ 4 := by rintro rfl; exact absurd hp (by decide)
  have h5 : 5 ≤ p := by omega
  have hm1 : p - 2 ≠ 1 := by omega
  have hq := Nat.minFac_prime hm1
  have Hm := gcd_ne_one_of_entry (p - 2) _ hq (Nat.minFac_dvd _)
    (Nat.minFac_sq_le_self (by omega) htw) (dvd_small _ hq hsmall)
  rw [show p - 2 - 1 = p - 3 by omega] at Hm
  have hnd := not_dvd p hp h5 Hm (p - 1) (by omega) le_rfl
  rw [a_eq (p - 1) (by omega), show p - 1 + 1 = p by omega]
  have hc : Nat.Coprime p (x (p - 1)) := (Nat.Prime.coprime_iff_not_dvd hp).mpr hnd
  rw [Nat.gcd_comm, hc, Nat.div_one]

/-- Unconditional bounded result: the conjecture holds for every prime p < 400^2. -/
theorem conjecture_lt (p : ℕ) (hp : p.Prime) (htw : ¬ (p - 2).Prime) (hlt : p < 400 ^ 2) :
    a (p - 1) = p := by
  apply conjecture_of_minFac_lt p hp htw
  by_cases hm : p - 2 ≤ 1
  · have : (p - 2).minFac ≤ 2 := by
      interval_cases h : p - 2 <;> simp
    omega
  · have := Nat.minFac_sq_le_self (show 0 < p - 2 by omega) htw
    by_contra hc'
    have hc := not_lt.mp hc'
    have : 400 ^ 2 ≤ (p - 2).minFac ^ 2 := Nat.pow_le_pow_left hc 2
    omega

end OeisA135508

/-- McEachen's A135508 conjecture for all primes below 160000: if p < 160000 is prime and
p - 2 is not prime, then a(p - 1) = p. Definitions `OeisA135508.x` and `OeisA135508.a` are
formal-conjectures' (pinned commit 9097e2f), unchanged. -/
theorem a135508_conjecture_lt_160000 :
    ∀ p : ℕ, p.Prime → ¬ (p - 2).Prime → p < 160000 → OeisA135508.a (p - 1) = p :=
  fun p hp htw hlt => OeisA135508.conjecture_lt p hp htw (lt_of_lt_of_eq hlt (by norm_num))

/-- McEachen's A135508 conjecture for every prime p whose p - 2 has smallest prime factor
(Mathlib's `Nat.minFac`) below 400: then a(p - 1) = p. An infinite family. Definitions
`OeisA135508.x` and `OeisA135508.a` are formal-conjectures' (pinned commit 9097e2f), unchanged. -/
theorem a135508_conjecture_minFac_lt_400 :
    ∀ p : ℕ, p.Prime → ¬ (p - 2).Prime → (p - 2).minFac < 400 → OeisA135508.a (p - 1) = p :=
  fun p hp htw h => OeisA135508.conjecture_of_minFac_lt p hp htw h
