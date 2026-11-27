module

public import VibesCodeMath.SortingSize.Basic

@[expose] public section

namespace SortNet

/-! ### Relabelling wires by a permutation -/

/-- Relabel a comparator by a permutation of the wires. -/
def conjC {n : ℕ} (τ : Equiv.Perm (Fin n)) (c : Comparator n) : Comparator n := (τ c.1, τ c.2)

lemma eval_nil {n : ℕ} (v : Fin n → ℕ) : eval [] v = v := rfl

lemma eval_cons {n : ℕ} (c : Comparator n) (N : List (Comparator n)) (v : Fin n → ℕ) :
    eval (c :: N) v = eval N (applyC c v) := rfl

lemma applyC_conj {n : ℕ} (τ : Equiv.Perm (Fin n)) (c : Comparator n) (v : Fin n → ℕ) :
    applyC (conjC τ c) v ∘ τ = applyC c (v ∘ τ) := by
  funext k
  simp [applyC, conjC]

lemma eval_conj {n : ℕ} (τ : Equiv.Perm (Fin n)) :
    ∀ (N : List (Comparator n)) (v : Fin n → ℕ), eval (N.map (conjC τ)) v ∘ τ = eval N (v ∘ τ) := by
  intro N
  induction N with
  | nil => intro v; rfl
  | cons c N ih =>
    intro v
    simp only [List.map_cons, eval_cons]
    rw [ih, applyC_conj]

/-- A comparator `(a, b)` equals the reversed comparator `(b, a)` followed by swapping wires `a` and `b`. -/
lemma applyC_swap {n : ℕ} (a b : Fin n) (hab : a ≠ b) (v : Fin n → ℕ) :
    applyC (a, b) v = applyC (b, a) v ∘ Equiv.swap a b := by
  funext k
  by_cases h1 : k = a
  · subst h1
    simp [applyC, Equiv.swap_apply_left, min_comm]
  · by_cases h2 : k = b
    · subst h2
      simp [applyC, Equiv.swap_apply_right, hab, h1, max_comm]
    · simp [applyC, h1, h2, Equiv.swap_apply_of_ne_of_ne h1 h2]

/-! ### Untangling: every network equals a standard one followed by a fixed permutation -/

theorem untangle {n : ℕ} : ∀ (L : ℕ) (N : List (Comparator n)), N.length = L →
    ∃ S : List (Comparator n), IsStandard S ∧ S.length ≤ N.length ∧
      ∃ ρ : Equiv.Perm (Fin n), ∀ v, eval N v = eval S v ∘ ρ := by
  intro L
  induction L with
  | zero =>
    intro N hN
    have : N = [] := List.eq_nil_of_length_eq_zero hN
    subst this
    exact ⟨[], by simp [IsStandard], le_refl _, Equiv.refl _, fun v => rfl⟩
  | succ L ih =>
    intro N hN
    match N, hN with
    | (a, b) :: rest, hN =>
      have hlen : rest.length = L := by simpa using hN
      rcases lt_trichotomy a b with hab | hab | hab
      · obtain ⟨S, hS, hSl, ρ, hρ⟩ := ih rest hlen
        refine ⟨(a, b) :: S, ?_, by simpa using hSl, ρ, ?_⟩
        · intro c hc
          rcases List.mem_cons.1 hc with h | h
          · subst h; exact hab
          · exact hS c h
        · intro v
          rw [eval_cons, hρ, eval_cons]
      · subst hab
        obtain ⟨S, hS, hSl, ρ, hρ⟩ := ih rest hlen
        refine ⟨S, hS, by simp; omega, ρ, ?_⟩
        intro v
        have : applyC (a, a) v = v := by
          funext k; by_cases h : k = a
          · subst h; simp [applyC]
          · simp [applyC, h]
        rw [eval_cons, this, hρ]
      · set τ := Equiv.swap a b with hτ
        obtain ⟨S, hS, hSl, ρ, hρ⟩ := ih (rest.map (conjC τ)) (by simpa using hlen)
        refine ⟨(b, a) :: S, ?_, by simpa using hSl, τ.trans ρ, ?_⟩
        · intro c hc
          rcases List.mem_cons.1 hc with h | h
          · subst h; exact hab
          · exact hS c h
        · intro v
          rw [eval_cons, applyC_swap a b (ne_of_gt hab), ← eval_conj τ rest, hρ, eval_cons,
            Equiv.coe_trans]
          rfl

