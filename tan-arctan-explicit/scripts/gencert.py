import sympy, math
Y=20000
l=[]
for p in sympy.primerange(2,Y+1):
    if p%4!=1:
        k=(p**16).bit_length()-1  # 2^k <= p^16
        assert 2**k<=p**16<2**(k+1)
        a=(k*10**9)//(16*p)
        l.append((p,k,a))
A=sum(a for _,_,a in l)
Y0=1000
u=[]
for x in range(5,Y0+1,4):
    k1=(x**16).bit_length()  # x^16 < 2^k1
    assert x**16<2**k1
    b=-((-k1*10**9)//(16*x*(x-1)))  # ceil
    u.append((x,k1,b))
B=sum(b for _,_,b in u)
l2=math.log(2)
print(len(l),'L3 terms; A=',A,' L3 lower =',l2*A/1e9)
print(len(u),'T1 terms; B=',B,' finite upper =',l2*B/1e9)
tail=2*(10*l2+1)/1000
print('margin coefficient =', l2*(2*(A-B)/1e9-12.5)-2*tail)
open('cert_data.txt','w').write(repr((l,u,A,B)))
