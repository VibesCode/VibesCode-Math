# SECOND, independent program for the 686 / 677 bounds.
# Different method: Stern-Brocot tree walk with exact rational pruning (no continued fractions, no Worley theorem),
# a looser constant (drops the -1/c^2 term), a two-pointer brute force for small X (no ratio band),
# and, for 677, the gap R(n) computed from the counting formula, not from lcm.
import sys, time
from fractions import Fraction as Fr
from decimal import Decimal, getcontext
def prodk(t,k):
    r=1
    for i in range(1,k+1): r*=t+i
    return r
def c_upper(u,v,k):
    getcontext().prec=60
    x=(Decimal(u)/Decimal(v))**(Decimal(1)/Decimal(k))
    return Fr(str(x))+Fr(1,10**40)
def const(u,v,k,X0):
    cu=c_upper(u,v,k); h=Fr(k-1,2)
    S2=sum(Fr(2*i-(k-1),2)**2 for i in range(k))
    B=cu*S2/(2*k)/(1-h*h/(X0*X0))          # looser than first program's constant
    s=1 if k%2 else 2
    return s, B*s*s
def brute(u,v,k,X0):
    out=[]; m=k
    nmax=int(X0)  # covers X<=X0
    for n in range(0,nmax+1):
        T=u*prodk(n,k)
        if m<n+k: m=n+k
        while v*prodk(m,k)<T: m+=1
        if v*prodk(m,k)==T: out.append((n,m))
    return out
def less_c(p,q,u,v,k):   # p/q < c  <=>  p^k v < u q^k
    return p**k*v < u*q**k
def walk(u,v,k,X0,qmax):
    s,C=const(u,v,k,X0)
    sols=[]; nodes=0
    stack=[(0,1,1,0)]  # l=a/b, r=a2/b2
    while stack:
        a,b,a2,b2=stack.pop()
        p,q=a+a2,b+b2
        if q>qmax: continue
        nodes+=1
        # prune subtree: need l<c and r > c - C/q^2
        if not less_c(a,b,u,v,k) : continue
        if b2>0:
            rr=Fr(a2,b2)+C/(q*q)
            if not (rr.numerator**k*v > u*rr.denominator**k): continue
        # candidate p/q itself and its multiples
        if less_c(p,q,u,v,k):
            g=1
            while g*q<=qmax:
                y=Fr(p,q)+C/(g*q)**2
                if not (y.numerator**k*v > u*y.denominator**k): break
                P_,Q_=p*g,q*g
                if s==1: n=Q_-(k+1)//2; m=P_-(k+1)//2; okp=True
                else:
                    okp=(Q_-(k+1))%2==0 and (P_-(k+1))%2==0; n=(Q_-(k+1))//2; m=(P_-(k+1))//2
                if okp and n>=0 and m>=n+k and Fr(2*n+k+1,2)>X0 and v*prodk(m,k)==u*prodk(n,k): sols.append((n,m))
                g+=1
        stack.append((a,b,p,q)); stack.append((p,q,a2,b2))
    return sols,nodes
def Rcount(n,k):
    # R(n) = prod over prime powers p^j < k of p^{max(cnt_j - 1, 0)}, cnt_j = #multiples of p^j in n+1..n+k
    r=1
    for p in range(2,k):
        if any(p%d==0 for d in range(2,p)): continue
        pj=p
        while pj<k:
            cnt=(n+k)//pj-n//pj
            if cnt>1: r*=p**(cnt-1)
            pj*=p
    return r
