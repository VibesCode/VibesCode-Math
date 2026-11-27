# VibesCode-Math

Machine-checked results in number theory. Every claim here comes with something you can rerun: a Lean 4 proof checked by the kernel, or an exact computation with its code and log. Each result says exactly what is proved, what is only computed, and what stays open.

## Headline result

**An explicit form of Ono's Corollary 1.2, fully checked in Lean.**

Let x_n = tan(arctan 1 + arctan 2 + ⋯ + arctan n). For every n ≥ 5 outside Ono's exceptional set E = {n ≥ 5 : |x_n| > n/2 + 1}, x_n is not an integer.

K. Ono (arXiv:2607.05739, July 2026) proved this for n ≥ n₀, with an n₀ that is effective but not given. Here **n₀ = 5**. The whole proof is checked by the Lean kernel against the statement in DeepMind's [formal-conjectures](https://github.com/google-deepmind/formal-conjectures), and it uses only the standard axioms.

What it does not do: it does not settle the Amdeberhan–Medina–Moll conjecture that x_n is never an integer for n ≥ 5. It says nothing about n in E, and E is not known to be finite. The mathematics builds on Ono's lemmas. What is new is the explicit constant and a complete machine-checked proof.

Details: [`tan-arctan-explicit/RESULT.md`](tan-arctan-explicit/RESULT.md).

## All results

This list grows as new results pass their checks. Each one states exactly what it covers.

### Main results

| Result | Claim | Status |
| --- | --- | --- |
| [Explicit Ono Corollary 1.2](tan-arctan-explicit/RESULT.md) | For n ≥ 5 outside E, tan(arctan 1 + ⋯ + arctan n) is not an integer. | **Proved** in Lean 4 + Mathlib |
| [Erdős 707, Niu's four-element sets](erdos-707/RESULT.md) | Niu's candidate sets {0,1,3,11} and {0,1,4,11} lie in no perfect difference set of even order, and {0,1,3,11} lies in none whose order is divisible by 3. This holds for any modulus, with no prime-power or Desarguesian assumption. Includes a Lean proof of Hall's multiplier theorem for planar difference sets. The question and the sets are Niu's (arXiv:2604.25214). The even case for {0,1,3,11} was asserted without proof by Mueller (MathOverflow 502053). The methods are classical (Baer, Hall), following Alexeev and Mixon. | **Proved** in Lean 4 + Mathlib, as a partial result. The four-element question stays **open**. |

Supporting computation for the tangent theorem: an [exact check](tan-arctan-sum/RESULT.md) that tan(arctan 1 + ⋯ + arctan n) is not an integer for every 5 ≤ n ≤ 1.2·10⁸. It covers the members of E in that range, which the theorem leaves aside, including the twelve cases of Ono's Remark 3.3. The conjecture itself stays open.

### Smaller results

| Result | Claim | Status |
| --- | --- | --- |
| [OEIS A135508, McEachen's conjecture](oeis-a135508/RESULT.md) | McEachen's conjecture (OEIS A135508, formal-conjectures `OeisA135508.conjecture`) says a(p − 1) = p for every prime p with p − 2 not prime. We prove it for every such p where p − 2 has a prime factor below 400, an infinite family, and so for every prime p < 160,000. Earlier checks went to p < 20,000. The key reduction is due to others (Cloitre, arXiv:2510.18891, and public Lean work), as credited. | **Proved** in Lean 4 + Mathlib, as a partial result. The remaining primes stay **open**. |
| [OEIS A245212, squarefree odd part](oeis-a245212/RESULT.md) | The conjecture recorded in OEIS A245212 (formal-conjectures `OeisA245212.conjecture`) says a(n) = σ(n) exactly when n is a power of 2. We prove it when the odd part of n is squarefree. It is a short parity argument. We found no earlier proof, but it may be folklore. | **Proved** in Lean 4 + Mathlib, as a partial result. The other cases stay **open**. |

## Layout

```
VibesCodeMath/TanArctanExplicit/
  Challenge.lean   the statement, exactly as in formal-conjectures (ends in sorry)
  Solution.lean    the proof
  Verify.lean      restates the claim, proves it from Solution.lean, prints the axioms used
tan-arctan-explicit/   write-up, plus scripts that check the definitions and show where the constants came from
tan-arctan-sum/        the exact computation to 1.2·10⁸: C and Python code, logs
VibesCodeMath/Erdos707/      Challenge, Solution, Verify for the Erdős 707 result
erdos-707/             write-up and a check that the definition is satisfiable
VibesCodeMath/OeisA135508/   Challenge, Solution, Verify for the A135508 result
oeis-a135508/          write-up and definition check
VibesCodeMath/OeisA245212/   Challenge, Solution, Verify for the A245212 result
oeis-a245212/          write-up, definition check and search code
check.sh               reruns everything
```

## Build and check

Toolchain: Lean 4 v4.33.1, Mathlib v4.33.1, formal-conjectures at commit `9097e2f`. All three are pinned in `lean-toolchain`, `lakefile.toml` and `lake-manifest.json`.

```bash
git clone https://github.com/VibesCode/VibesCode-Math && cd VibesCode-Math
lake exe cache get   # download the Mathlib build cache
lake build
```

`lake build` prints the axioms of each result's `Verify.lean` check, and every one should read `[propext, Classical.choice, Quot.sound]`. The only `sorry`s are in the `Challenge.lean` files, which hold the statements on their own.

Memory: the A135508 proof has the Lean kernel check a finite table, which needs about 10 GB of free memory. Everything else builds in ordinary memory.

To rerun the computations as well, run `bash check.sh`. It needs a C compiler and Python 3.

## What counts as a result here

- **Proved** means a Lean 4 proof that the kernel accepts. It has no `sorry`, adds no axioms, and `#print axioms` shows nothing beyond `propext`, `Classical.choice` and `Quot.sound`.
- **Computed** means exact integer or modular arithmetic, with the code, the command and the log, cross-checked against an independent method.

## Who's behind this

I'm VibesCode. I'm not a mathematician. I'd call what I do *reasoning engineering*: I direct AI systems toward open problems, and nothing is published here until a proof checker or an independent computation has confirmed it.

I believe the door is open now. Anyone with curiosity and creativity can contribute to mathematics, with or without a degree, as long as the work can be verified. Every result in this repo can be verified.

The work is AI-assisted, using Claude. The mathematics we build on is credited in each result.
