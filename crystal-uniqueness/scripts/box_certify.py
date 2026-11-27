# Independent implementation of proofs/box.md: mpmath.iv interval arithmetic; certified J0 bisection, own continued fractions and nearest-integer logic.
import sys, random, math
from mpmath import iv, mp
iv.dps=80; mp.dps=80
def sqfp(m):
    r=1;p=2
    while p*p<=m:
        e=0
        while m%p==0: m//=p;e+=1
        if e%2: r*=p
        p+=1
    return r*m
U=lambda x: mp.mpf(x.b); Lo=lambda x: mp.mpf(x.a)
def frac_dist(x):  # interval x narrow; returns (lower bound, upper bound) of ||x||
    n=int(mp.floor(Lo(x)+mp.mpf(1)/2))
    d=x-n
    if not (U(abs(d))<mp.mpf(1)/2): raise ValueError("wide")
    lo = mp.mpf(0) if (Lo(d)<=0<=U(d)) else min(abs(Lo(d)),abs(U(d)))
    return lo, U(abs(d))
def vals_pos(k,P):
    a,b=1,k;out=[]
    for t in range(P):
        c=(k-2)*b-a+2; out.append((2*b-1)*(2*c-1)); a,b=b,c
    return out
def vals_upto(k,top):
    a,b=1,k;out=set()
    while True:
        c=(k-2)*b-a+2; n=(2*b-1)*(2*c-1)
        if n>top: return out
        out.add(n); a,b=b,c
def cert(k,kp,deep=100):
    assert k>kp>=5
    if sqfp(k*k-4*k)==sqfp(kp*kp-4*kp): return "samefield"
    one=iv.mpf(1)
    e=(iv.mpf(k-2)+iv.sqrt(iv.mpf(k*k-4*k)))/2; f=(iv.mpf(kp-2)+iv.sqrt(iv.mpf(kp*kp-4*kp)))/2
    le,lf=iv.log(e),iv.log(f); g=((one-1/f)/(one-1/e))**4; lg=iv.log(g)
    # j*: least j>=5 with delta_j(f)<=1/2 and (1+1/e)^3/2*sqrt(e)*f^(-j-1/2)/(0.7(1-1/e)^2)<=1/2
    c2=(one+1/e)**3/2*iv.sqrt(e)/(iv.mpf(7)/10*(one-1/e)**2)
    js=5
    while not (U((one+1/f)**3/(2*f**js))<=0.5 and U(c2*f**(-js-one/2))<=0.5): js+=1
    C0=2*iv.mpf(max(U((one+1/f)**3/2), U(c2/iv.sqrt(f))))
    A1=max(U(4*le/2),U(le),0.16); A2=max(U(4*lf/2),U(lf),0.16)
    hg=4*(le/2+lf/2+2*iv.log(2)); A3=max(U(4*hg),U(abs(lg)),0.16)
    CM=iv.mpf(14)/10*iv.mpf(30)**6*iv.mpf(3)**(iv.mpf(9)/2)*16*(1+iv.log(4))*A1*A2*A3
    # collision with j>=js: j*lf < CM(1+log(2j+1)) + log(2C0). find X with phi(X)=X*lf - RHS >0 and phi increasing beyond X
    def phi_pos(X): return Lo(X*lf-(CM*(1+iv.log(2*X+1))+iv.log(2*C0)))>0 and Lo(lf-2*CM/(2*X+1))>0
    X=10
    while not phi_pos(X): X*=2
    lo_,hi_=X//2,X   # bisect smallest certified X
    while hi_-lo_>1:
        m=(lo_+hi_)//2
        if phi_pos(m): hi_=m
        else: lo_=m
    J0=hi_          # any collision with j>=js has j<J0
    M=2*J0          # i<j<J0 so 2i+1<=2J0-3 < M
    th=le/lf; mu=lg/lf; A=C0/lf
    # continued fraction of midpoint of th
    x=(Lo(th)+U(th))/2; h0,h1,q0,q1=0,1,1,0
    for _ in range(300):
        a=int(mp.floor(x)); q0,q1=q1,a*q1+q0
        if q1>6*M:
            try:
                mlo,_=frac_dist(mu*q1); _,thu=frac_dist(th*q1)
            except ValueError: return "precision"
            e0=mlo-M*thu
            if e0>0:
                J1=int(mp.ceil(U(iv.log(A*q1/e0)/lf)))
                break
        x=1/(x-a)
    else: return "noreduce"
    P=max(J1,js,deep)+1
    vp=vals_pos(kp,P); vk=vals_upto(k,vp[-1])
    return ("ok",J0,J1,js,len(vk & set(vp)))
if __name__=="__main__":
    random.seed(int(sys.argv[1]))
    pairs=[(6,5),(7,5),(7,6),(1000,5),(1000,999),(999,998),(1000,500),(39853,577)]
    while len(pairs)<int(sys.argv[2]):
        k=random.randint(6,1000); kp=random.randint(5,k-1); pairs.append((k,kp))
    for k,kp in pairs: print(k,kp,cert(k,kp),flush=True)
