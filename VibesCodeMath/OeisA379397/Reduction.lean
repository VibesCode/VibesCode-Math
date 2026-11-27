module

public import Mathlib

@[expose] public section

/-! The counting step for OEIS A379397–A379400, with Dickson's theorem (1939) as an explicit
hypothesis `DicksonEight`. See `oeis-a379397/RESULT.md`. -/

namespace OeisA379397

/-- A representation of n: a multiset of 1 to 9 positive integers whose cubes sum to n. -/
def IsRep (n : ℕ) (s : Multiset ℕ) : Prop :=
  0 < Multiset.card s ∧ Multiset.card s ≤ 9 ∧ (∀ x ∈ s, 0 < x) ∧ (s.map (· ^ 3)).sum = n

/-- Dickson (1939), as a hypothesis: every m ≥ 1 other than 23, 239 is a sum of at most 8 positive cubes. -/
def DicksonEight : Prop :=
  ∀ m : ℕ, 0 < m → m ≠ 23 → m ≠ 239 →
    ∃ s : Multiset ℕ, Multiset.card s ≤ 8 ∧ (∀ x ∈ s, 0 < x) ∧ (s.map (· ^ 3)).sum = m

theorem many_reps (hD : DicksonEight) (k n : ℕ) (hn : 240 + (9 * k + 1) ^ 3 ≤ n) :
    ∃ T : Finset (Multiset ℕ), k < T.card ∧ ∀ s ∈ T, IsRep n s := by
  classical
  have h : ∀ c ∈ Finset.Icc 1 (9 * k + 1), ∃ S : Multiset ℕ,
      Multiset.card S ≤ 8 ∧ (∀ x ∈ S, 0 < x) ∧ (S.map (· ^ 3)).sum = n - c ^ 3 := by
    intro c hc
    rw [Finset.mem_Icc] at hc
    have h3 : c ^ 3 ≤ (9 * k + 1) ^ 3 := Nat.pow_le_pow_left hc.2 3
    have h240 : 240 ≤ n - c ^ 3 := by
      generalize c ^ 3 = a at *
      generalize (9 * k + 1) ^ 3 = b at *
      omega
    exact hD _ (by omega) (by omega) (by omega)
  choose! S hS using h
  have hRep : ∀ c ∈ Finset.Icc 1 (9 * k + 1), IsRep n (c ::ₘ S c) := by
    intro c hc
    obtain ⟨h1, h2, h3⟩ := hS c hc
    have hc' := Finset.mem_Icc.mp hc
    have h3' : c ^ 3 ≤ (9 * k + 1) ^ 3 := Nat.pow_le_pow_left hc'.2 3
    refine ⟨by simp, by simp; omega, ?_, ?_⟩
    · intro x hx
      rcases Multiset.mem_cons.mp hx with rfl | hx
      · exact hc'.1
      · exact h2 x hx
    · rw [Multiset.map_cons, Multiset.sum_cons, h3]
      generalize c ^ 3 = a at *
      generalize (9 * k + 1) ^ 3 = b at *
      omega
  refine ⟨(Finset.Icc 1 (9 * k + 1)).image (fun c => c ::ₘ S c), ?_, ?_⟩
  · have := Finset.card_le_mul_card_image (f := fun c => c ::ₘ S c) (Finset.Icc 1 (9 * k + 1)) 9 (by
      intro a ha
      obtain ⟨c, hc, rfl⟩ := Finset.mem_image.mp ha
      calc ((Finset.Icc 1 (9 * k + 1)).filter (fun x => x ::ₘ S x = c ::ₘ S c)).card
          ≤ (c ::ₘ S c).toFinset.card := by
            apply Finset.card_le_card
            intro x hx
            rw [Finset.mem_filter] at hx
            rw [Multiset.mem_toFinset, ← hx.2]
            exact Multiset.mem_cons_self _ _
        _ ≤ Multiset.card (c ::ₘ S c) := Multiset.toFinset_card_le _
        _ ≤ 9 := (hRep c hc).2.1)
    simp only [Nat.card_Icc] at this
    omega
  · intro s hs
    obtain ⟨c, hc, rfl⟩ := Finset.mem_image.mp hs
    exact hRep c hc

theorem exactly_k_bounded (hD : DicksonEight) (k : ℕ) :
    ∀ n, (∃ T : Finset (Multiset ℕ), T.card = k ∧ ∀ s, IsRep n s ↔ s ∈ T) →
      n < 240 + (9 * k + 1) ^ 3 := by
  intro n ⟨T, hT, hiff⟩
  by_contra hlt
  obtain ⟨T', hk, hT'⟩ := many_reps hD k n (not_lt.mp hlt)
  have hsub : T' ⊆ T := fun s hs => (hiff s).mp (hT' s hs)
  have := Finset.card_le_card hsub
  omega

end OeisA379397
