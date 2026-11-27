# Implementation 1 of ../proofs/k4-chain.md: chain 4 vs chains 5<=k<=K.  PARI (bnfcertify) for the norm classes,
# mpmath interval arithmetic for every real inequality, exact integers for the final check.
import sys, math
import cypari2
from mpmath import iv, mp
pari=cypari2.Pari(); pari.allocatemem(2*10**9, silent=True) if hasattr(pari,'allocatemem') else None
iv.dps=int(__import__("os").environ.get("DPS","80")); mp.dps=iv.dps
def hi(x): return mp.mpf(x.b)
def lo(x): return mp.mpf(x.a)
def mid(x): return (lo(x)+hi(x))/2
def dist_int(x):
    n=int(mp.nint(mid(x))); up=hi(abs(x-n))
    low=min(lo(abs(x-n)),lo(abs(x-(n-1))),lo(abs(x-(n+1))))
    return iv.mpf([low,up])
def cf_q(x):
    p0,p1,q0,q1=0,1,1,0
    for _ in range(300):
        a=int(mp.floor(x)); q0,q1=q1,a*q1+q0; yield q1
        x=1/(x-a)
def is_k4_value(n):
    z=math.isqrt(n+2)
    if z*z!=n+2: return False
    t=2*z+3; r=math.isqrt(t)
    return r*r==t and r>=5
def nvals(k,imax):
    x0,x1=1,k; out=[]
    for i in range(1,imax+1):
        x2=(k-2)*x1-x0+2; out.append((2*x1-1)*(2*x2-1)); x0,x1=x1,x2
    return out
def wvals(k,imax):
    c=[1,k-3]
    while len(c)<imax+2: c.append((k-2)*c[-1]-c[-2])
    return [4*c[i+1]-k for i in range(1,imax+1)]
def exact(k,imax):
    return sum(is_k4_value(n) for n in nvals(k,imax))
def isq(m): r=math.isqrt(m); return r*r==m
def matveev(A):  # n=3, D=4, real
    return iv.mpf('1.4')*iv.mpf(30)**6*iv.mpf(3)**iv.mpf('4.5')*16*(1+iv.log(4))*A[0]*A[1]*A[2]
from fractions import Fraction as Fr
def gp_pairs(expr):
    v=pari(expr); out=[]
    for e in v:
        e=pari.lift(e)
        out.append((Fr(str(pari.polcoef(e,0))),Fr(str(pari.polcoef(e,1)))))
    return out
def qmul(u,v,k): return (u[0]*v[0]+k*u[1]*v[1], u[0]*v[1]+u[1]*v[0])
def classes(k,T):
    cert=pari('bnf=bnfinit(x^2-%d,1); bnfcertify(bnf)'%k)
    if cert!=1: raise RuntimeError("bnfcertify failed %d"%k)
    fu=gp_pairs('[lift(bnf.fu[1])]')[0]
    sols=gp_pairs('bnfisintnorm(bnf,%d)'%(-T))
    nfu=fu[0]**2-k*fu[1]**2
    e1=fu if nfu==1 else qmul(fu,fu,k)
    assert e1[0]**2-k*e1[1]**2==1
    e=1; p=e1
    while not (p[0].denominator==1 and p[1].denominator==1): p=qmul(p,e1,k); e+=1
    a,b=int(p[0]),int(p[1]); a,b=abs(a),abs(b)   # eta = a+b sqrt k > 1 (norm 1)
    B=[]
    for g in sols:
        pw=g
        for j in range(e):
            if pw[0].denominator==1 and pw[1].denominator==1:
                for sg in (1,-1):
                    y,w=sg*int(pw[0]),sg*int(pw[1])
                    if lo(y+w*iv.sqrt(k))>0: B.append((y,w))
            pw=qmul(pw,e1,k)
    for (y,w) in B: assert y*y-k*w*w==-T
    return (a,b),B,fu
