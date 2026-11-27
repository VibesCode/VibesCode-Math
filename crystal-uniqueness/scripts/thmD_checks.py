# Numerical checks for Theorem D (same-field chains never collide). mpmath, high precision (not interval arithmetic).
from mpmath import mp, mpf, sqrt
mp.dps=2500
def eta(T): return (T+sqrt(T*T-4))/2
def chain(k,tmax):
    xs=[1,k]
    while len(xs)<tmax+3: xs.append((k-2)*xs[-1]-xs[-2]+2)
    return xs
# (1) closed form x_t(E) = E^{-t}((E^{t+1}-1)/(E-1))^2 equals the integer chain, and bracket
#     M_t(1-delta_t) < F_t < M_t with M_t=4E^{2t+1}(1-1/E)^{-4}, delta_t=(1+1/E)^3/(2E^t)
worst=0; fails=0
for T in range(3,60):
    L=[2,T]
    for r in range(1,8):
        while len(L)<=r: L.append(T*L[-1]-L[-2])
        k=L[r]+2; E=eta(T)**r
        assert abs((E+1/E+2)-k)<mpf(10)**-60
        xs=chain(k,12)
        for t in range(0,12):
            xc=E**(-t)*((E**(t+1)-1)/(E-1))**2
            if abs(xc-xs[t])>mpf(10)**-40*xs[t]: fails+=1
        for t in range(1,11):
            F=(2*xs[t]-1)*(2*xs[t+1]-1)
            M=4*E**(2*t+1)*(1-1/E)**-4; d=(1+1/E)**3/(2*E**t)
            if not (M*(1-d)<F<M): fails+=1
            worst=max(worst,(M-F)/M/d)
print("closed form + bracket failures:",fails," max (M-F)/(M*delta) =",float(worst))
# (2) case inequalities at the smallest fields (they are monotone in eta beyond, checked on T<=60)
ok=True
for T in range(3,61):
    h=eta(T)
    dmax=lambda i,E:(1+1/E)**3/(2*E**i)
    # Case A>B: eta > 1/(1-delta_1(eta))
    ok&= h>1/(1-dmax(1,h))
    # Case A=B (i>=2, x=E1^{-1}<=1/eta): ((1-x/eta)/(1-x))^4 > 1/(1-delta_2) on grid
    for m in range(1,200):
        x=mpf(m)/200/h; E1=1/x
        ok&= ((1-x/h)/(1-x))**4 > 1/(1-dmax(2,E1))
    # r>=2, B-A>=1 (s>=3, j>=1): (1-eta^-2)^-4/eta < 1-delta_1(eta^3)
    ok&= (1-h**-2)**-4/h < 1-dmax(1,h**3)
    # r=1, B-A>=2 (s>=2): eta^-2 (1-1/eta)^-4 (1-eta^-2)^4 < 1-delta_1(eta^2)  [worst s=2]
    for s in range(2,8):
        ok&= h**-2*(1-1/h)**-4*(1-h**-s)**4 < 1-dmax(1,h**s)
    # r=1, B-A=1, i>=2
    for s in range(2,8):
        R=h**-1*((1-h**-s)/(1-1/h))**4
        ok&= (R>1/(1-dmax(2,h))) or (R<1-dmax(1,h**s))
print("case inequalities hold for T=3..60:",ok)
