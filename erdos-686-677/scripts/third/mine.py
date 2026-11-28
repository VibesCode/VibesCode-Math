# Third independent check, written separately from the other two programs. Solve v*P(m) = u*P(n), m >= n+k, P(t)=(t+1)...(t+k), centre X = n+(k+1)/2.
# Small X: exact band search (m between c(n+1)-1 and c(n+k)-k). Large X: Stern-Brocot walk over reduced a/b with
# 0 < c - a/b < Cq/b^2 (Cq = s^2 * c+ * S2 / (2k (1 - h^2/X0^2)), s = 1 odd k, 2 even k), exact integer pruning.
import sys, math
from fractions import Fraction as Fr
def iroot(n,k):
    if n<2: return n
    x=1<<((n.bit_length()+k-1)//k)
    while True:
        y=((k-1)*x+n//x**(k-1))//k
        if y>=x: break
        x=y
    while x**k>n: x-=1
    while (x+1)**k<=n: x+=1
    return x
def P(t,k):
    r=1
    for i in range(1,k+1): r*=t+i
    return r
def solve(k,u,v,Xmax,n0,D):
    sols=[]; small=[]
    # exact floor of c*10^D
    C0=iroot(u*10**(D*k)//v,k); TEN=10**D
    def lt_c(a,b):   # a/b < c ?
        if a*TEN < b*C0: return True
        if a*TEN >= b*(C0+1): return a**k*v < u*b**k if a*TEN==b*(C0+1) else False
        return a**k*v < u*b**k
    # small range: n = 0..n0 by the band
    cf=(u/v)**(1.0/k)
    for n in range(0,n0+1):
        lo=max(n+1,int(cf*(n+1))-3); hi=int(cf*(n+k))+3
        Pn=u*P(n,k)
        for m in range(lo,hi+1):
            if v*P(m,k)==Pn:
                (sols if m>=n+k else small).append((n,m))
    # walk for X > X0
    X0=Fr(2*n0+k+1,2)  # X of n0; walk covers X > X0 (n > n0)
    s=1 if k%2 else 2
    h=Fr(k-1,2); S2=Fr(k**3-k,12); cplus=Fr(C0+1,TEN)
    Cq=s*s*cplus*S2/(2*k*(1-h*h/(X0*X0)))
    Cn,Cd=Cq.numerator,Cq.denominator
    Qmax=s*Xmax
    stack=[(0,1,1,0)]; nodes=0; cands=0
    while stack:
        la,lb,ra,rb=stack.pop()
        q0=lb+rb
        if q0>Qmax: continue
        # prune l >= c
        if not lt_c(la,lb): continue
        # prune r <= c - Cq/q0^2 (sufficient: r + Cq/q0^2 <= C0/TEN), r=1/0 never pruned here
        if rb>0 and (ra*Cd*q0*q0 + Cn*rb)*TEN <= C0*rb*Cd*q0*q0: continue
        a,b=la+ra,q0; nodes+=1
        if lt_c(a,b):
            g=1
            while g*b<=Qmax:
                # stop when surely c - a/b >= Cq/(gb)^2 :  (C0/TEN - a/b) >= Cq/(g b)^2
                if (C0*b-a*TEN)*Cd*g*g*b >= Cn*TEN: break
                p,q=g*a,g*b
                if s==1: n=q-(k+1)//2; m=p-(k+1)//2; ok=True
                else: ok=(q-k-1)%2==0 and (p-k-1)%2==0; n=(q-k-1)//2; m=(p-k-1)//2
                if ok and n>n0 and m>n:
                    cands+=1
                    if v*P(m,k)==u*P(n,k): (sols if m>=n+k else small).append((n,m))
                g+=1
        stack.append((la,lb,a,b)); stack.append((a,b,ra,rb))
    return sols,small,nodes,cands,float(Cq)
if __name__=="__main__":
    import time
    mode=sys.argv[1]
    if mode=="686":
        N=int(sys.argv[2]); k=int(sys.argv[3]); E=int(sys.argv[4]); n0=int(sys.argv[5])
        t=time.time(); s,sm,nd,cd,C=solve(k,N,1,10**E,n0,2*E+60)
        print(f"686 N={N} k={k} X<=10^{E}: solutions(m>=n+k) {s}; overlapping m<n+k {sm}; nodes {nd} cands {cd} Cq {C:.4f} {time.time()-t:.1f}s",flush=True)
