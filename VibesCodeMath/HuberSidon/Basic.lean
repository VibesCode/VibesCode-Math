module

@[expose] public section

/-! Huber's Sidon problem for distinct multinomial coefficients: definitions and a kernel-checkable
witness checker. Core Lean only (no Mathlib), so that `decide +kernel` can evaluate the checks.
`Verify.lean` relates the factorial here to Mathlib's `Nat.factorial`. -/

namespace HuberSidon

/-- core Lean has no Nat.factorial; same definition as Mathlib's -/
def Nat.factorial : Nat → Nat
  | 0 => 1
  | n+1 => (n+1) * Nat.factorial n

/-- a is a multinomial coefficient n!/(p_1!...p_t!) for some partition p of n -/
def InM (n a : Nat) : Prop :=
  ∃ p : List Nat, (∀ x ∈ p, 0 < x) ∧ p.sum = n ∧ a * (p.map Nat.factorial).prod = Nat.factorial n
/-- Sidon: every x + y = u + v is trivial (equal summands allowed) -/
def IsSidon (A : List Nat) : Prop :=
  ∀ a ∈ A, ∀ b ∈ A, ∀ c ∈ A, ∀ d ∈ A, a + b = c + d → (a = c ∧ b = d) ∨ (a = d ∧ b = c)

namespace HS

/-- all sums a+b with a before-or-equal b -/
def ps : List Nat → List Nat
  | [] => []
  | x :: xs => (x :: xs).map (x + ·) ++ ps xs

/-- fuel-based structural merge (out of fuel: append) -/
def mrg : Nat → List Nat → List Nat → List Nat
  | 0, a, b => a ++ b
  | _+1, [], b => b
  | _+1, a, [] => a
  | f+1, x :: xs, y :: ys =>
    if x ≤ y then x :: mrg f xs (y :: ys) else y :: mrg f (x :: xs) ys

def msort : Nat → List Nat → List Nat
  | 0, l => l
  | f+1, l =>
    if l.length ≤ 1 then l
    else
      let h := l.length / 2
      let a := msort f (l.take h)
      let b := msort f (l.drop h)
      mrg (a.length + b.length + 1) a b

def strictInc : List Nat → Bool
  | [] => true
  | [_] => true
  | x :: y :: r => decide (x < y) && strictInc (y :: r)

theorem mrg_perm : ∀ (f : Nat) (a b : List Nat), (mrg f a b).Perm (a ++ b)
  | 0, a, b => by simp [mrg]
  | f+1, [], b => by simp [mrg]
  | f+1, x :: xs, [] => by simp [mrg]
  | f+1, x :: xs, y :: ys => by
    unfold mrg
    split
    · exact ((mrg_perm f xs (y :: ys)).cons x)
    · exact ((mrg_perm f (x :: xs) ys).cons y).trans List.perm_middle.symm

theorem msort_perm : ∀ (f : Nat) (l : List Nat), (msort f l).Perm l
  | 0, l => List.Perm.refl _
  | f+1, l => by
    unfold msort
    split
    · exact List.Perm.refl _
    · simp only
      refine (mrg_perm _ _ _).trans ?_
      refine (List.Perm.append (msort_perm f _) (msort_perm f _)).trans ?_
      rw [List.take_append_drop]

theorem strictInc_pairwise : ∀ (l : List Nat), strictInc l = true → l.Pairwise (· < ·)
  | [], _ => List.Pairwise.nil
  | [x], _ => by simp
  | x :: y :: r, h => by
    simp only [strictInc, Bool.and_eq_true, decide_eq_true_eq] at h
    have ih := strictInc_pairwise (y :: r) h.2
    rw [List.pairwise_cons]
    refine ⟨?_, ih⟩
    intro z hz
    rcases List.mem_cons.mp hz with rfl | hz
    · exact h.1
    · exact Nat.lt_trans h.1 ((List.pairwise_cons.mp ih).1 z hz)