/-! ### Standard networks fix sorted inputs -/

lemma applyC_std_mono {n : ℕ} (c : Comparator n) (hc : c.1 < c.2) (v : Fin n → ℕ) (hv : Monotone v) :
    applyC c v = v := by
  have hle : v c.1 ≤ v c.2 := hv (le_of_lt hc)
  funext k
  by_cases h1 : k = c.1
  · subst h1; simp [applyC, hle]
  · by_cases h2 : k = c.2
    · subst h2; simp [applyC, h1, hle]
    · simp [applyC, h1, h2]

lemma eval_std_mono {n : ℕ} : ∀ (N : List (Comparator n)), IsStandard N →
    ∀ v : Fin n → ℕ, Monotone v → eval N v = v := by
  intro N
  induction N with
  | nil => intro _ v _; rfl
  | cons c N ih =>
    intro hN v hv
    have hc : c.1 < c.2 := hN c (List.mem_cons_self ..)
    rw [eval_cons, applyC_std_mono c hc v hv]
    exact ih (fun d hd => hN d (List.mem_cons_of_mem _ hd)) v hv

/-- A monotone injective self-map of `Fin m` is the identity. -/
lemma fin_mono_inj_eq_id {m : ℕ} (σ : Fin m → Fin m) (hm : Monotone σ) (hi : Function.Injective σ) :
    σ = id := by
  have hs : StrictMono σ := hm.strictMono_of_injective hi
  have hsurj : Function.Surjective σ := Finite.injective_iff_surjective.1 hi
  let e : Fin m ≃o Fin m := StrictMono.orderIsoOfSurjective σ hs hsurj
  have : e = OrderIso.refl _ := Subsingleton.elim _ _
  funext x
  have := congrArg (fun f : Fin m ≃o Fin m => f x) this
  simpa [e] using this

/-! ### The path of the minimum ("the token") -/

/-- Where a token holding the global minimum, starting on wire `p`, ends up, and how many
comparators it passes through. -/
def track {n : ℕ} : List (Comparator n) → Fin n → Fin n × ℕ
  | [], p => (p, 0)
  | c :: N, p => if p = c.1 ∨ p = c.2 then ((track N c.1).1, (track N c.1).2 + 1) else track N p

lemma track_cons {n : ℕ} (c : Comparator n) (N : List (Comparator n)) (p : Fin n) :
    track (c :: N) p =
      if p = c.1 ∨ p = c.2 then ((track N c.1).1, (track N c.1).2 + 1) else track N p := rfl

lemma track_conj {n : ℕ} (τ : Equiv.Perm (Fin n)) :
    ∀ (N : List (Comparator n)) (x : Fin n),
      track (N.map (conjC τ)) (τ x) = (τ (track N x).1, (track N x).2) := by
  intro N
  induction N with
  | nil => intro x; rfl
  | cons c N ih =>
    intro x
    simp only [List.map_cons, track_cons, conjC, EmbeddingLike.apply_eq_iff_eq]
    split_ifs
    · rw [ih]
    · rw [ih]

/-- The indicator input: `0` on wire `p`, `1` elsewhere. -/
def ind {n : ℕ} (p : Fin n) : Fin n → ℕ := fun j => if j = p then 0 else 1

