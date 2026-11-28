# Solve P_k(m)*v = u*P_k(n), P_k(t)=(t+1)...(t+k), m>=n+k, n>=0, for target ratio rho=u/v>1.
# Part 1 (small X): band search. Part 2 (X>X0): continued fractions of c=rho^(1/k) + Worley/Dujella theorem.
# Centered: X=n+(k+1)/2, M=m+(k+1)/2.  Proven inequality (see notes): 0 < c - M/X < B/X^2 for X>X0,
#   B = c*S2/(2k) * (1/(1-h^2/X0^2) - 1/c^2), S2=sum j^2 over the k symmetric offsets, h=(k-1)/2.
from fractions import Fraction as F
from math import gcd, isqrt, prod
def iroot(a,k):
    if a<2: return a
    x=1<<((a.bit_length()+k-1)//k)
    while True:
        y=((k-1)*x+a//x**(k-1))//k
        if y>=x: break
        x=y
    while x**k>a: x-=1
    while (x+1)**k<=a: x+=1
    return x
def P(t,k): return prod(range(t+1,t+k+1))
def band(u,v,k,n0):
    c=(u/v)**(1.0/k); sols=[]
    for n in range(0,n0+1):
        lo=max(n+k,int(c*(n+1)-1)-2); hi=int(c*(n+k)-k)+3
        pn=u*P(n,k)
        for m in range(lo,hi+1):
            if v*P(m,k)==pn: sols.append((n,m))
    return sols
def cf(a,b):
    out=[]
    while b:
        q=a//b; out.append(q); a,b=b,a-q*b
    return out
def constants(u,v,k,X0):
    c=(u/v)**(1.0/k); S2=sum(((2*i-(k-1))/2)**2 for i in range(k)); h=(k-1)/2
    B=c*S2/(2*k)*(1/(1-h*h/X0**2)-1/c**2)
    return c,B*1.000001+1e-12
def cf_search(u,v,k,X0,digits):
    """all solutions with X0 < X and q-scale up to 10^digits"""
    s=1 if k%2 else 2           # p=sM, q=sX integers
    c,B=constants(u,v,k,X0); C=s*s*B
    Q=10**(2*digits+20)
    L=iroot(u*Q**k//v,k)
    if L**k*v==u*Q**k:          # c rational: c-M/X>0 integer argument => X <= C*denominator; covered by band if X0 large
        g=F(L,Q); return None,('rational',g)
    a1=cf(L,Q); a2=cf(L+1,Q); t=0
    while t<min(len(a1),len(a2)) and a1[t]==a2[t]: t+=1
    A=a1[:max(t-1,1)]
    p=[1,A[0]]; q=[0,1]
    for x in A[1:]:
        p.append(x*p[-1]+p[-2]); q.append(x*q[-1]+q[-2])
    qmax=10**digits
    # need all indices m with q_{m-1} <= qmax (descent argument); check we have enough
    J=next(j for j in range(len(q)) if q[j]>qmax)
    stopq=2*(int(2*C)+2)*q[J]   # coverage: Worley index m needs q_{m+1} <= 2(r+s) q_J (best-approximation bound)
    assert q[-1]>stopq, "precision too low"
    lo=F(L,Q); hi=F(L+1,Q)
    rs=[(1,0),(0,1)]+[(r,t2) for r in range(1,int(2*C)+2) for t2 in range(1,int(2*C)+2) if r*t2<2*C]
    seen=set(); sols=[]; ncand=0
    for i in range(len(p)-1):
        if q[i]>stopq: break
        for r,t2 in rs:
            for sg in (1,-1):
                a=r*p[i+1]+sg*t2*p[i]; b=r*q[i+1]+sg*t2*q[i]
                if b<0: a,b=-a,-b
                if b==0: continue
                g=gcd(a,b); a//=g; b//=g
                if (a,b) in seen or b>qmax: continue
                seen.add((a,b))
                fr=F(a,b)
                if not (fr<hi and lo-fr<F(C)/b/b): continue
                ncand+=1
                d=lo-fr
                gmax= (isqrt(int(F(C)/(d*b*b)))+1) if d>0 else qmax//b
                for gg in range(1,min(gmax,qmax//b)+1):
                    pp,qq=a*gg,b*gg
                    if (pp-(k+1))%s or (qq-(k+1))%s: continue
                    if s==1: M,X=pp,qq; n=X-(k+1)//2; m=M-(k+1)//2
                    else: n=(qq-(k+1))//2; m=(pp-(k+1))//2
                    if n<0 or m<n+k: continue
                    Xr=F(2*n+k+1,2)
                    if Xr<=X0: continue
                    if v*P(m,k)==u*P(n,k): sols.append((n,m))
    return sorted(set(sols)),('cands',ncand,'C',C)
