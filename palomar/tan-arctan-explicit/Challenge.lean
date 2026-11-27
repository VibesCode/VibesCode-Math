/-
The definitions in namespace `Arxiv.«2607.05739»` below are copied verbatim from
google-deepmind/formal-conjectures, FormalConjectures/Arxiv/2607.05739/TanArctanSum.lean
at commit 9097e2f90e66d2f6244209cb1c07f7120d17ec53.
Copyright 2026 The Formal Conjectures Authors. Licensed under the Apache License, Version 2.0.
-/
module

public import Mathlib

/-!
# Challenge: an explicit form of Ono's Corollary 1.2

Write (1 + i)(1 + 2i)⋯(1 + ni) = A_n + B_n i, so that x_n = tan(arctan 1 + ⋯ + arctan n) = B_n / A_n.
x_n is an integer value when A_n ∣ B_n. Ono (arXiv:2607.05739, Corollary 1.2) proved that for some
n₀, x_n is not an integer for every n ≥ n₀ outside the exceptional set E = {n ≥ 5 : |x_n| > n/2 + 1}.
The theorem below states this with n₀ = 5. It does not settle the Amdeberhan–Medina–Moll conjecture,
which also needs the indices in E.
-/

@[expose] public section

open Finset

namespace Arxiv.«2607.05739»

/-- $Z_n = \prod_{k=1}^n (1 + ik)$, in the Gaussian integers. -/
def gaussProd (n : ℕ) : GaussianInt := ∏ k ∈ Finset.Icc 1 n, (⟨1, (k : ℤ)⟩ : GaussianInt)

/-- $A_n = \operatorname{Re} Z_n$. -/
def A (n : ℕ) : ℤ := (gaussProd n).re

/-- $B_n = \operatorname{Im} Z_n$. -/
def B (n : ℕ) : ℤ := (gaussProd n).im

/-- $x_n = \tan\left(\sum_{k=1}^n \arctan k\right) = B_n / A_n$. -/
noncomputable def x (n : ℕ) : ℚ := (B n : ℚ) / (A n : ℚ)

/-- $x_n$ takes an integer value.

Stated as $A_n \mid B_n$ rather than as `∃ m : ℤ, x n = m`, so that it still says the right
thing if $A_n$ were ever $0$. There $x_n$ is a pole of the tangent rather than an integer, but
`(B n : ℚ) / 0` is `0` in Lean and would count as one. The two agree whenever $A_n \neq 0$,
which holds for every $n \leq 3000$. -/
def IsIntegerValue (n : ℕ) : Prop := A n ∣ B n

instance (n : ℕ) : Decidable (IsIntegerValue n) := by unfold IsIntegerValue; infer_instance

/-- The exceptional set $E = \{n \geq 5 : |x_n| > n/2 + 1\}$. An index with $A_n = 0$ is a
pole of the tangent rather than a large value, and is counted in, reading $|x_n|$ as infinite. -/
def exceptional : Set ℕ := {n | 5 ≤ n ∧ (A n = 0 ∨ ((n : ℚ) / 2 + 1 < |x n|))}


end Arxiv.«2607.05739»

/-- Explicit form of Ono's Corollary 1.2 (arXiv:2607.05739) with n₀ = 5:
for every n ≥ 5 outside the exceptional set E = {n ≥ 5 : A_n = 0 ∨ |x_n| > n/2 + 1},
x_n = tan(arctan 1 + ⋯ + arctan n) is not an integer. -/
theorem tan_arctan_not_integer_outside_exceptional :
    ∀ n : ℕ, 5 ≤ n → n ∉ Arxiv.«2607.05739».exceptional → ¬ Arxiv.«2607.05739».IsIntegerValue n := by
  sorry
