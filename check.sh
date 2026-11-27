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
for t in van_voorhis_recurrence_check SortNet.bounds_from_s11 SortNet.unconditional_small a120121_bound_check huber_s16_ge_check huber_s17_ge_check huber_s18_ge_check a379397_bound_check a066494_reduction_check crystal_reduction_check CrystalUniqueness.crystal_iff_chain CrystalUniqueness.crystal_iff_pell CrystalUniqueness.crystal_k_determines CrystalUniqueness.x_strictMono CrystalUniqueness.nn_strictMonoOn; do
  echo "$out" | grep -q "'$t' depends on axioms: \[propext, Classical.choice, Quot.sound\]" \
    && echo "$t: ok, standard axioms only" || { echo "$t: unexpected axioms"; exit 1; }
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
echo "== A379397-A379400: counts to 100,000; A066494/A066516: terms to 10^6 =="
cc -O2 -o "$T/dp2" oeis-a379397/scripts/dp2.c
"$T/dp2" 100000 40 | diff -q - oeis-a379397/scripts/dp2-100000.log >/dev/null && echo "A379397-A379400 count to 100,000: ok" || { echo "A379397 count MISMATCH"; exit 1; }
cc -O2 -o "$T/check_b" oeis-a066494/scripts/check_b.c -lm
"$T/check_b" 1000000 2>&1 | diff -q - oeis-a066494/scripts/check_b-1e6.log >/dev/null && echo "A066494/A066516 to 10^6: ok" || { echo "A066494 MISMATCH"; exit 1; }
python3 oeis-a120121/scripts/enum_exact.py | grep "^A12012" | diff -q - <(grep "^A12012" oeis-a120121/scripts/enum_exact.log) >/dev/null && echo "A120121-A120123 exhaustive search: ok" || { echo "A120121 MISMATCH"; exit 1; }
cq=$(python3 oeis-a058627/scripts/cq_exact.py); echo "$cq" | grep -q "C < 8.2586: True" && echo "A058627 constant C < 8.2586: ok" || { echo "A058627 constant FAILED"; exit 1; }
g++ -O2 -o "$T/a058627" oeis-a058627/scripts/a058627.cpp && "$T/a058627" 1 8 oeis-a058627/scripts/q41.txt 2>&1 | grep "^k=" | diff -q - <(head -8 oeis-a058627/scripts/run_1_22.log) >/dev/null && echo "A058627 search k <= 8: ok" || { echo "A058627 search MISMATCH"; exit 1; }
ca=$(python3 covering-array-ca179/scripts/check_ca.py covering-array-ca179/CA_179_3_39_4.txt 179 3 39 4); echo "$ca" | grep -q "^COVERING ARRAY OK" && (cd covering-array-ca179 && sha256sum -c --quiet CA_179_3_39_4.txt.sha256) && echo "CA(179;3,39,4): all 9139 column triples covered, hash ok" || { echo "CA(179;3,39,4) check FAILED"; exit 1; }
head -n 178 covering-array-ca179/CA_179_3_39_4.txt > "$T/ca178.txt"; python3 covering-array-ca179/scripts/check_ca.py "$T/ca178.txt" 178 3 39 4 | grep -q "^NOT A COVERING ARRAY" && echo "CA negative control (last row deleted): correctly rejected" || { echo "CA negative control FAILED"; exit 1; }
ca2=$(python3 covering-array-ca216/scripts/check_ca.py covering-array-ca216/CA_216_3_11_5.txt 216 3 11 5); echo "$ca2" | grep -q "^COVERING ARRAY OK" && (cd covering-array-ca216 && sha256sum -c --quiet CA_216_3_11_5.txt.sha256) && echo "CA(216;3,11,5): all 165 column triples covered, hash ok" || { echo "CA(216;3,11,5) check FAILED"; exit 1; }
head -n 215 covering-array-ca216/CA_216_3_11_5.txt > "$T/ca215.txt"; python3 covering-array-ca216/scripts/check_ca.py "$T/ca215.txt" 215 3 11 5 | grep -q "^NOT A COVERING ARRAY" && echo "CA(216) negative control (last row deleted): correctly rejected" || { echo "CA(216) negative control FAILED"; exit 1; }
python3 oeis-a226472/scripts/verify.py | grep -q "^ALL OK" && echo "A226472: the 13 terms are exact squares; brute force below 2*10^6 agrees" || { echo "A226472 verify FAILED"; exit 1; }
cc -O2 -o "$T/xs" oeis-a226472/scripts/xs.c -lm && cc -O2 -o "$T/xs2" oeis-a226472/scripts/xs2.c -lm
for p in xs xs2; do h=$("$T/$p" 0 100000000 | grep -o "n=[0-9]*" | tr '\n' ' '); [ "$h" = "n=0 n=1 n=6 n=8 n=4086 n=24136 n=162297 n=7868054 n=29792904 " ] && echo "A226472 scan $p over [0, 10^8): ok" || { echo "A226472 scan $p MISMATCH: $h"; exit 1; }; done
python3 oeis-a073614/scripts/verify.py | grep -q "^ALL OK" && echo "A073614: a(23) arithmetic exact, p prime" || { echo "A073614 verify FAILED"; exit 1; }
cc -O2 -o "$T/seg2" oeis-a073614/scripts/seg2.c && h=$("$T/seg2" 0 200000000 0 | tr '\n' ' ') && [ "$h" = "hit m=150 p=863 hit m=1274 p=10399 hit m=7776 p=79349 hit m=37631 p=449083 hit m=96625 p=1252259 hit m=1436778 p=22806361 hit m=1617173 p=25874767 hit m=8751645 p=155793619 END hi=200000000 pi=11078937 " ] && echo "A073614 sieve scan to 2*10^8: ok (known terms, pi(2*10^8) = 11078937)" || { echo "A073614 sieve scan MISMATCH"; exit 1; }
python3 erdos-261/scripts/verify_small.py 300 | grep -q "^ALL OK" && echo "Erdős 261(ii): exact representations for n <= 300: ok" || { echo "Erdős 261 small check FAILED"; exit 1; }
cc -O2 -o "$T/e261mine" erdos-261/scripts/mine.c && e1=$("$T/e261mine" 2 10000) && echo "$e1" | grep -q "^range \[2,10000\] all ok" && ! echo "$e1" | grep -q "^FAIL" && echo "Erdős 261(ii) mine.c, n <= 10^4: ok" || { echo "Erdős 261 mine.c FAILED"; exit 1; }
cc -O2 -o "$T/e261" erdos-261/scripts/e261.c && e2=$("$T/e261" 2 10000 1000000) && echo "$e2" | grep -q "nohit 0$" && echo "Erdős 261(ii) e261.c, n <= 10^4: ok" || { echo "Erdős 261 e261.c FAILED"; exit 1; }
sn=$(python3 sorting-network-size/scripts/check.py); echo "$sn" | diff -q - sorting-network-size/scripts/check.out >/dev/null && echo "Sorting networks: exact s(n), n <= 6, and random checks: ok" || { echo "Sorting networks check FAILED"; exit 1; }
echo "== Huber Sidon witnesses =="
python3 huber-sidon/code/check.py 16 huber-sidon/witnesses/s16.txt | grep -q "^OK n=16 |M_n|=157 |A|=83 Sidon" && echo "s(16) >= 83 witness: ok" || { echo "s16 witness FAILED"; exit 1; }
python3 huber-sidon/code/check.py 17 huber-sidon/witnesses/s17.txt | grep -q "^OK n=17 |M_n|=193 |A|=96 Sidon" && echo "s(17) >= 96 witness: ok" || { echo "s17 witness FAILED"; exit 1; }
python3 huber-sidon/code/check.py 18 huber-sidon/witnesses/s18.txt | grep -q "^OK n=18 |M_n|=243 |A|=119 Sidon" && echo "s(18) >= 119 witness: ok" || { echo "s18 witness FAILED"; exit 1; }
(cd huber-sidon/code && python3 cnf.py 18 123 "$T/c18.cnf" >/dev/null) && cmp -s "$T/c18.cnf" huber-sidon/cnf/c18-k123.cnf && echo "c18-k123.cnf regenerates byte for byte: ok" || { echo "CNF MISMATCH (n=18)"; exit 1; }
(cd huber-sidon/code && python3 cnf.py 17 96 "$T/c17.cnf" >/dev/null) && cmp -s "$T/c17.cnf" huber-sidon/cnf/c17-k96.cnf && echo "c17-k96.cnf regenerates byte for byte: ok" || { echo "CNF MISMATCH"; exit 1; }
echo "All checks passed."
