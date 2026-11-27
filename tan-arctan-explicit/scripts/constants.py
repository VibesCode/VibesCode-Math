# Constants for the large-n argument (TanH in Solution.lean): W(n) <= ceil(n/2)log2 + 2n S1(n) + 2 theta(2n) + E(n), c_j <= floor(2n/p^j)+1 via [-n,n] trick.
# S1(n) <= L(n) - L3(X0) + T1,  L3 = sum_{p<=X0, p !=1 mod 4} log p/p,  T1 >= sum_{p=1 mod 4} log p/(p(p-1)) (all p)
# need 2(L3 - T1) > 6 log4 + log2/2 + err(n)
import math, sympy
l2=math.log(2); l4=math.log(4)
T1_true=sum(math.log(p)/(p*(p-1)) for p in sympy.primerange(2,10**6) if p%4==1)
# T1 bound over integers m=1 mod 4 >=5 up to Y, plus tail 2(log Y+1)/Y over all integers m>Y
Y=1000
T1b=sum(math.log(m)/(m*(m-1)) for m in range(5,Y+1,4))+2*(math.log(Y)+1)/Y
print('T1 true',T1_true,'bound',T1b)
L3=0; ps=list(sympy.primerange(2,400001)); i=0
def E(n):
    y=(n*n+1)**(1/3); return y*math.log(n*n+1)
for X0 in [10**4,2*10**4,3*10**4,5*10**4,10**5,2*10**5,4*10**5]:
    L3=sum(math.log(p)/p for p in ps if p<=X0 and p%4!=1)
    n=X0
    err=(l2/2+2+math.log(n)+math.log(1+n*n)+E(n)+l2)/n
    print(X0, 'L3=%.5f'%L3, 'margin 2(L3-T1)-6log4-log2/2-err = %.4f'%(2*(L3-T1b)-6*l4-l2/2-err), 'err=%.4f'%err)
