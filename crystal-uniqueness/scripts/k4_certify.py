# Implementation of ../proofs/k4-chain.md: own LMM classes (lmm.py), mpmath.iv intervals, own Matveev bound and Baker–Davenport reduction, own exact check. Usage: python3 k4_certify.py 5 1000
import sys
from math import isqrt
from mpmath import iv, mp
iv.dps=120; mp.dps=120
from canon_mine import canon
U=lambda x: mp.mpf(x.b); Lo=lambda x: mp.mpf(x.a)
def nvals(k,P):
    a,b=1,k; out=[]
    for _ in range(P):
        c=(k-2)*b-a+2; out.append((2*b-1)*(2*c-1)); a,b=b,c
    return out
def is_chain4(n):
    z=isqrt(n+2)
    if z*z!=n+2: return False
    q=isqrt(2*z+3); return q*q==2*z+3 and q>=5
def exact(k,P):
    return [i+1 for i,n in enumerate(nvals(k,P)) if is_chain4(n)]
def fdist(x):
    n=int(mp.floor(Lo(x)+mp.mpf(1)/2)); d=x-n
    if not U(abs(d))<0.5: raise ValueError
    lo=mp.mpf(0) if Lo(d)<=0<=U(d) else min(abs(Lo(d)),abs(U(d)))
    return lo,U(abs(d))
def wseq(k,imax):
    c=[None,1,None,k-3]; out=[]
    cs={1:1,3:k-3}
    s=3
    while s<2*imax+3: cs[s+2]=(k-2)*cs[s]-cs[s-2]; s+=2
    return {i:4*cs[2*i+3]-k for i in range(1,imax+1)}
def run(k):
    T=(k-4)**3; one=iv.mpf(1)
    sk=iv.sqrt(iv.mpf(k)); rho=(sk+iv.sqrt(iv.mpf(k-4)))/2; lr=iv.log(rho)
    kap=isqrt(k)
    if kap*kap==k:
        wb=(T+1)//(2*kap); i=1
        W=wseq(k,200)
        while W[i]<=wb: i+=1
        P=max(i,60); return ("S",i-1,exact(k,P),P)
    cl=canon(k)
    j=isqrt(k-4); U2=(j*j==k-4)
    from lmm import fund1
    a,b=fund1(k); eta=a+b*sk; le=iv.log(eta)
    # s*: least odd s>=5 with 4rho^s > k sqrt k, 2k sqrtk + T/(4rho^s - k sqrtk) <= 4 rho^s, and x<=1/2
    s=5
    while True:
        r=rho**s
        if Lo(4*r-k*sk)>0 and U(2*k*sk+T/(4*r-k*sk))<=Lo(4*r) and U((2*k*sk+T/(4*r))/(8*r))<=0.5: break
        s+=2
    ss=s; Ck=iv.mpf(U((2*k*sk+T/(4*rho**ss))/4))
    worst=ss
    for (Y,Wc) in cl:
        beta=Y+Wc*sk; lb8=iv.log(beta/8)
        if U2:
            # rho^p = eta^q? find rational p/q = log eta/log rho, verify exactly
            from fractions import Fraction
            fr=Fraction(str(mp.nstr((Lo(le)+U(le))/(Lo(lr)+U(lr)),50))).limit_denominator(1000)
            p,q=fr.numerator,fr.denominator
            # exact check eta^q == rho^p in (x+y sqrt k)/2 arithmetic
            def mul(u,v): return ((u[0]*v[0]+k*u[1]*v[1])//2,(u[0]*v[1]+u[1]*v[0])//2)
            def pw(u,e):
                r=(2,0)
                for _ in range(e): r=mul(r,u)
                return r
            assert pw((2*a,2*b),q)==pw((j,1),p), (k,p,q)
            step=lr/q; t=lb8/step
            n0=int(mp.floor((Lo(t)+U(t))/2))
            cands=[abs(lb8+L*step) for L in (n0-1,n0,n0+1,n0+2)]
            # exclude an L giving exactly 0 only if it is exact; test containment
            lows=[Lo(c) for c in cands]
            if min(lows)<=0:
                # exact test (beta/8)^q == rho^{-L}  <=> beta^q * rho^L == 8^q ; only possible if interval meets 0
                raise RuntimeError(("U2 zero ball",k,Y,Wc))
            d0=min(lows)
            sb=int(mp.ceil(U(iv.log(Ck/d0)/lr)))+1
        else:
            hb=(iv.log(iv.mpf(max(1,U(abs(beta)))))+iv.log(iv.mpf(max(1,U(abs(Y-Wc*sk))))))/2
            A1=max(U(2*le),0.16); A2=max(U(4*(hb+iv.log(8))),U(abs(lb8)),0.16); A3=max(U(2*lr),0.16)
            CM=iv.mpf(14)/10*iv.mpf(30)**6*iv.mpf(3)**(iv.mpf(9)/2)*16*(1+iv.log(4))*A1*A2*A3
            def Mof(S): return (S*lr+iv.log(8)+abs(iv.log(beta)))/le+1
            def ok(S):
                B=iv.mpf(max(S,U(Mof(S))))
                return Lo(S*lr-(CM*(1+iv.log(B))+iv.log(Ck)))>0 and Lo(lr-CM/S)>0 and Lo(lr - CM*(lr/le)/Mof(S))>0
            X=16
            while not ok(X): X*=2
            lo_,hi_=X//2,X
            while hi_-lo_>1:
                m_=(lo_+hi_)//2
                if ok(m_): hi_=m_
                else: lo_=m_
            S0=hi_; M=int(mp.ceil(U(Mof(S0))))+1
            th=le/lr; mu=lb8/lr; A=Ck/lr
            x=(Lo(th)+U(th))/2; q0,q1=1,0; sb=None
            for _ in range(400):
                aa=int(mp.floor(x)); q0,q1=q1,aa*q1+q0
                if q1>6*M:
                    ml,_=fdist(mu*q1); _,tu=fdist(th*q1); e0=ml-M*tu
                    if e0>0: sb=int(mp.ceil(U(iv.log(A*q1/e0)/lr)))+1; break
                x=1/(x-aa)
            if sb is None: return ("U1","NOREDUCE",k,Y,Wc)
        worst=max(worst,sb)
    P=max((worst-3)//2+1,60)
    return ("U2" if U2 else "U1",len(cl),worst,exact(k,P),P)
if __name__=="__main__":
    lo,hi=int(sys.argv[1]),int(sys.argv[2])
    for k in range(lo,hi+1): print(k,run(k),flush=True)
