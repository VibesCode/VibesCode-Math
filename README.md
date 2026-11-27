# VibesCode-Math

Machine-checked results in number theory. Every claim here comes with something you can rerun: a Lean 4 proof checked by the kernel, or an exact computation with its code and log. Each result says exactly what is proved, what is only computed, and what stays open.

## Headline result

**An explicit form of Ono's Corollary 1.2, fully checked in Lean.**

Let x_n = tan(arctan 1 + arctan 2 + ⋯ + arctan n). For every n ≥ 5 outside Ono's exceptional set E = {n ≥ 5 : |x_n| > n/2 + 1}, x_n is not an integer.

K. Ono (arXiv:2607.05739, July 2026) proved this for n ≥ n₀, with an n₀ that is effective but not given. Here **n₀ = 5**. The whole proof is checked by the Lean kernel against the statement in DeepMind's [formal-conjectures](https://github.com/google-deepmind/formal-conjectures), and it uses only the standard axioms.

What it does not do: it does not settle the Amdeberhan–Medina–Moll conjecture that x_n is never an integer for n ≥ 5. It says nothing about n in E, and E is not known to be finite. The mathematics builds on Ono's lemmas. What is new is the explicit constant and a complete machine-checked proof.

Details: [`tan-arctan-explicit/RESULT.md`](tan-arctan-explicit/RESULT.md).

## All results

This list grows as new results pass their checks.

| Result | Claim | Status |
| --- | --- | --- |
| [Explicit Ono Corollary 1.2](tan-arctan-explicit/RESULT.md) | For n ≥ 5 outside E, tan(arctan 1 + ⋯ + arctan n) is not an integer. | **Proved** in Lean 4 + Mathlib |
| [Exact check to 1.2·10⁸](tan-arctan-sum/RESULT.md) | tan(arctan 1 + ⋯ + arctan n) is not an integer for 5 ≤ n ≤ 1.2·10⁸. That covers every member of E in that range, including the twelve cases of Ono's Remark 3.3. | Finite verification. The conjecture stays **open**. |

## Layout

```
VibesCodeMath/TanArctanExplicit/
  Challenge.lean   the statement, exactly as in formal-conjectures (ends in sorry)
  Solution.lean    the proof
  Verify.lean      restates the claim, proves it from Solution.lean, prints the axioms used
tan-arctan-explicit/   write-up, plus scripts that check the definitions and show where the constants came from
tan-arctan-sum/        the exact computation to 1.2·10⁸: C and Python code, logs
check.sh               reruns everything
```

## Build and check

Toolchain: Lean 4 v4.33.1, Mathlib v4.33.1, formal-conjectures at commit `9097e2f`. All three are pinned in `lean-toolchain`, `lakefile.toml` and `lake-manifest.json`.

```bash
git clone https://github.com/VibesCode/VibesCode-Math && cd VibesCode-Math
lake exe cache get   # download the Mathlib build cache
lake build
```

`lake build` ends by printing `'target_check' depends on axioms: [propext, Classical.choice, Quot.sound]`. The only `sorry` is in `Challenge.lean`, which is the statement on its own.

To rerun the computations as well, run `bash check.sh`. It needs a C compiler and Python 3.

## What counts as a result here

- **Proved** means a Lean 4 proof that the kernel accepts. It has no `sorry`, adds no axioms, and `#print axioms` shows nothing beyond `propext`, `Classical.choice` and `Quot.sound`.
- **Computed** means exact integer or modular arithmetic, with the code, the command and the log, cross-checked against an independent method.

## Who's behind this

I'm VibesCode. I'm not a mathematician. I'd call what I do *reasoning engineering*: I direct AI systems toward open problems, and nothing is published here until a proof checker or an independent computation has confirmed it.

I believe the door is open now. Anyone with curiosity and creativity can contribute to mathematics, with or without a degree, as long as the work can be verified. Every result in this repo can be verified.

The work is AI-assisted, using Claude. The mathematics we build on is credited in each result.
