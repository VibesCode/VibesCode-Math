# Own LMM (Lagarias-Matthews-Mollin, as in Robertson "Solving the generalized Pell equation") for x^2 - D y^2 = N, D non-square >1.
from math import isqrt
def fund(D, rhs):
    # least positive solution of x^2 - D y^2 = rhs (rhs = +-1) via continued fraction of sqrt(D); None if none
    a0=isqrt(D); P,Q,a=0,1,a0; h0,h1=1,a0; k0,k1=0,1
    for _ in range(100000):
        if h1*h1-D*k1*k1==rhs: return h1,k1
        P=a*Q-P; Q=(D-P*P)//Q; a=(a0+P)//Q
        h0,h1=h1,a*h1+h0; k0,k1=k1,a*k1+k0
        if Q==1 and rhs==-1 and (h0*h0-D*k0*k0)==1: return None
    raise RuntimeError
def fund1(D):
    return fund(D,1)
def fundm1(D):
    a0=isqrt(D); P,Q=0,1; per=0
    while True:  # period length of CF of sqrt D
        a=(a0+P)//Q; P=a*Q-P; Q=(D-P*P)//Q; per+=1
        if Q==1: break
    if per%2==0: return None
    return fund(D,-1)
def pqa(P0,Q0,D):
    sD=isqrt(D); A0,A1=0,1; B0,B1=1,0; G0,G1=-P0,Q0; P,Q=P0,Q0; seen=set(); i=0
    while True:
        a=floor_div_sqrt(P,D,Q)
        A0,A1=A1,a*A1+A0; B0,B1=B1,a*B1+B0; G0,G1=G1,a*G1+G0
        Pn=a*Q-P; Qn=(D-Pn*Pn)//Q
        i+=1
        yield i,Pn,Qn,G1,B1  # G_{i-1}, B_{i-1} in Robertson's indexing (Q_i = Qn)
        P,Q=Pn,Qn
def floor_div_sqrt(P,D,Q):
    # floor((P+sqrt(D))/Q), exact, Q != 0
    sD=isqrt(D)
    # x=(P+sqrtD)/Q ; sqrtD irrational in (sD, sD+1)
    if Q>0: return (P+sD)//Q
    # Q<0: x in ((P+sD+1)/Q, (P+sD)/Q), open interval; floor = floor of something slightly less than (P+sD)/Q
    q=-Q; # x = -(P+sqrtD)/q ; floor(-y) = -ceil(y), y=(P+sqrtD)/q in ((P+sD)/q,(P+sD+1)/q)
    # ceil(y): smallest int >= y; since y not integer: = floor(y)+1 = (P+sD)//q + 1
    return -((P+sD)//q + 1)
def classes(D,N):
    """fundamental solutions (one per class mod norm-1 units of Z[sqrt D]) of x^2 - D y^2 = N"""
    t1=fund1(D); tm=fundm1(D); out=[]
    f=1
    while f*f<=abs(N):
        if N%(f*f)==0:
            m=N//(f*f); am=abs(m)
            from sympy.ntheory.residue_ntheory import sqrt_mod
            roots=[0] if am==1 else sorted(set(sqrt_mod(D%am,am,all_roots=True) or []))
            for r in roots:
                z=r if r<=am//2 else r-am      # representative in (-am/2, am/2]
                assert (z*z-D)%am==0
                seen=set(); found=None
                for i,P,Q,G,B in pqa(z,am,D):
                    if Q in (1,-1) :
                        found=(G,B); break
                    if (P,Q) in seen: break
                    seen.add((P,Q))
                if found:
                    G,B=found; r=G*G-D*B*B
                    if r==m: out.append((f*G,f*B))
                    elif r==-m and tm:
                        t,u=tm; out.append((f*(G*t+B*u*D), f*(G*u+B*t)))
        f+=1
    return out,t1
