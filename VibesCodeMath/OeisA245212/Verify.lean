module

public import VibesCodeMath.OeisA245212.Solution

@[expose] public section

/-! Restates the claim of `Challenge.lean` word for word and checks that `Solution.lean` proves it,
using only the standard axioms (propext, Classical.choice, Quot.sound). -/

theorem a245212_target_check (k m : ℕ) (hm : Odd m) (hsq : Squarefree m) :
    OeisA245212.a (2 ^ k * m) = (ArithmeticFunction.sigma 1 (2 ^ k * m) : ℤ) ↔
      ∃ j : ℕ, 2 ^ k * m = 2 ^ j :=
  a245212_squarefree_odd_part k m hm hsq

#print axioms a245212_target_check