lemma applyC_ind {n : ℕ} (c : Comparator n) (p : Fin n) :
    applyC c (ind p) = if p = c.1 ∨ p = c.2 then ind c.1 else ind p := by
  funext k
  obtain ⟨a, b⟩ := c
  by_cases h : p = a ∨ p = b
  · rw [if_pos h]
    simp only [applyC, ind, Fin.ext_iff] at h ⊢
    split_ifs <;> omega
  · rw [if_neg h]
    simp only [applyC, ind, Fin.ext_iff] at h ⊢
    split_ifs <;> omega

lemma eval_ind {n : ℕ} : ∀ (N : List (Comparator n)) (p : Fin n), eval N (ind p) = ind (track N p).1 := by
  intro N
  induction N with
  | nil => intro p; rfl
  | cons c N ih =>
    intro p
    rw [eval_cons, applyC_ind, track_cons]
    split_ifs
    · exact ih c.1
    · exact ih p

/-- Kraft-type inequality: the tokens ending on a fixed wire `q` have `∑ 2^{-depth} ≤ 1`. -/
lemma kraft {n : ℕ} (q : Fin n) : ∀ N : List (Comparator n),
    ∑ w : Fin n, (if (track N w).1 = q then ((1 : ℚ) / 2) ^ (track N w).2 else 0) ≤ 1 := by
  intro N
  induction N with
  | nil =>
    simp [track]
  | cons c N ih =>
    obtain ⟨a, b⟩ := c
    set f : Fin n → ℚ := fun w => if (track N w).1 = q then ((1 : ℚ) / 2) ^ (track N w).2 else 0 with hf
    have hf0 : ∀ w, 0 ≤ f w := by
      intro w; simp only [hf]; split_ifs <;> positivity
    set g : Fin n → ℚ := fun w =>
      if (track ((a, b) :: N) w).1 = q then ((1 : ℚ) / 2) ^ (track ((a, b) :: N) w).2 else 0 with hg
    have hgab : ∀ w, w = a ∨ w = b → g w = f a / 2 := by
      intro w hw
      simp only [hg, hf, track_cons, hw, if_true]
      split_ifs <;> ring
    have hgo : ∀ w, ¬ (w = a ∨ w = b) → g w = f w := by
      intro w hw
      simp only [hg, hf, track_cons, hw, if_false]
    have key : ∑ w, g w ≤ ∑ w, f w := by
      have ha : a ∈ (Finset.univ : Finset (Fin n)) := Finset.mem_univ a
      rw [← Finset.add_sum_erase _ g ha, ← Finset.add_sum_erase _ f ha]
      by_cases hab : a = b
      · subst hab
        have : ∑ x ∈ Finset.univ.erase a, g x = ∑ x ∈ Finset.univ.erase a, f x := by
          apply Finset.sum_congr rfl
          intro x hx
          have hxa : x ≠ a := Finset.ne_of_mem_erase hx
          exact hgo x (by simp [hxa])
        rw [this, hgab a (Or.inl rfl)]
        have := hf0 a
        linarith
      · have hb : b ∈ (Finset.univ : Finset (Fin n)).erase a :=
          Finset.mem_erase.2 ⟨Ne.symm hab, Finset.mem_univ b⟩
        rw [← Finset.add_sum_erase _ g hb, ← Finset.add_sum_erase _ f hb]
        have : ∑ x ∈ (Finset.univ.erase a).erase b, g x = ∑ x ∈ (Finset.univ.erase a).erase b, f x := by
          apply Finset.sum_congr rfl
          intro x hx
          have hxb : x ≠ b := Finset.ne_of_mem_erase hx
          have hxa : x ≠ a := Finset.ne_of_mem_erase (Finset.mem_of_mem_erase hx)
          exact hgo x (by simp [hxa, hxb])
        rw [this, hgab a (Or.inl rfl), hgab b (Or.inr rfl)]
        have := hf0 b
        linarith
    exact le_trans key ih

