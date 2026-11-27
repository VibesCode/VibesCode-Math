module

public import Mathlib
public import VibesCodeMath.HuberSidon.Witness16
public import VibesCodeMath.HuberSidon.Witness17
public import VibesCodeMath.HuberSidon.Witness18

@[expose] public section

/-! Restates the three lower bounds with Mathlib's `Nat.factorial` and the definitions written out:
M_n is the set of values n!/(p₁!⋯p_t!) over partitions p of n, and a Sidon set is one in which every
a + b = c + d is trivial (equal summands allowed). Prints the axioms used. -/

theorem huberSidon_factorial_eq : ∀ n, HuberSidon.Nat.factorial n = _root_.Nat.factorial n
  | 0 => rfl
  | n + 1 => by
    rw [HuberSidon.Nat.factorial, _root_.Nat.factorial, huberSidon_factorial_eq n]

theorem huber_s16_ge_check : ∃ A : List ℕ, A.Nodup ∧ A.length = 83 ∧
    (∀ a ∈ A, ∃ p : List ℕ, (∀ x ∈ p, 0 < x) ∧ p.sum = 16 ∧
      a * (p.map Nat.factorial).prod = Nat.factorial 16) ∧
    (∀ a ∈ A, ∀ b ∈ A, ∀ c ∈ A, ∀ d ∈ A, a + b = c + d → (a = c ∧ b = d) ∨ (a = d ∧ b = c)) := by
  have hf : HuberSidon.Nat.factorial = Nat.factorial := funext huberSidon_factorial_eq
  have h := HuberSidon.huber_s16_ge
  simp only [HuberSidon.InM, HuberSidon.IsSidon, hf] at h
  exact h

theorem huber_s17_ge_check : ∃ A : List ℕ, A.Nodup ∧ A.length = 96 ∧
    (∀ a ∈ A, ∃ p : List ℕ, (∀ x ∈ p, 0 < x) ∧ p.sum = 17 ∧
      a * (p.map Nat.factorial).prod = Nat.factorial 17) ∧
    (∀ a ∈ A, ∀ b ∈ A, ∀ c ∈ A, ∀ d ∈ A, a + b = c + d → (a = c ∧ b = d) ∨ (a = d ∧ b = c)) := by
  have hf : HuberSidon.Nat.factorial = Nat.factorial := funext huberSidon_factorial_eq
  have h := HuberSidon.huber_s17_ge
  simp only [HuberSidon.InM, HuberSidon.IsSidon, hf] at h
  exact h

theorem huber_s18_ge_check : ∃ A : List ℕ, A.Nodup ∧ A.length = 119 ∧
    (∀ a ∈ A, ∃ p : List ℕ, (∀ x ∈ p, 0 < x) ∧ p.sum = 18 ∧
      a * (p.map Nat.factorial).prod = Nat.factorial 18) ∧
    (∀ a ∈ A, ∀ b ∈ A, ∀ c ∈ A, ∀ d ∈ A, a + b = c + d → (a = c ∧ b = d) ∨ (a = d ∧ b = c)) := by
  have hf : HuberSidon.Nat.factorial = Nat.factorial := funext huberSidon_factorial_eq
  have h := HuberSidon.huber_s18_ge
  simp only [HuberSidon.InM, HuberSidon.IsSidon, hf] at h
  exact h

#print axioms huber_s16_ge_check
#print axioms huber_s17_ge_check
#print axioms huber_s18_ge_check
