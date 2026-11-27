# Build M_n and the collision hypergraph (forbidden supports) for the Sidon problem.
import math, collections, sys, json
def parts(n, m=None):
    if m is None: m = n
    if n == 0: yield []; return
    for k in range(min(n, m), 0, -1):
        for r in parts(n-k, k): yield [k]+r
def M(n):
    return sorted({math.factorial(n)//math.prod(math.factorial(k) for k in p) for p in parts(n)})
def supports(S):
    reps=collections.defaultdict(list)
    N=len(S)
    for i in range(N):
        for j in range(i,N): reps[S[i]+S[j]].append((i,j))
    E=set()
    for r in reps.values():
        for a in range(len(r)):
            for b in range(a+1,len(r)):
                E.add(frozenset(r[a])|frozenset(r[b]))
    E=sorted(E,key=lambda e:(len(e),sorted(e)))
    # minimal
    mins=[e for e in E if not any(f<e for f in E if len(f)<len(e))]
    return E,mins
if __name__=="__main__":
    for n in range(1,int(sys.argv[1])+1):
        S=M(n); E,mins=supports(S)
        act=set().union(*mins) if mins else set()
        print(n,len(S),len(E),len(mins),len(act),collections.Counter(len(e) for e in mins))
