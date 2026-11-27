# Independent exact reference.
# P_n = prod_{k=1..n} (1 + k i) = A_n + i B_n ; tan(sum arctan k) = B_n / A_n.
# Integer iff A_n != 0 and A_n | B_n.  g = gcd(A,B); tan integer iff A/g = +-1.
# Writes, for each n, g mod q and (A/g) mod q for q = 2^61-1, to compare with the C sieve checker.
import sys, math
N = int(sys.argv[1]); q = 2**61 - 1
A, B = 1, 0
ints, und, minred = [], [], None
with open(f"exact_small_{N}.txt", "w") as f:
    for k in range(1, N+1):
        A, B = A - k*B, B + k*A
        if A == 0:
            und.append(k); continue
        if B % A == 0: ints.append(k)
        g = math.gcd(A, B); r = A // g
        if k >= 5 and (minred is None or abs(r).bit_length() < minred[1]): minred = (k, abs(r).bit_length())
        f.write(f"{k} {g % q} {r % q}\n")
print("integer at n =", ints); print("undefined at n =", und)
print("n>=5 with smallest |A/g| (bits):", minred)
