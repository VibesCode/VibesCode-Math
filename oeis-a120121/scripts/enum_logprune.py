# Exhaustive search over digit multisets ("9s plus a few smaller digits"), floating log prune with slack; tests m == F(P(m), S(m)) directly.
# A term m with k digits satisfies 10^(k-1) <= m = F <= P*S <= 9^k*9k, impossible for k >= 100. For k < 100 enumerate digit
# multisets as "9s plus a few smaller digits" whose log-deficit from 9^k keeps P*S >= 10^(k-1), compute m = F(P,S) and test
# self-consistency m == F(P(m), S(m)) and len(m) == k. Digit 0 gives P = 0, F = 0 (phi(0) = 0 convention), never a positive term.
import math
from functools import lru_cache
def factor(n):
    f={}; d=2
    while d*d<=n:
        while n%d==0: f[d]=f.get(d,0)+1; n//=d
        d+=1
    if n>1: f[n]=f.get(n,0)+1
    return f
def phi_f(f):
    r=1
    for p,e in f.items():
        if e>0: r*=(p-1)*p**(e-1)
    return r
def mul(f,g):
    h=dict(f)
    for p,e in g.items(): h[p]=h.get(p,0)+e
    return h
DF={d:factor(d) for d in range(2,10)}
FS={
 'A120121': lambda Pf,P,S: phi_f(mul(Pf,factor(S))),
 'A120122': lambda Pf,P,S: phi_f(Pf)*S,
 'A120123': lambda Pf,P,S: P*phi_f(factor(S)),
}
def digits_PS(m):
    s=str(m); P=1
    for ch in s: P*=int(ch)
    return P, sum(map(int,s)), len(s)
found={k:set() for k in FS}
cnt=0
for k in range(1,100):
    lo=k-1-math.log10(9*k)            # need log10 P >= lo
    # recursive over digits 8..1: choose counts; remaining are 9s
    def rec(d, left, logP, Pf, S):
        global cnt
        if d==0:
            # remaining 'left' digits are 9
            lp=logP+left*math.log10(9)
            if lp<lo-1e-9: return
            Pf2=dict(Pf); Pf2[3]=Pf2.get(3,0)+2*left
            P=1
            for p,e in Pf2.items(): P*=p**e
            S2=S+9*left; cnt+=1
            for name,F in FS.items():
                m=F(Pf2,P,S2)
                if m>0 and len(str(m))==k:
                    Pm,Sm,_=digits_PS(m)
                    if Pm>0 and F(factor(Pm) if Pm>1 else {},Pm,Sm)==m: found[name].add(m)
            return
        c=0
        while c<=left:
            lp_best=logP+c*math.log10(d)+(left-c)*math.log10(9)
            if lp_best<lo-1e-9: break
            Pf2=Pf
            if d>1:
                Pf2=dict(Pf)
                for p,e in DF[d].items(): Pf2[p]=Pf2.get(p,0)+e*c
            rec(d-1,left-c,logP+c*math.log10(d),Pf2,S+d*c)
            c+=1
    rec(8,k,0.0,{},0)
for name in FS: print(name, sorted(found[name]))
print("multisets examined:",cnt)
