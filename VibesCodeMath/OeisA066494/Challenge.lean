module

public import Mathlib

@[expose] public section

/-! Challenge: the statement only. The proof is in `Solution.lean`. -/

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
        Nat.nth Nat.Prime (ArithmeticFunction.sigma 1 n - 1) ≠ n.totient := by
  sorry
