module

public import FormalConjectures.Arxiv.«2607.05739».TanArctanSum

@[expose] public section

/-! Challenge: the statement only. The proof is in `Solution.lean`. -/

/-- Explicit form of Ono's Corollary 1.2 (arXiv:2607.05739) with n₀ = 5:
for every n ≥ 5 outside the exceptional set E = {n ≥ 5 : A_n = 0 ∨ |x_n| > n/2 + 1},
x_n = tan(arctan 1 + ⋯ + arctan n) is not an integer. Definitions are formal-conjectures'
(pinned commit 9097e2f), unchanged. -/
theorem tan_arctan_not_integer_outside_exceptional :
    ∀ n : ℕ, 5 ≤ n → n ∉ Arxiv.«2607.05739».exceptional → ¬ Arxiv.«2607.05739».IsIntegerValue n := by
  sorry