def handle(k):
    T=(k-4)**3
    if isq(k):
        kap=math.isqrt(k); wmax=(T+1)//(2*kap); ws=wvals(k,200); imax=max(i+1 for i,w in enumerate(ws) if w<=wmax) if ws[0]<=wmax else 1
        return ("square",imax,exact(k,imax+2))
    sk=iv.sqrt(k); rho=(sk+iv.sqrt(k-4))/2; lr=iv.log(rho)
    eta,B,fu0=classes(k,T); et=eta[0]+eta[1]*sk; le=iv.log(et)
    # s*: smallest odd s>=5 with x := (2k sqrt k + T/(4 rho^s))/(8 rho^s) <= 1/2 and 8 rho^{-s}<1  (alpha>=4rho^s then holds)
    s=5
    def okS(s):
        r=rho**s
        if not lo(4*r-k*sk)>0: return False
        return hi((2*k*sk+T/(4*r))/(8*r))<=0.5 and hi(8/r)<1 and hi(2*k*sk+T/(4*r-k*sk))<=lo(4*r)
    while not okS(s): s+=2
    sstar=s
    Ck=iv.mpf(hi((2*k*sk+T/(4*rho**sstar))/4))
    j2=k-4; U2=isq(j2)
    Smax=sstar
    for (y,w) in B:
        beta=y+w*sk; betac=y-w*sk; lb8=iv.log(beta/8)
        if not U2:
            hb=(iv.log(max(hi(abs(beta)),1))+iv.log(max(hi(abs(betac)),1)))/2
            A=[max(hi(4*le/2),hi(abs(le)),0.16), max(hi(4*(hb+iv.log(8))),hi(abs(lb8)),0.16), max(hi(4*lr/2),hi(abs(lr)),0.16)]
            CM=matveev(A)
            # B = max(|m|,s); |m| <= (s lr + |lb8| + 1)/le <= s + c ; use B <= s*(1+lr/le)+|lb8|/le+1 conservatively
            sb=iv.mpf(10)
            for _ in range(100):
                Bb=sb*(1+lr/le)+abs(lb8)/le+1
                sb=iv.mpf(hi((CM*(1+iv.log(Bb))+iv.log(2*Ck))/lr))
            S0=int(math.ceil(hi(sb)))+1
            M=int(math.ceil(hi((S0*lr+abs(lb8)+1)/le)))+1
            th=le/lr; mu=lb8/lr; A_=Ck/lr; found=False
            for q in cf_q(mid(th)):
                if q>6*M:
                    e0=dist_int(mu*q)-M*dist_int(th*q)
                    if lo(e0)>0: found=True; break
            if not found: return ("reduction_failed",y,w)
            S1=int(math.ceil(hi(iv.log(A_*q/lo(e0))/lr)))
        else:
            # rho, eta units of Q(sqrt k): find the integer combination; compute delta0 over L with |L le0 + lb8| < 1
            # use log eps0 := gcd-like generator: work directly with the 2-generator lattice m*le - s*lr; s odd, m any.
            # Lambda = m le + lb8 - s lr; with le = a g, lr = b g (g = log of a fundamental unit) -> Lambda = L g + lb8.
            g=abs(iv.log(abs(iv.mpf(str(fu0[0]))+iv.mpf(str(fu0[1]))*sk)))
            best=None
            Lc=int(mp.nint(mid(-lb8/g)))
            for L in range(Lc-3,Lc+4):
                v=abs(L*g+lb8)
                if best is None or hi(v)<best[0]: best=(hi(v),L,v)
            # all L: |Lambda| >= min over L ; if min interval contains 0 then beta/8 is a unit power: take next-best L excluded? Lambda<0 strict
            vals=sorted([(hi(abs(L*g+lb8)),lo(abs(L*g+lb8)),L) for L in range(Lc-3,Lc+4)])
            d0=vals[0][1]
            if not d0>0: d0=vals[1][1]   # Lambda=0 impossible (Lambda<0), so the exact zero L is excluded
            S1=int(math.ceil(hi(iv.log(Ck/d0)/lr)))
        Smax=max(Smax,S1)
    imax=max(1,(Smax-3)//2+1)
    return ("U2" if U2 else "U1",len(B),imax,exact(k,imax+1))
if __name__=="__main__":
    lo_k,hi_k=int(sys.argv[1]),int(sys.argv[2])
    for k in range(lo_k,hi_k+1):
        try: r=handle(k)
        except Exception as ex: r=("ERROR",repr(ex)[:120])
        print(k,*r,flush=True)
