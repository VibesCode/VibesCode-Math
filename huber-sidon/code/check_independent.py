# Independent check: own M_n, own Sidon check, own CNF (kept variables over all of M_n, "at least L kept" by a pysat cardinality network).
import sys
from math import factorial
from itertools import combinations_with_replacement
def partitions(n,m=None):
    if m is None: m=n
    if n==0: yield (); return
    for p in range(min(n,m),0,-1):
        for rest in partitions(n-p,p): yield (p,)+rest
def M(n):
    f=factorial(n); out=set()
    for p in partitions(n):
        d=1
        for x in p: d*=factorial(x)
        assert f%d==0; out.add(f//d)
    return sorted(out)
def sidon(A):
    S=set()
    for a,b in combinations_with_replacement(sorted(A),2):
        if a+b in S: return False
        S.add(a+b)
    return True
def cnf(n,L,enc):
    from pysat.card import CardEnc, EncType
    from pysat.formula import CNF
    V=M(n); idx={v:i+1 for i,v in enumerate(V)}
    by={}
    for a,b in combinations_with_replacement(V,2): by.setdefault(a+b,[]).append((a,b))
    cl=set()
    for s,prs in by.items():
        for i in range(len(prs)):
            for j in range(i+1,len(prs)):
                sup=set(prs[i])|set(prs[j]); cl.add(tuple(sorted(-idx[x] for x in sup)))
    F=CNF(from_clauses=[list(c) for c in cl])
    card=CardEnc.atleast(lits=list(range(1,len(V)+1)),bound=L,top_id=len(V),encoding=getattr(EncType,enc))
    F.extend(card.clauses); return F,len(V),len(cl)
if __name__=="__main__":
    if sys.argv[1]=="wit":
        n=int(sys.argv[2]); A=[int(l) for l in open(sys.argv[3]) if l.strip()]; Mn=set(M(n))
        print(n,len(Mn),len(A),len(set(A))==len(A),all(a in Mn for a in A),sidon(A))
    else:
        n,L,enc,out=int(sys.argv[2]),int(sys.argv[3]),sys.argv[4],sys.argv[5]
        F,nv,nc=cnf(n,L,enc); F.to_file(out); print("vars",nv,"collision clauses",nc,"total",len(F.clauses))
