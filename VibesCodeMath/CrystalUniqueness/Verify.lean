module

public import VibesCodeMath.CrystalUniqueness.Classification

@[expose] public section

/-! Restates the reduction of `Classification.lean` (the crystal conjecture, written out, is equivalent
to injectivity of (k, t) ↦ n_t(k) on `Dom`) and prints the axioms of every theorem in that file. -/

open Arxiv.«1601.03081» CrystalUniqueness in
theorem crystal_reduction_check :
    (∀ n a b c d : ℕ, IsCrystalWithComponents n a b → IsCrystalWithComponents n c d →
      ({a, b} : Finset ℕ) = {c, d}) ↔
    Set.InjOn (fun p : ℤ × ℕ => nn p.1 p.2) Dom :=
  unique_iff_injOn

#print axioms crystal_reduction_check
#print axioms CrystalUniqueness.crystal_iff_chain
#print axioms CrystalUniqueness.crystal_iff_pell
#print axioms CrystalUniqueness.crystal_k_determines
#print axioms CrystalUniqueness.x_strictMono
#print axioms CrystalUniqueness.nn_strictMonoOn
