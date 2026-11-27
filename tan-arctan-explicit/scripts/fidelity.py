# Fidelity check for statement.lean: exact Gaussian-integer products, exact rational comparisons.
from fractions import Fraction
A,B=1,0
rows=[];E=[];ints=[]
for n in range(1,2001):
    A,B=A*1-B*n, A*n+B*1          # (A+Bi)(1+ni)
    integer = (A!=0 and B%A==0) or (A==0 and B==0)
    exc = n>=5 and (A==0 or abs(Fraction(B,A))>Fraction(n,2)+1)
    if exc: E.append(n)
    if integer: ints.append(n)
    if n<=6: rows.append((n,A,B))
print("first products (n,A,B):",rows)
print("n<=2000 with A_n | B_n:",ints)
print("E ∩ [5,2000]:",E)
assert ints==[1,2,3,4]
assert E[:8]==[15,17,80,82,395,397,1904,1906]
# statement for n in [5,2000]: n not in E -> not integer  (holds trivially here: no integers at all)
assert all(not(n>=5 and n not in E and n in ints) for n in range(5,2001))
# sharpness: with 5 replaced by 4 the statement fails at n=4 (x_4 = 4 is an integer, 4 is not in E)
assert 4 in ints and 4 not in E
print("FIDELITY OK")
