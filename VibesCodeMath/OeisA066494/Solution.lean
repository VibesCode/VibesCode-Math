module

public import Mathlib

@[expose] public section

/-! Proof of `a066494_a066516_reduction` (statement in `Challenge.lean`). -/

namespace OeisA066494

private lemma nth_ge (n : ℕ) : n + 2 ≤ Nat.nth Nat.Prime n := by
  induction n with
  | zero => simp [Nat.nth_prime_zero_eq_two]
  | succ n ih =>
    have : Nat.nth Nat.Prime n < Nat.nth Nat.Prime (n + 1) :=
      Nat.nth_strictMono Nat.infinite_setOfPred_prime (Nat.lt_succ_self n)
    omega

private lemma nth_succ_le (j q : ℕ) (hq : q.Prime) (h : Nat.nth Nat.Prime j < q) :
    Nat.nth Nat.Prime (j+1) ≤ q := by
  by_contra hc
  rw [not_le] at hc
  have := Nat.le_nth_of_lt_nth_succ hc hq
  omega

private lemma sigma_totient_le (n : ℕ) :
    ArithmeticFunction.sigma 1 n * n.totient ≤ n ^ 2 := by
  induction n using Nat.recOnPosPrimePosCoprime with
  | prime_pow p a hp ha =>
    obtain ⟨b, rfl⟩ : ∃ b, a = b + 1 := ⟨a - 1, by omega⟩
    rw [ArithmeticFunction.sigma_one_apply_prime_pow hp, Nat.totient_prime_pow_succ hp]
    obtain ⟨q, rfl⟩ : ∃ q, p = q + 1 := ⟨p - 1, by have := hp.pos; omega⟩
    have hg := geom_sum_mul_add q (b + 1 + 1)
    simp only [Nat.add_sub_cancel]
    have hlt : (∑ i ∈ Finset.range (b + 1 + 1), (q + 1) ^ i) * q < (q + 1) ^ (b + 1 + 1) := by
      omega
    calc (∑ i ∈ Finset.range (b + 1 + 1), (q + 1) ^ i) * ((q + 1) ^ b * q)
        = (q + 1) ^ b * ((∑ i ∈ Finset.range (b + 1 + 1), (q + 1) ^ i) * q) := by ring
      _ ≤ (q + 1) ^ b * (q + 1) ^ (b + 1 + 1) := Nat.mul_le_mul_left _ hlt.le
      _ = ((q + 1) ^ (b + 1)) ^ 2 := by ring
  | zero => simp
  | one => simp
  | coprime a b ha hb hab iha ihb =>
    rw [ArithmeticFunction.isMultiplicative_sigma.map_mul_of_coprime hab, Nat.totient_mul hab]
    calc ArithmeticFunction.sigma 1 a * ArithmeticFunction.sigma 1 b * (a.totient * b.totient)
        = (ArithmeticFunction.sigma 1 a * a.totient) * (ArithmeticFunction.sigma 1 b * b.totient) := by ring
      _ ≤ a ^ 2 * b ^ 2 := Nat.mul_le_mul iha ihb
      _ = (a * b) ^ 2 := by ring

private lemma gap_bound
    (h1 : ∀ x : ℝ, 396738 ≤ x → ∃ p : ℕ, p.Prime ∧ x < p ∧ (p : ℝ) ≤ x * (1 + 1 / (25 * Real.log x ^ 2)))
    (h2 : ∀ k : ℕ, 688383 ≤ k → (Nat.nth Nat.Prime (k - 1) : ℝ) ≤
        k * (Real.log k + Real.log (Real.log k) - 1 + (Real.log (Real.log k) - 2) / Real.log k))
    (k : ℕ) (hk : 688383 ≤ k) :
    ((Nat.nth Nat.Prime k - Nat.nth Nat.Prime (k - 1) : ℕ) : ℝ) ≤ 2 * k / (25 * Real.log k) := by
  have hxk : k + 1 ≤ Nat.nth Nat.Prime (k - 1) := by
    have := nth_ge (k - 1); omega
  have hxkR : (k : ℝ) + 1 ≤ (Nat.nth Nat.Prime (k - 1) : ℝ) := by exact_mod_cast hxk
  have hkR : (688383 : ℝ) ≤ k := by exact_mod_cast hk
  obtain ⟨q, hq, hxq, hqle⟩ := h1 (Nat.nth Nat.Prime (k - 1) : ℝ) (by linarith)
  have hxq' : Nat.nth Nat.Prime (k - 1) < q := by exact_mod_cast hxq
  have h3 := nth_succ_le (k - 1) q hq hxq'
  have e : k - 1 + 1 = k := by omega
  rw [e] at h3
  have h3R : (Nat.nth Nat.Prime k : ℝ) ≤ q := by exact_mod_cast h3
  have hmono : Nat.nth Nat.Prime (k - 1) ≤ Nat.nth Nat.Prime k :=
    (Nat.nth_strictMono Nat.infinite_setOfPred_prime (by omega : k - 1 < k)).le
  rw [Nat.cast_sub hmono]
  set x : ℝ := (Nat.nth Nat.Prime (k - 1) : ℝ) with hxdef
  have hlk : 0 < Real.log k := Real.log_pos (by linarith)
  have hlkx : Real.log k ≤ Real.log x := Real.log_le_log (by linarith) (by linarith)
  have hx2 := h2 k hk
  have hL2 : Real.log (Real.log k) ≤ Real.log k - 1 := Real.log_le_sub_one_of_pos hlk
  have hfrac : (Real.log (Real.log k) - 2) / Real.log k ≤ 1 :=
    (div_le_one hlk).mpr (by linarith)
  have hxle : x ≤ 2 * k * Real.log k := by
    have : x ≤ k * (2 * Real.log k) := by
      refine hx2.trans (mul_le_mul_of_nonneg_left ?_ (by linarith))
      linarith
    linarith
  have hlk2 : 25 * Real.log k ^ 2 ≤ 25 * Real.log x ^ 2 := by
    have := mul_le_mul hlkx hlkx hlk.le (by linarith)
    nlinarith
  have hinv : 1 / (25 * Real.log x ^ 2) ≤ 1 / (25 * Real.log k ^ 2) :=
    one_div_le_one_div_of_le (by positivity) hlk2
  have hstep : x * (1 / (25 * Real.log x ^ 2)) ≤ (2 * k * Real.log k) * (1 / (25 * Real.log k ^ 2)) :=
    mul_le_mul hxle hinv (by positivity) (by positivity)
  have heq : (2 * k * Real.log k) * (1 / (25 * Real.log k ^ 2)) = 2 * k / (25 * Real.log k) := by
    field_simp
  have : (Nat.nth Nat.Prime k : ℝ) - x ≤ x * (1 / (25 * Real.log x ^ 2)) := by nlinarith
  linarith

