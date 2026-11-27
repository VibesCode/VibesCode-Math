# encoding 2 + kissat: SAT at L=s (witness checked), UNSAT at L=s+1 with DRAT proof checked by drat-trim
K=~/tools/kissat/build/kissat; D=~/tools/drat-trim/drat-trim
n=$1; s=$2
python3 enc2.py $n $s e$n-sat.cnf >/dev/null; python3 enc2.py $n $((s+1)) e$n-uns.cnf > /dev/null
$K -q e$n-sat.cnf | grep ^v | sed s/^v// > e$n.model; python3 wit2.py e$n-sat.cnf e$n.model E$n.txt >/dev/null; c=$(python3 check.py $n E$n.txt 2>&1 | tail -1)
T=$(date +%s); $K -q --no-binary e$n-uns.cnf q$n.drat > /dev/null; r=$?; T=$(( $(date +%s)-T ))
d=$($D e$n-uns.cnf q$n.drat -t 100000 | 2>&1 | grep -E "s (VERIFIED|NOT)")
echo "n=$n s=$s witness:[$c] unsat_rc=$r ${T}s drat:[$d]"
