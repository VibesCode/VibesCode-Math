# Polynomial regime for a divisible position pair (i,j)=(1,4): deg n_1 = 3 divides deg n_4 = 9.
# Branch at infinity: k = H(k') + c/k' + ..., H a cubic with rational coefficients.
import sympy as sp
K,x=sp.symbols('K x')
def nt(t,k):
    xs=[sp.Integer(1),k]
    for _ in range(t+1): xs.append(sp.expand((k-2)*xs[-1]-xs[-2]+2))
    return sp.expand((2*xs[t]-1)*(2*xs[t+1]-1))
n1=nt(1,K); n4=nt(4,K)
# k = x^3 + a2 x^2 + a1 x + a0 + b/x + c/x^2   (x = k')
a=sp.symbols('a0:6')
kser=x**3+a[2]*x**2+a[1]*x+a[0]+a[3]/x+a[4]/x**2
expr=sp.expand(n1.subs(K,kser)-n4.subs(K,x))
sol={}
for deg in range(8,0-2,-1):
    c=sp.expand(expr.coeff(x,deg+0)) if True else 0
    c=sp.simplify(expr.subs(sol).as_poly(x,1/x) if False else 0)
# simpler: solve top coefficients in order
e=sp.expand(sp.series(n1.subs(K,kser)-n4.subs(K,x),x,sp.oo,12).removeO()) if False else expr
coeffs=[]
order=[(8,a[2]),(7,a[1]),(6,a[0]),(5,a[3]),(4,a[4])]
for d,v in order:
    cd=sp.expand(e.subs(sol)).coeff(x,d)
    s=sp.solve(cd,v); sol[v]=s[0]
print("H(k') = k'^3 +",sol[a[2]],"k'^2 +",sol[a[1]],"k' +",sol[a[0]]," ; next term",sol[a[3]],"/k'")
H=x**3+sol[a[2]]*x**2+sol[a[1]]*x+sol[a[0]]
g=sp.expand(n1.subs(K,H)-n4.subs(K,x))
print("n_1(H(k')) - n_4(k') =",sp.factor(g))

# Rigorous closure of the pair (1,4): for x >= X0, n_1(H-1/162) < n_4(x) < n_1(H+1/162); n_1 increasing for k>=2;
# 162*H(x) is an integer, so 162k - 162H(x) is an integer in (-1,1): k = H(x), impossible unless g(x)=0.
up=sp.Poly(sp.expand(n1.subs(K,H+sp.Rational(1,162))-n4.subs(K,x)),x)
dn=sp.Poly(sp.expand(n4.subs(K,x)-n1.subs(K,H-sp.Rational(1,162))),x)
print("162H integer poly:",sp.Poly(162*H,x).all_coeffs())
def last_bad(P):  # largest integer x>=1 where P(x)<=0 (P has positive leading coeff)
    rts=[r for r in sp.real_roots(P)]
    return int(sp.floor(max(rts))) if rts else 0
X0=max(last_bad(up),last_bad(dn),last_bad(sp.Poly(g,x)) if False else 0)+1
print("upper/lower leading coeffs:",up.LC(),dn.LC(),"X0 =",X0)
print("integer roots of g:",[r for r in sp.Poly(g,x).ground_roots()])
# exact check below X0: all k' in [5, X0) (and 3, 4) : does n_4(k') equal some n_1(k)?
def is_n1(v):
    lo,hi=2,10**30
    while lo<hi:
        m=(lo+hi)//2
        if (2*m-1)*(2*(m-1)**2-1)<v: lo=m+1
        else: hi=m
    return (2*lo-1)*(2*(lo-1)**2-1)==v, lo
f4=sp.lambdify(K,n4)
hits=[(kp,is_n1(int(n4.subs(K,kp)))) for kp in range(3,X0+1)]
print("k' < X0 with n_4(k') a position-1 value:",[h for h in hits if h[1][0]])
