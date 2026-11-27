#!/usr/bin/env bash
# Reruns every check: the Lean proof (lake build) and the computations. Needs elan, a C compiler and Python 3.
set -euo pipefail
cd "$(dirname "$0")"; T="$(mktemp -d)"
echo "== Lean: lake build =="
[ -n "${SKIP_CACHE:-}" ] || lake exe cache get >/dev/null 2>&1 || echo "(Mathlib cache not reachable; building from source, which is slow)"
out=$(lake build 2>&1) || { echo "$out" | grep -E "error" ; exit 1; }
echo "$out" | grep -q "'target_check' depends on axioms: \[propext, Classical.choice, Quot.sound\]" \
  && echo "Lean proof: ok, standard axioms only" || { echo "unexpected axioms"; exit 1; }
echo "$out" | grep -q "'a245212_target_check' depends on axioms: \[propext, Classical.choice, Quot.sound\]" \
  && echo "A245212 proof: ok, standard axioms only" || { echo "A245212: unexpected axioms"; exit 1; }
for t in a135508_family_check a135508_bounded_check; do
  echo "$out" | grep -q "'$t' depends on axioms: \[propext, Classical.choice, Quot.sound\]" \
    && echo "A135508 ($t): ok, standard axioms only" || { echo "A135508 $t: unexpected axioms"; exit 1; }
done
for t in erdos707_even_order_check erdos707_order_div_two_or_three_check; do
  echo "$out" | grep -q "'$t' depends on axioms: \[propext, Classical.choice, Quot.sound\]" \
    && echo "Erdős 707 ($t): ok, standard axioms only" || { echo "Erdős 707 $t: unexpected axioms"; exit 1; }
done
python3 oeis-a135508/scripts/fidelity.py | diff -q - oeis-a135508/scripts/fidelity.out >/dev/null && echo "A135508 definition check: ok"
python3 oeis-a245212/scripts/fidelity.py | diff -q - oeis-a245212/scripts/fidelity.out >/dev/null && echo "A245212 definition check: ok"
echo "== Definitions match Ono's paper =="
python3 tan-arctan-explicit/scripts/fidelity.py | diff -q - tan-arctan-explicit/scripts/fidelity.out >/dev/null \
  && echo "fidelity: A_n, B_n reproduce Ono's Table 1 and Remark 3.3"
echo "== tan(arctan 1 + ... + arctan n), 5 <= n <= 10^6 =="
cc -O2 -o "$T/tancheck" tan-arctan-sum/check/tancheck.c -lm
got=$("$T/tancheck" 1000000 2>&1 | grep "^N="); want=$(grep '^N=' tan-arctan-sum/check/run_1e6.log)
[ "$got" = "$want" ] && echo "n <= 10^6: ok ($got)" || { echo "MISMATCH: $got vs $want"; exit 1; }
echo "All checks passed."