/-- If every token ends on the same wire, some token passes through at least `⌈log₂ n⌉` comparators. -/
lemma exists_deep {n : ℕ} (hn : 0 < n) (N : List (Comparator n)) (q : Fin n)
    (hq : ∀ w, (track N w).1 = q) : ∃ w, Nat.clog 2 n ≤ (track N w).2 := by
  by_contra hcon
  push Not at hcon
  set c := Nat.clog 2 n with hc
  have hc0 : 0 < c := by
    have := hcon ⟨0, hn⟩; omega
  have hlt : 2 ^ (c - 1) < n := by
    by_contra h
    push Not at h
    have := (Nat.clog_le_iff_le_pow (by norm_num : 1 < 2)).2 h
    omega
  have hk := kraft q N
  simp only [hq, if_true] at hk
  have hlow : ∀ w : Fin n, ((1 : ℚ) / 2) ^ (c - 1) ≤ ((1 : ℚ) / 2) ^ (track N w).2 := by
    intro w
    apply pow_le_pow_of_le_one (by norm_num) (by norm_num)
    have := hcon w; omega
  have hsum : ∑ _w : Fin n, ((1 : ℚ) / 2) ^ (c - 1) ≤ ∑ w : Fin n, ((1 : ℚ) / 2) ^ (track N w).2 :=
    Finset.sum_le_sum (fun w _ => hlow w)
  simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul] at hsum
  have hlt' : ((2 : ℚ) ^ (c - 1)) < (n : ℚ) := by exact_mod_cast hlt
  have hpos : (0 : ℚ) < 2 ^ (c - 1) := by positivity
  have : (1 : ℚ) < (n : ℚ) * ((1 : ℚ) / 2) ^ (c - 1) := by
    rw [one_div_pow, mul_one_div, one_lt_div hpos]
    exact hlt'
  linarith

/-! ### Stripping the token's path out of the network -/

lemma applyC_min_left {n : ℕ} (a b : Fin n) (v : Fin n → ℕ) (hv : ∀ j, v a ≤ v j) :
    applyC (a, b) v = v := by
  funext k
  by_cases h1 : k = a
  · subst h1; simp [applyC, hv b]
  · by_cases h2 : k = b
    · subst h2; simp [applyC, h1, hv k]
    · simp [applyC, h1, h2]

lemma applyC_min_right {n : ℕ} (a b : Fin n) (hab : a ≠ b) (v : Fin n → ℕ) (hv : ∀ j, v b ≤ v j) :
    applyC (a, b) v = v ∘ Equiv.swap a b := by
  funext k
  by_cases h1 : k = a
  · subst h1; simp [applyC, hv k, Equiv.swap_apply_left]
  · by_cases h2 : k = b
    · subst h2; simp [applyC, h1, hv a, Equiv.swap_apply_right, hab]
    · simp [applyC, h1, h2, Equiv.swap_apply_of_ne_of_ne h1 h2]

lemma applyC_other {n : ℕ} (c : Comparator n) (p : Fin n) (h1 : p ≠ c.1) (h2 : p ≠ c.2)
    (v : Fin n → ℕ) (hv : ∀ j, v p ≤ v j) : ∀ j, applyC c v p ≤ applyC c v j := by
  have hp : applyC c v p = v p := by simp [applyC, h1, h2]
  intro j
  rw [hp]
  simp only [applyC]
  split_ifs
  · exact le_min (hv _) (hv _)
  · exact le_trans (hv _) (le_max_left _ _)
  · exact hv _