private lemma poly_le (l : ℝ) (hl : 1 ≤ l) : 2 * (2 * l + 2.50637) ^ 2 ≤ 25 * Real.exp l := by
  have := Real.quadratic_le_exp_of_nonneg (by linarith : 0 ≤ l)
  nlinarith

theorem reduction_proof :
    (∀ x : ℝ, 396738 ≤ x → ∃ p : ℕ, p.Prime ∧ x < p ∧ (p : ℝ) ≤ x * (1 + 1 / (25 * Real.log x ^ 2))) →
    (∀ k : ℕ, 688383 ≤ k → (Nat.nth Nat.Prime (k - 1) : ℝ) ≤
        k * (Real.log k + Real.log (Real.log k) - 1 + (Real.log (Real.log k) - 2) / Real.log k)) →
    (∀ n : ℕ, 3 ≤ n → (n : ℝ) / n.totient <
        Real.exp Real.eulerMascheroniConstant * Real.log (Real.log n) + 2.50637 / Real.log (Real.log n)) →
    ∀ n : ℕ, 688383 ≤ n →
      Nat.nth Nat.Prime n - Nat.nth Nat.Prime (n - 1) ≠ n.totient ∧
      Nat.nth Nat.Prime (ArithmeticFunction.sigma 1 n) -
        Nat.nth Nat.Prime (ArithmeticFunction.sigma 1 n - 1) ≠ n.totient := by
  intro h1 h2 h3 n hn
  have hnR : (688383 : ℝ) ≤ n := by exact_mod_cast hn
  have hnpos : (0 : ℝ) < n := by linarith
  have hφpos : 0 < n.totient := Nat.totient_pos.mpr (by omega)
  have hφR : (0 : ℝ) < n.totient := by exact_mod_cast hφpos
  set L := Real.log n with hL
  set l := Real.log L with hl
  have he1 : Real.exp 1 < 2.7182818286 := Real.exp_one_lt_d9
  have he13 : Real.exp 13 < 688383 := by
    have : Real.exp 13 = (Real.exp 1) ^ 13 := by rw [← Real.exp_nat_mul]; norm_num
    rw [this]
    calc (Real.exp 1) ^ 13 < (2.7182818286 : ℝ) ^ 13 :=
          pow_lt_pow_left₀ he1 (Real.exp_pos 1).le (by norm_num)
      _ < 688383 := by norm_num
  have hL13 : 13 ≤ L := by
    rw [hL, Real.le_log_iff_exp_le hnpos]; linarith
  have hl1 : 1 ≤ l := by
    rw [hl, Real.le_log_iff_exp_le (by linarith)]
    linarith
  have hLpos : 0 < L := by linarith
  have hexp : Real.exp l = L := Real.exp_log hLpos
  have hE : Real.exp Real.eulerMascheroniConstant < 2 := by
    have h23 := Real.eulerMascheroniConstant_lt_two_thirds
    have h2l := Real.log_two_gt_d9
    calc Real.exp Real.eulerMascheroniConstant < Real.exp (Real.log 2) :=
          Real.exp_lt_exp.mpr (by linarith)
      _ = 2 := Real.exp_log (by norm_num)
  set r : ℝ := (n : ℝ) / n.totient with hr
  have hrpos : 0 < r := by positivity
  have hrφ : r * n.totient = n := by rw [hr]; field_simp
  have hB : r < 2 * l + 2.50637 := by
    have := h3 n (by omega)
    have h4 : Real.exp Real.eulerMascheroniConstant * l ≤ 2 * l := by nlinarith
    have h5 : 2.50637 / l ≤ 2.50637 := by
      rw [div_le_iff₀ (by linarith)]; nlinarith
    linarith
  have hB2 : 2 * (2 * l + 2.50637) ^ 2 ≤ 25 * L := by
    have := poly_le l hl1; rw [hexp] at this; exact this
  have hr2 : 2 * r ^ 2 < 25 * L := by
    have : r ^ 2 < (2 * l + 2.50637) ^ 2 := by
      apply pow_lt_pow_left₀ hB hrpos.le (by norm_num)
    linarith
  constructor
  · intro heq
    have hg := gap_bound h1 h2 n hn
    rw [heq] at hg
    rw [le_div_iff₀ (by positivity)] at hg
    have : 2 * r < 25 * L := by
      have : 2 * r ≤ 2 * r ^ 2 := by nlinarith
      linarith
    nlinarith
  · intro heq
    have hm : n ≤ ArithmeticFunction.sigma 1 n := by
      rw [ArithmeticFunction.sigma_one_apply]
      exact Finset.single_le_sum (f := fun d => d) (fun _ _ => Nat.zero_le _)
        (Nat.mem_divisors.mpr ⟨dvd_rfl, by omega⟩)
    have hmR : (688383 : ℝ) ≤ (ArithmeticFunction.sigma 1 n : ℕ) := by
      have : 688383 ≤ ArithmeticFunction.sigma 1 n := by omega
      exact_mod_cast this
    have hg := gap_bound h1 h2 _ (by omega : 688383 ≤ ArithmeticFunction.sigma 1 n)
    rw [heq] at hg
    set m := ArithmeticFunction.sigma 1 n with hm'
    have hmn : (n : ℝ) ≤ m := by exact_mod_cast (by omega : n ≤ m)
    have hlm : 0 < Real.log m := Real.log_pos (by linarith)
    have hLm : L ≤ Real.log m := Real.log_le_log hnpos hmn
    rw [le_div_iff₀ (by positivity)] at hg
    have hs := sigma_totient_le n
    have hsR : (m : ℝ) * n.totient ≤ (n : ℝ) ^ 2 := by exact_mod_cast hs
    have hmr : (m : ℝ) ≤ n * r := by
      have : (m : ℝ) * n.totient ≤ (n * r) * n.totient := by nlinarith
      exact le_of_mul_le_mul_right this hφR
    -- hg : φ * (25 log m) ≤ 2 m
    have h6 : (n.totient : ℝ) * (25 * L) ≤ 2 * (n * r) := by
      have : (n.totient : ℝ) * (25 * L) ≤ n.totient * (25 * Real.log m) :=
        mul_le_mul_of_nonneg_left (by linarith) hφR.le
      linarith
    have h7 : (n.totient : ℝ) * (25 * L) ≤ 2 * (n.totient * r * r) := by
      have : (n : ℝ) = r * n.totient := hrφ.symm
      calc _ ≤ 2 * (n * r) := h6
        _ = _ := by rw [this]; ring
    nlinarith

