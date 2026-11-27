# Independent second encoding. Variables y_1..y_N: y_i true = i-th element of M_n KEPT (all N elements, no
# active-vertex reduction). For every pair-sum collision a+b = c+d ({a,b} != {c,d}, a<=b, c<=d), found by
# brute force over all pairs, one clause forbidding all of {a,b,c,d}. No minimality filtering.
# Cardinality "at least L kept" via a totalizer (unary adder tree). Usage: python enc2.py n L out.cnf
import sys
from math import comb
def Mset(n):
    out=set()
    def rec(rem, maxp, val):
        if rem==0: out.add(val); return
        for p in range(min(rem,maxp),0,-1): rec(rem-p, p, val*comb(rem,p))
    rec(n,n,1); return sorted(out)
n,L,out=int(sys.argv[1]),int(sys.argv[2]),sys.argv[3]
A=Mset(n); N=len(A)
bysum={}
for i in range(N):
    for j in range(i,N): bysum.setdefault(A[i]+A[j],[]).append((i,j))
cls=set()
for ps in bysum.values():
    for p in ps:
        for q in ps:
            if p<q: cls.add(tuple(sorted({p[0],p[1],q[0],q[1]})))
clauses=[[-(i+1) for i in c] for c in sorted(cls)]
nv=N
def new():
    global nv; nv+=1; return nv
# totalizer: node outputs o[1..m], o[j] true if at least j inputs true (only upward implications needed for "at least")
# For "at least L": we need o[j] -> (count >= j). Clauses: o[j] -> OR over splits (a_i and b_{j-i}).
# Use the standard both-direction totalizer for clarity and soundness.
def tot(lits):
    if len(lits)==1: return lits
    h=len(lits)//2; a=tot(lits[:h]); b=tot(lits[h:])
    o=[new() for _ in range(len(a)+len(b))]
    for i in range(len(a)+1):
        for j in range(len(b)+1):
            # count>=i in a and >=j in b  -> o[i+j]
            if i+j>0:
                c=[o[i+j-1]]
                if i>0: c.append(-a[i-1])
                if j>0: c.append(-b[j-1])
                clauses.append(c)
            # a < i+1 and b < j+1 -> not o[i+j+1]
            if i+j < len(o):
                c=[-o[i+j]]
                if i<len(a): c.append(a[i])
                if j<len(b): c.append(b[j])
                clauses.append(c)
    return o
o=tot(list(range(1,N+1)))
clauses.append([o[L-1]])
with open(out,"w") as f:
    f.write(f"p cnf {nv} {len(clauses)}\n")
    for c in clauses: f.write(" ".join(map(str,c))+" 0\n")
open(out+".elems","w").write("\n".join(map(str,A))+"\n")
print(n,L,"N",N,"collision clauses",len(cls),"vars",nv,"clauses",len(clauses))