theorem strip {n : ℕ} : ∀ (L : ℕ) (N : List (Comparator n)), N.length = L → ∀ p : Fin n,
    ∃ N' : List (Comparator n), ∃ ρ : Equiv.Perm (Fin n),
      (∀ c ∈ N', c.1 ≠ p ∧ c.2 ≠ p) ∧ N'.length + (track N p).2 = N.length ∧
      ∀ v : Fin n → ℕ, (∀ j, v p ≤ v j) → eval N v = eval N' v ∘ ρ := by
  intro L
  induction L with
  | zero =>
    intro N hN p
    have : N = [] := List.eq_nil_of_length_eq_zero hN
    subst this
    exact ⟨[], Equiv.refl _, by simp, by simp [track], fun v _ => rfl⟩
  | succ L ih =>
    intro N hN p
    match N, hN with
    | (a, b) :: rest, hN =>
      have hlen : rest.length = L := by simpa using hN
      by_cases hpa : p = a
      · subst hpa
        obtain ⟨N', ρ, hav, hl, he⟩ := ih rest hlen p
        refine ⟨N', ρ, hav, ?_, ?_⟩
        · rw [track_cons]; simp; omega
        · intro v hv
          rw [eval_cons, applyC_min_left p b v hv]
          exact he v hv
      · by_cases hpb : p = b
        · subst hpb
          set τ := Equiv.swap a p with hτ
          obtain ⟨N', ρ, hav, hl, he⟩ := ih (rest.map (conjC τ)) (by simpa using hlen) p
          refine ⟨N', τ.trans ρ, hav, ?_, ?_⟩
          · have htc := track_conj τ rest a
            have hτa : τ a = p := Equiv.swap_apply_left a p
            rw [hτa] at htc
            rw [htc] at hl
            rw [track_cons]
            simp only [or_true, if_true]
            simp at hl ⊢
            omega
          · intro v hv
            rw [eval_cons, applyC_min_right a p (Ne.symm hpa) v hv, ← eval_conj τ rest, he v hv,
              Equiv.coe_trans]
            rfl
        · obtain ⟨N', ρ, hav, hl, he⟩ := ih rest hlen p
          refine ⟨(a, b) :: N', ρ, ?_, ?_, ?_⟩
          · intro c hc
            rcases List.mem_cons.1 hc with h | h
            · subst h; exact ⟨Ne.symm hpa, Ne.symm hpb⟩
            · exact hav c h
          · rw [track_cons]
            simp only [hpa, hpb, or_self, if_false]
            simp; omega
          · intro v hv
            rw [eval_cons, he _ (applyC_other (a, b) p hpa hpb v hv), eval_cons]

/-! ### Removing an untouched wire -/

lemma applyC_insertNth {m : ℕ} (w : Fin (m + 1)) (a b : Fin m) (x : ℕ) (u : Fin m → ℕ) :
    applyC (w.succAbove a, w.succAbove b) (Fin.insertNth w x u) =
      Fin.insertNth w x (applyC (a, b) u) := by
  funext k
  refine Fin.succAboveCases w ?_ (fun i => ?_) k
  · simp [applyC, Fin.succAbove_ne]
  · simp [applyC, Fin.succAbove_right_inj]

theorem lower {m : ℕ} (w : Fin (m + 1)) : ∀ N' : List (Comparator (m + 1)),
    (∀ c ∈ N', c.1 ≠ w ∧ c.2 ≠ w) →
    ∃ N'' : List (Comparator m), N''.length = N'.length ∧
      ∀ (x : ℕ) (u : Fin m → ℕ), eval N' (Fin.insertNth w x u) = Fin.insertNth w x (eval N'' u) := by
  intro N'
  induction N' with
  | nil => intro _; exact ⟨[], rfl, fun x u => rfl⟩
  | cons c rest ih =>
    intro hav
    obtain ⟨a, b⟩ := c
    have h1 : a ≠ w := (hav (a, b) (List.mem_cons_self ..)).1
    have h2 : b ≠ w := (hav (a, b) (List.mem_cons_self ..)).2
    obtain ⟨a', ha'⟩ := Fin.exists_succAbove_eq h1
    obtain ⟨b', hb'⟩ := Fin.exists_succAbove_eq h2
    obtain ⟨R, hR, hRe⟩ := ih (fun d hd => hav d (List.mem_cons_of_mem _ hd))
    refine ⟨(a', b') :: R, by simp [hR], ?_⟩
    intro x u
    rw [eval_cons, ← ha', ← hb', applyC_insertNth, hRe, eval_cons]

lemma eval_const {n : ℕ} : ∀ (N : List (Comparator n)) (x : ℕ), eval N (fun _ => x) = fun _ => x := by
  intro N
  induction N with
  | nil => intro x; rfl
  | cons c N ih =>
    intro x
    have : applyC c (fun _ => x) = fun _ => x := by
      funext k; simp only [applyC]; split_ifs <;> simp
    rw [eval_cons, this, ih]

/-! ### The recurrence -/

theorem main_step (m k : ℕ) (hk : SizeLowerBound m k) : SizeLowerBound (m + 1) (k + Nat.clog 2 (m + 1)) := by
  intro N hstd hsort
  -- 1. every token ends on wire 0
  have hend : ∀ w, (track N w).1 = 0 := by
    intro w
    by_contra hne
    have hmono := hsort (ind w)
    rw [eval_ind] at hmono
    have := hmono (Fin.zero_le (track N w).1)
    simp [ind, hne] at this
    exact hne this.symm
  -- 2. a deep token
  obtain ⟨w, hw⟩ := exists_deep (Nat.succ_pos m) N 0 hend
  -- 3. strip its path
  obtain ⟨N', ρ, hav, hl, he⟩ := strip N.length N rfl w
  -- 4. remove its wire
  obtain ⟨N'', hl'', hrel⟩ := lower w N' hav
  -- 5. untangle
  obtain ⟨S, hS, hSl, ρ', hρ'⟩ := untangle N''.length N'' rfl
  -- the composite description of N on inputs with a minimum on wire w
  have hN : ∀ u : Fin m → ℕ, eval N (Fin.insertNth w 0 u) = Fin.insertNth w 0 (eval N'' u) ∘ ρ := by
    intro u
    rw [he (Fin.insertNth w 0 u) (by intro j; simp), hrel]
  -- ρ 0 = w
  have hρ0 : ρ 0 = w := by
    have h1 := hN (fun _ => 1)
    rw [eval_const] at h1
    have hind : (Fin.insertNth w 0 (fun _ : Fin m => (1 : ℕ)) : Fin (m + 1) → ℕ) = ind w := by
      funext j
      refine Fin.succAboveCases w ?_ (fun i => ?_) j
      · simp [ind]
      · simp [ind, Fin.succAbove_ne]
    rw [hind, eval_ind, hend w] at h1
    have h0 := congrFun h1 0
    simp only [Function.comp, ind, if_true] at h0
    by_contra hne
    obtain ⟨i, hi⟩ := Fin.exists_succAbove_eq hne
    rw [← hi] at h0
    simp [Fin.succAbove_ne] at h0
  -- the induced map π on the remaining wires
  have hne : ∀ i : Fin m, ρ (Fin.succ i) ≠ w := by
    intro i h
    rw [← hρ0] at h
    exact Fin.succ_ne_zero i (ρ.injective h)
  let π : Fin m → Fin m := fun i => (Fin.exists_succAbove_eq (hne i)).choose
  have hπ : ∀ i, w.succAbove (π i) = ρ (Fin.succ i) := fun i => (Fin.exists_succAbove_eq (hne i)).choose_spec
  have hπinj : Function.Injective π := by
    intro i j hij
    have := congrArg w.succAbove hij
    rw [hπ, hπ] at this
    exact Fin.succ_injective _ (ρ.injective this)
  -- N'' composed with π sorts
  have hsortS : ∀ u : Fin m → ℕ, Monotone (eval S u ∘ (ρ' ∘ π)) := by
    intro u
    have hm := hsort (Fin.insertNth w 0 u)
    rw [hN] at hm
    have hm2 : Monotone (fun i : Fin m => (Fin.insertNth w 0 (eval N'' u) ∘ ρ) (Fin.succ i)) :=
      hm.comp (Fin.strictMono_succ.monotone)
    have : (fun i : Fin m => (Fin.insertNth w 0 (eval N'' u) ∘ ρ) (Fin.succ i)) = eval S u ∘ (ρ' ∘ π) := by
      funext i
      simp only [Function.comp]
      rw [← hπ, Fin.insertNth_apply_succAbove, hρ']
      rfl
    rw [this] at hm2
    exact hm2
  -- the permutation is the identity
  have hσ : (ρ' ∘ π) = id := by
    have hm := hsortS (fun i => i.val)
    rw [eval_std_mono S hS _ (fun i j h => h)] at hm
    apply fin_mono_inj_eq_id
    · intro i j h
      exact hm h
    · exact ρ'.injective.comp hπinj
  have hSsort : Sorts S := by
    intro u
    have := hsortS u
    rwa [hσ, Function.comp_id] at this
  have := hk S hS hSsort
  have hw' : Nat.clog 2 (m + 1) ≤ (track N w).2 := hw
  omega

end SortNet

/-! ### Corollaries: explicit bounds from cited base values (taken as hypotheses) -/

namespace SortNet

lemma clog_two_eq (n c : ℕ) (h1 : 2 ^ c < n) (h2 : n ≤ 2 ^ (c + 1)) : Nat.clog 2 n = c + 1 := by
  apply le_antisymm
  · exact (Nat.clog_le_iff_le_pow (by norm_num)).2 h2
  · exact Nat.succ_le_of_lt ((Nat.lt_clog_iff_pow_lt (by norm_num)).2 h1)

/-- One step of the recurrence with the value of `⌈log₂ (m+1)⌉` supplied. -/
lemma step (m k c : ℕ) (hc : Nat.clog 2 (m + 1) = c) (h : SizeLowerBound m k) :
    SizeLowerBound (m + 1) (k + c) := by
  have := main_step m k h
  rwa [hc] at this

/-- From s(11) ≥ 35 (Harder 2020, Isabelle-verified checker): the bounds 39, 43, 47, ..., 135 for n = 12..32. -/
theorem bounds_from_s11 (h : SizeLowerBound 11 35) :
    SizeLowerBound 12 39 ∧
    SizeLowerBound 13 43 ∧
    SizeLowerBound 14 47 ∧
    SizeLowerBound 15 51 ∧
    SizeLowerBound 16 55 ∧
    SizeLowerBound 17 60 ∧
    SizeLowerBound 18 65 ∧
    SizeLowerBound 19 70 ∧
    SizeLowerBound 20 75 ∧
    SizeLowerBound 21 80 ∧
    SizeLowerBound 22 85 ∧
    SizeLowerBound 23 90 ∧
    SizeLowerBound 24 95 ∧
    SizeLowerBound 25 100 ∧
    SizeLowerBound 26 105 ∧
    SizeLowerBound 27 110 ∧
    SizeLowerBound 28 115 ∧
    SizeLowerBound 29 120 ∧
    SizeLowerBound 30 125 ∧
    SizeLowerBound 31 130 ∧
    SizeLowerBound 32 135 := by
  have h12 : SizeLowerBound 12 39 := step 11 35 4 (clog_two_eq 12 3 (by norm_num) (by norm_num)) h
  have h13 : SizeLowerBound 13 43 := step 12 39 4 (clog_two_eq 13 3 (by norm_num) (by norm_num)) h12
  have h14 : SizeLowerBound 14 47 := step 13 43 4 (clog_two_eq 14 3 (by norm_num) (by norm_num)) h13
  have h15 : SizeLowerBound 15 51 := step 14 47 4 (clog_two_eq 15 3 (by norm_num) (by norm_num)) h14
  have h16 : SizeLowerBound 16 55 := step 15 51 4 (clog_two_eq 16 3 (by norm_num) (by norm_num)) h15
  have h17 : SizeLowerBound 17 60 := step 16 55 5 (clog_two_eq 17 4 (by norm_num) (by norm_num)) h16
  have h18 : SizeLowerBound 18 65 := step 17 60 5 (clog_two_eq 18 4 (by norm_num) (by norm_num)) h17
  have h19 : SizeLowerBound 19 70 := step 18 65 5 (clog_two_eq 19 4 (by norm_num) (by norm_num)) h18
  have h20 : SizeLowerBound 20 75 := step 19 70 5 (clog_two_eq 20 4 (by norm_num) (by norm_num)) h19
  have h21 : SizeLowerBound 21 80 := step 20 75 5 (clog_two_eq 21 4 (by norm_num) (by norm_num)) h20
  have h22 : SizeLowerBound 22 85 := step 21 80 5 (clog_two_eq 22 4 (by norm_num) (by norm_num)) h21
  have h23 : SizeLowerBound 23 90 := step 22 85 5 (clog_two_eq 23 4 (by norm_num) (by norm_num)) h22
  have h24 : SizeLowerBound 24 95 := step 23 90 5 (clog_two_eq 24 4 (by norm_num) (by norm_num)) h23
  have h25 : SizeLowerBound 25 100 := step 24 95 5 (clog_two_eq 25 4 (by norm_num) (by norm_num)) h24
  have h26 : SizeLowerBound 26 105 := step 25 100 5 (clog_two_eq 26 4 (by norm_num) (by norm_num)) h25
  have h27 : SizeLowerBound 27 110 := step 26 105 5 (clog_two_eq 27 4 (by norm_num) (by norm_num)) h26
  have h28 : SizeLowerBound 28 115 := step 27 110 5 (clog_two_eq 28 4 (by norm_num) (by norm_num)) h27
  have h29 : SizeLowerBound 29 120 := step 28 115 5 (clog_two_eq 29 4 (by norm_num) (by norm_num)) h28
  have h30 : SizeLowerBound 30 125 := step 29 120 5 (clog_two_eq 30 4 (by norm_num) (by norm_num)) h29
  have h31 : SizeLowerBound 31 130 := step 30 125 5 (clog_two_eq 31 4 (by norm_num) (by norm_num)) h30
  have h32 : SizeLowerBound 32 135 := step 31 130 5 (clog_two_eq 32 4 (by norm_num) (by norm_num)) h31
  exact ⟨h12, h13, h14, h15, h16, h17, h18, h19, h20, h21, h22, h23, h24, h25, h26, h27, h28, h29, h30, h31, h32⟩

/-- The trivial base case: one wire needs no comparators. -/
lemma sizeLowerBound_one_zero : SizeLowerBound 1 0 := fun _ _ _ => Nat.zero_le _

/-- Unconditional: s(2) ≥ 1, s(3) ≥ 3, s(4) ≥ 5, s(5) ≥ 8, s(6) ≥ 11 from s(1) ≥ 0. -/
theorem unconditional_small :
    SizeLowerBound 2 1 ∧
    SizeLowerBound 3 3 ∧
    SizeLowerBound 4 5 ∧
    SizeLowerBound 5 8 ∧
    SizeLowerBound 6 11 := by
  have h2 : SizeLowerBound 2 1 := step 1 0 1 (clog_two_eq 2 0 (by norm_num) (by norm_num)) sizeLowerBound_one_zero
  have h3 : SizeLowerBound 3 3 := step 2 1 2 (clog_two_eq 3 1 (by norm_num) (by norm_num)) h2
  have h4 : SizeLowerBound 4 5 := step 3 3 2 (clog_two_eq 4 1 (by norm_num) (by norm_num)) h3
  have h5 : SizeLowerBound 5 8 := step 4 5 3 (clog_two_eq 5 2 (by norm_num) (by norm_num)) h4
  have h6 : SizeLowerBound 6 11 := step 5 8 3 (clog_two_eq 6 2 (by norm_num) (by norm_num)) h5
  exact ⟨h2, h3, h4, h5, h6⟩

end SortNet

theorem van_voorhis_recurrence :
    ∀ m k : ℕ, SortNet.SizeLowerBound m k →
      SortNet.SizeLowerBound (m + 1) (k + Nat.clog 2 (m + 1)) := by
  intro m k hk
  exact SortNet.main_step m k hk
