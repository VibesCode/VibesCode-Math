# Erdős Problem 707: Mueller's four-element sets

**Status: a partial result.** The four-element question stays open.

## The question

A *perfect difference set* modulo n is a set B of residues in which every nonzero residue mod n is a difference b − b′ of elements of B in exactly one way. Its *order* is |B| − 1. These are exactly the cyclic projective planes. Erdős Problem 707 ([erdosproblems.com/707](https://www.erdosproblems.com/707)) asks whether every finite Sidon set embeds in some perfect difference set.

Sawin settled the three-element case. For four elements, Peter Mueller (MathOverflow answer 502053) found **{0, 1, 3, 11}** and **{0, 1, 4, 11}**, which lie in no Singer difference set. No perfect difference set containing either is known.

## The theorems

Let B ⊆ ℕ be a perfect difference set for any modulus n. No assumption is made that the order is a prime power or that the plane is Desarguesian. We use formal-conjectures' definition `IsPerfectDifferenceSet`, unchanged (commit 9097e2f).

1. **If the order of B is even, B contains neither {0, 1, 3, 11} nor {0, 1, 4, 11}.**
2. **If the order of B is divisible by 3, B does not contain {0, 1, 3, 11}.** (Together with 1: divisible by 2 or by 3.)

In Lean ([`VibesCodeMath/Erdos707/Challenge.lean`](../VibesCodeMath/Erdos707/Challenge.lean)):

```lean
theorem sets_0_1_3_11_and_0_1_4_11_not_in_even_order_pds :
    ∀ (B : Set ℕ) (n : ℕ), IsPerfectDifferenceSet B n → Odd B.ncard →
      ¬ ({0, 1, 3, 11} : Set ℕ) ⊆ B ∧ ¬ ({0, 1, 4, 11} : Set ℕ) ⊆ B

theorem set_0_1_3_11_not_in_pds_of_order_div_two_or_three :
    ∀ (B : Set ℕ) (n : ℕ), IsPerfectDifferenceSet B n → B.Finite →
      (2 ∣ B.ncard - 1 ∨ 3 ∣ B.ncard - 1) → ¬ ({0, 1, 3, 11} : Set ℕ) ⊆ B
```

**About "contains".** The statements use literal containment, A ⊆ B. That is equivalent to the notion that A extends to a perfect difference set *up to affine maps* x ↦ ux + b with u a unit. Such a map sends a perfect difference set to another one of the same order, so uA + b ⊆ B exactly when A ⊆ u⁻¹(B − b).

## How the proofs go

- **Even order: Baer's polarity argument.** When |B| is odd, every translate 2B + t meets B. Applied to the candidate sets, this forces an element of B that creates a repeated difference.
- **Order divisible by 2 or 3: Hall's multiplier theorem.** For a prime p dividing the order, pB is a translate of B. `Solution.lean` contains a complete Lean proof of **Hall's multiplier theorem for planar difference sets**, for any modulus: Frobenius in the group algebra (ZMod p)[ZMod n], then a counting argument. For p = 2 the multiplier forces 7 ∈ B, and 11 − 7 = 7 − 3. For p = 3 it forces 9 ∈ B, and 9 − 1 = 11 − 3. Either way two differences coincide.

## Credits, and what is not new

- Peter Mueller (MathOverflow answer 502053 to Mixon's question 501983, October 2025) found both sets, {0, 1, 3, 11} and {0, 1, 4, 11}. He proved, using an argument of Sawin's for the second, that neither lies in any Singer difference set. He also noted that the Hall–Baer arguments of Alexeev and Mixon force the order to be odd for a perfect difference set containing {0, 1, 3, 11}. T. Niu's preprint arXiv:2604.25214, which found the same two sets, has since been withdrawn by its author with reference to Mueller's answer.
- Sawin settled the three-element case.
- The methods are classical, due to Baer (1946) and Hall (1947). Our use of them follows Alexeev and Mixon (arXiv:2510.19804).
- **New here:**
  - the even-order case for {0, 1, 4, 11};
  - the case of order divisible by 3 for {0, 1, 3, 11}, using Hall's multiplier theorem (Mueller remarked that he did not see whether the multiplier theorem could help);
  - written proofs of both even-order cases;
  - complete Lean proofs of everything, including Hall's multiplier theorem for planar difference sets, which is not in Mathlib.
  
  All of this holds for every perfect difference set, Singer or not.

## What is left open

- For {0, 1, 4, 11}: every odd order.
- For {0, 1, 3, 11}: orders whose prime factors are all at least 5.

The multiplier theorem alone gives no contradiction for p ≥ 5, so closing these needs a new ingredient.

## Rerun

`lake build` from the repository root compiles `Challenge.lean`, `Solution.lean` and `Verify.lean`. `Verify.lean` prints `[propext, Classical.choice, Quot.sound]` for both theorems. `scripts/pds_check.py` confirms that genuine planar difference sets of orders 2, 3, 4, 5 and 8 satisfy the formal definition, so the hypotheses can be met.
