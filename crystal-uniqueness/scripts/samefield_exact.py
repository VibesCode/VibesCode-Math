# Exact check of Theorem D on a range: for each trace T>=3, chains k_r = L_r(T)+2 (r>=1) all live in one
# quadratic field; verify no two (r,t) give the same n below 10^BITS. Also verify the field grouping by
# squarefree part for k<=KMAX.
import sys, math
from sympy import factorint
def chain_vals(k, LIM):
    x0,x1=1,k; out=[]
    t=0
    while True:
        x2=(k-2)*x1-x0+2
        n=(2*x1-1)*(2*x2-1)
        if n>LIM: break
        out.append(n); x0,x1=x1,x2
    return out
LIM=10**int(sys.argv[1]); TMAX=int(sys.argv[2])
tot=0; bad=0; fields=0
for T in range(3,TMAX+1):
    L=[2,T]; ks=[]
    while True:
        k=L[-1]+2
        if 4*k**3>LIM: break
        ks.append(k); L.append(T*L[-1]-L[-2])
    if len(ks)<2: continue
    fields+=1
    seen={}
    for r,k in enumerate(ks,1):
        for t,n in enumerate(chain_vals(k,LIM),1):
            tot+=1
            if n in seen: bad+=1; print("COLLISION",T,seen[n],(r,t),n)
            seen[n]=(r,t)
print("fields with >=2 chains:",fields,"crystals checked:",tot,"collisions:",bad)
# grouping check
KMAX=int(sys.argv[3])
def sqf(m):
    s=1
    for p,e in factorint(m).items():
        if e%2: s*=p
    return s
groups={}
for k in range(5,KMAX+1): groups.setdefault(sqf(k*(k-4)),[]).append(k)
mism=0
for D,ks in groups.items():
    T=ks[0]-2
    L=[2,T]; pw={T+2}
    while L[-1]+2<=KMAX: L.append(T*L[-1]-L[-2]); pw.add(L[-1]+2)
    if not set(ks)<=pw: mism+=1; print("group not powers of smallest:",D,ks[:5])
print("groups:",len(groups),"multi:",sum(len(v)>1 for v in groups.values()),"mismatch:",mism)