theorem mem_ps : ∀ (l : List Nat), l.Pairwise (· < ·) → ∀ a ∈ l, ∀ b ∈ l, a ≤ b → a + b ∈ ps l
  | [], _, a, ha, _, _, _ => by simp at ha
  | x :: xs, hs, a, ha, b, hb, hab => by
    have hs' := List.pairwise_cons.mp hs
    unfold ps
    rcases List.mem_cons.mp ha with rfl | ha'
    · exact List.mem_append_left _ (List.mem_map.mpr ⟨b, hb, rfl⟩)
    · have hxa := hs'.1 a ha'
      have hb' : b ∈ xs := by
        rcases List.mem_cons.mp hb with rfl | hb'
        · omega
        · exact hb'
      exact List.mem_append_right _ (mem_ps xs hs'.2 a ha' b hb' hab)

theorem ordered_sidon : ∀ (l : List Nat), l.Pairwise (· < ·) → (ps l).Nodup →
    ∀ a ∈ l, ∀ b ∈ l, ∀ c ∈ l, ∀ d ∈ l, a ≤ b → c ≤ d → a + b = c + d → a = c ∧ b = d
  | [], _, _ => by intro a ha; simp at ha
  | x :: xs, hs, hn => by
    intro a ha b hb c hc d hd hab hcd h
    have hs' := List.pairwise_cons.mp hs
    unfold ps at hn
    have hn' := List.nodup_append.mp hn
    have ih := ordered_sidon xs hs'.2 hn'.2.1
    -- a block-2 sum cannot equal a block-1 sum
    have key : ∀ u ∈ xs, ∀ v ∈ xs, u ≤ v → ∀ w ∈ x :: xs, u + v ≠ x + w := by
      intro u hu v hv huv w hw heq
      exact hn'.2.2 (x + w) (List.mem_map.mpr ⟨w, hw, rfl⟩) (u + v) (mem_ps xs hs'.2 u hu v hv huv) heq.symm
    rcases List.mem_cons.mp ha with rfl | ha'
    · rcases List.mem_cons.mp hc with rfl | hc'
      · exact ⟨rfl, by omega⟩
      · have hdx : d ∈ xs := by
          rcases List.mem_cons.mp hd with rfl | hd'
          · have := hs'.1 c hc'; omega
          · exact hd'
        exact absurd h.symm (key c hc' d hdx hcd b hb)
    · have hxa := hs'.1 a ha'
      have hb' : b ∈ xs := by
        rcases List.mem_cons.mp hb with rfl | hb'
        · omega
        · exact hb'
      rcases List.mem_cons.mp hc with rfl | hc'
      · exact absurd h (key a ha' b hb' hab d hd)
      · have hdx : d ∈ xs := by
          rcases List.mem_cons.mp hd with rfl | hd'
          · have := hs'.1 c hc'; omega
          · exact hd'
        exact ih a ha' b hb' c hc' d hdx hab hcd h

theorem sidon_of_ordered (l : List Nat) (hs : l.Pairwise (· < ·)) (hn : (ps l).Nodup) : IsSidon l := by
  intro a ha b hb c hc d hd h
  have O := ordered_sidon l hs hn
  rcases Nat.le_total a b with h1 | h1 <;> rcases Nat.le_total c d with h2 | h2
  · exact Or.inl (O a ha b hb c hc d hd h1 h2 h)
  · have := O a ha b hb d hd c hc h1 h2 (by omega); exact Or.inr this
  · have := O b hb a ha c hc d hd h1 h2 (by omega); right; omega
  · have := O b hb a ha d hd c hc h1 h2 (by omega); left; omega

def sidonOk (A : List Nat) : Bool :=
  strictInc A && strictInc (msort 14 (ps A))

theorem sidonOk_sound (A : List Nat) (h : sidonOk A = true) : A.Nodup ∧ IsSidon A := by
  simp only [sidonOk, Bool.and_eq_true] at h
  have hA := strictInc_pairwise _ h.1
  have hB := strictInc_pairwise _ h.2
  have hnd : ∀ l : List Nat, l.Pairwise (· < ·) → l.Nodup :=
    fun l hl => hl.imp (fun h => Nat.ne_of_lt h)
  refine ⟨hnd _ hA, sidon_of_ordered A hA ?_⟩
  exact ((msort_perm 14 (ps A)).nodup_iff).mp (hnd _ hB)

def partOk (n a : Nat) (p : List Nat) : Bool :=
  p.all (fun x => decide (0 < x)) && p.sum == n &&
    a * (p.map Nat.factorial).prod == Nat.factorial n

def certsOk (n : Nat) (cs : List (Nat × List Nat)) : Bool :=
  cs.all (fun c => partOk n c.1 c.2)

theorem certsOk_sound (n : Nat) (cs : List (Nat × List Nat)) (h : certsOk n cs = true) :
    ∀ a ∈ cs.map Prod.fst, InM n a := by
  intro a ha
  obtain ⟨c, hc, rfl⟩ := List.mem_map.mp ha
  have := List.all_eq_true.mp h c hc
  simp only [partOk, Bool.and_eq_true, List.all_eq_true, decide_eq_true_eq, beq_iff_eq] at this
  exact ⟨c.2, this.1.1, this.1.2, this.2⟩

theorem huber_of_check (n k : Nat) (cs : List (Nat × List Nat)) (hk : cs.length = k)
    (h1 : certsOk n cs = true) (h2 : sidonOk (cs.map Prod.fst) = true) :
    ∃ A : List Nat, A.Nodup ∧ A.length = k ∧ (∀ a ∈ A, InM n a) ∧ IsSidon A := by
  have := sidonOk_sound _ h2
  exact ⟨cs.map Prod.fst, this.1, by simp [hk], certsOk_sound n cs h1, this.2⟩

end HS

end HuberSidon
