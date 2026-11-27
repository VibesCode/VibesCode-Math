import sympy as sp
from sympy import Rational as R
k,x=sp.symbols('k x')
def n(t,kk):
    a,b=sp.Integer(1),kk
    for _ in range(t-1): a,b=b,sp.expand((kk-2)*b-a+2)
    c=sp.expand((kk-2)*b-a+2); return sp.expand((2*b-1)*(2*c-1))
n1,n4=n(1,k),n(4,x)
assert sp.expand(n1-(2*k-1)*(2*(k-1)**2-1))==0
H=x**3-R(14,3)*x**2+R(47,9)*x+R(19,162)
assert all(c.q in (1,2,3,6,9,18,27,54,81,162) for c in sp.Poly(H,x).coeffs())
up=sp.Poly(sp.expand(n1.subs(k,H+R(1,162))-n4),x); dn=sp.Poly(sp.expand(n4-n1.subs(k,H-R(1,162))),x)
print("deg/LC",up.degree(),up.LC(),dn.degree(),dn.LC())
X0=max(max([r for r in sp.real_roots(up)]+[0]),max([r for r in sp.real_roots(dn)]+[0]))
print("largest real roots ->",sp.N(X0))
# n1 increasing in real k>=2: derivative
d=sp.Poly(sp.diff(n1,k),k); print("n1' real roots",[sp.N(r) for r in sp.real_roots(d)])
g=sp.Poly(sp.expand(162**9*(n1.subs(k,H)-n4)),x); print("g integer roots",[r for r in sp.real_roots(g) if r.is_integer])
# brute: for kp in 3..200000, is n4(kp) = n1(kk) for an integer kk?
import math
def n1i(m): return (2*m-1)*(2*(m-1)**2-1)
def n4i(kp):
    a,b=1,kp
    for _ in range(3): a,b=b,(kp-2)*b-a+2
    c=(kp-2)*b-a+2; return (2*b-1)*(2*c-1)
hits=[]
for kp in range(4,200001):
    v=n4i(kp); m=int(round((v/4)**(1/3)))
    lo,hi=max(2,m-10**6//1000-50), m+50
    # exact bisection
    lo,hi=2,2*m+10
    while lo<hi:
        mid=(lo+hi)//2
        if n1i(mid)<v: lo=mid+1
        else: hi=mid
    if n1i(lo)==v: hits.append((kp,lo))
print("brute hits k'<=200000:",hits)
