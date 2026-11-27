# usage: solvewit.sh n cnf out ; runs cadical, takes the model from stdout, checks it satisfies the CNF, extracts set, runs checker
n=$1; f=$2; o=$3
~/tools/cadical/build/cadical -q --modelalllits=true $f > $f.out; rc=$?
[ $rc = 10 ] || { echo "rc=$rc"; exit 1; }
grep "^v" $f.out | sed 's/^v//' > $f.model
python3 wit.py $n $f $f.model $o && python3 check.py $n $o
