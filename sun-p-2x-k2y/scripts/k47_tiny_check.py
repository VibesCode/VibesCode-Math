# Standalone: checks N is not p + 2^x + 47*2^y (p odd prime, x,y >= 1). Needs sympy.
import sys
from sympy import isprime
for N in map(int, sys.argv[1:] or ["22537515","50574615","67612545"]):
    reps=[(x,y) for y in range(1,N.bit_length()) for x in range(1,N.bit_length())
          if N-2**x-47*2**y>2 and isprime(N-2**x-47*2**y)]
    print(N, "NOT representable" if not reps else f"representable e.g. {reps[0]}")
