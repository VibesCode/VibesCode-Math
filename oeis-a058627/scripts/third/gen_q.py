# all primes q>7 with q-1 7-smooth, q-1 <= LIM ; output exponents of q-1
import gmpy2, sys
LIM=9**36*10
out=[]
p2=1
a=0
while p2<=LIM:
    p3=p2;b=0
    while p3<=LIM:
        p5=p3;c=0
        while p5<=LIM:
            p7=p5;d=0
            while p7<=LIM:
                q=p7+1
                if q>7 and gmpy2.is_prime(q,30): out.append((q,a,b,c,d))
                p7*=7;d+=1
            p5*=5;c+=1
        p3*=3;b+=1
    p2*=2;a+=1
out.sort()
with open("q.txt","w") as f:
    for q,a,b,c,d in out: f.write(f"{a} {b} {c} {d}\n")
print(len(out))
