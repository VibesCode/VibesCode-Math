module

public import VibesCodeMath.OeisA066494.Solution

@[expose] public section

/-! Restates the claim of `Challenge.lean` word for word and checks that `Solution.lean` proves it,
using only the standard axioms. The three cited bounds are hypotheses of the statement. -/

theorem a066494_reduction_check :
    (∀ x : ℝ, 396738 ≤ x → ∃ p : ℕ, p.Prime ∧ x < p ∧ (p : ℝ) ≤ x * (1 + 1 / (25 * Real.log x ^ 2))) →
    (∀ k : ℕ, 688383 ≤ k → (Nat.nth Nat.Prime (k - 1) : ℝ) ≤
        k * (Real.log k + Real.log (Real.log k) - 1 + (Real.log (Real.log k) - 2) / Real.log k)) →
    (∀ n : ℕ, 3 ≤ n → (n : ℝ) / n.totient <
        Real.exp Real.eulerMascheroniConstant * Real.log (Real.log n) + 2.50637 / Real.log (Real.log n)) →
    ∀ n : ℕ, 688383 ≤ n →
      Nat.nth Nat.Prime n - Nat.nth Nat.Prime (n - 1) ≠ n.totient ∧
      Nat.nth Nat.Prime (ArithmeticFunction.sigma 1 n) -
        Nat.nth Nat.Prime (ArithmeticFunction.sigma 1 n - 1) ≠ n.totient :=
  a066494_a066516_reduction

#print axioms a066494_reduction_check