end OeisA066494

open OeisA066494 in
/-- Reduction for OEIS A066494 and A066516, with three cited explicit bounds as hypotheses:
(1) Dusart, arXiv:1002.0442v1, Prop. 6.8; (2) Dusart, same paper, Prop. 6.6;
(3) Rosser–Schoenfeld 1962, Theorem 15. `Nat.nth Nat.Prime (k-1)` is the k-th prime (1-indexed).
Conclusion: for every n ≥ 688383, prime(n+1) − prime(n) ≠ φ(n) and prime(σ(n)+1) − prime(σ(n)) ≠ φ(n). -/
theorem a066494_a066516_reduction :
    (∀ x : ℝ, 396738 ≤ x → ∃ p : ℕ, p.Prime ∧ x < p ∧ (p : ℝ) ≤ x * (1 + 1 / (25 * Real.log x ^ 2))) →
    (∀ k : ℕ, 688383 ≤ k → (Nat.nth Nat.Prime (k - 1) : ℝ) ≤
        k * (Real.log k + Real.log (Real.log k) - 1 + (Real.log (Real.log k) - 2) / Real.log k)) →
    (∀ n : ℕ, 3 ≤ n → (n : ℝ) / n.totient <
        Real.exp Real.eulerMascheroniConstant * Real.log (Real.log n) + 2.50637 / Real.log (Real.log n)) →
    ∀ n : ℕ, 688383 ≤ n →
      Nat.nth Nat.Prime n - Nat.nth Nat.Prime (n - 1) ≠ n.totient ∧
      Nat.nth Nat.Prime (ArithmeticFunction.sigma 1 n) -
        Nat.nth Nat.Prime (ArithmeticFunction.sigma 1 n - 1) ≠ n.totient :=
  reduction_proof
