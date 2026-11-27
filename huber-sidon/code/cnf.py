# CNF: "at most k deletions hit every minimal forbidden support" (Sinz sequential counter).
# var d_v (v = index into active list) true = v deleted. Usage: python cnf.py n k out.cnf
import sys, json
from inst import M, supports
n,k,out=int(sys.argv[1]),int(sys.argv[2]),sys.argv[3]
S=M(n); E,mins=supports(S)
act=sorted(set().union(*mins)); idx={v:i+1 for i,v in enumerate(act)}; m=len(act)
cl=[[idx[v] for v in sorted(e)] for e in mins]
# sequential counter s[i][j] (i=1..m, j=1..k): among first i vars at least j true
nv=m
s={}
def S_(i,j):
    global nv
    if (i,j) not in s: nv+=1; s[(i,j)]=nv
    return s[(i,j)]
if k==0:
    cl+= [[-i] for i in range(1,m+1)]
else:
    for i in range(1,m+1):
        x=i
        cl.append([-x,S_(i,1)])
        if i>1:
            for j in range(1,k+1): cl.append([-S_(i-1,j),S_(i,j)])
            for j in range(2,k+1): cl.append([-x,-S_(i-1,j-1),S_(i,j)])
            cl.append([-x,-S_(i-1,k)])
        # i==1: s(1,j)=false for j>=2 by simply never asserting
with open(out,"w") as f:
    f.write(f"p cnf {nv} {len(cl)}\n")
    for c in cl: f.write(" ".join(map(str,c))+" 0\n")
json.dump({"n":n,"k":k,"N":len(S),"active":[S[v] for v in act]},open(out+".meta.json","w"))
print(n,k,"vars",nv,"clauses",len(cl))
