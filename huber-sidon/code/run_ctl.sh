# for each n: tau = N - s(n); expect SAT at tau, UNSAT at tau-1 with DRAT checked
C=~/tools/cadical/build/cadical; D=~/tools/drat-trim/drat-trim
declare -A s=([5]=6 [6]=8 [7]=11 [8]=15 [9]=20 [10]=25 [11]=30 [12]=39 [13]=45 [14]=55 [15]=66 [16]=83)
for n in "$@"; do
  N=$(python3 -c "from inst import M;print(len(M($n)))"); t=$((N-${s[$n]}))
  python3 cnf.py $n $t c$n-sat.cnf >/dev/null; python3 cnf.py $n $((t-1)) c$n-uns.cnf >/dev/null
  r1=$($C -q c$n-sat.cnf -w w$n.txt; echo $?)
  T0=$(date +%s.%N); $C -q --no-binary c$n-uns.cnf p$n.drat >/dev/null; r2=$?; echo "$(date +%s.%N) - $T0" | bc > t$n
  dt=$($D c$n-uns.cnf p$n.drat -t 50000 | grep -E "s VERIFIED|s NOT" )
  echo "n=$n N=$N tau=$t satrc=$r1 unsrc=$r2 solve=$(cat t$n)s drat:$dt"
done
