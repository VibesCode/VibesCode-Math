# model file from cadical -w -> kept set = M_n minus deleted active vertices
import sys, json
from inst import M
n=int(sys.argv[1]); cnf=sys.argv[2]; w=sys.argv[3]; out=sys.argv[4]
meta=json.load(open(cnf+".meta.json")); act=meta["active"]
lits=[int(t) for l in open(w) for t in l.split()]
pos={l for l in lits if l>0}
dele={act[i-1] for i in range(1,len(act)+1) if i in pos}
A=[x for x in M(n) if x not in dele]
open(out,"w").write("\n".join(map(str,A))+"\n"); print(len(A),"kept,",len(dele),"deleted")
