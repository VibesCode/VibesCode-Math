# Runs box_certify.cert on every pair 5 <= k' < k <= K (default K = 1000) and prints one line per pair,
# in the format of box_certify_1000.log.gz. (The published log was produced the same way, in parallel chunks,
# so its line order differs.) Usage: python3 box_certify_all.py [K]
import sys
from box_certify import cert
K = int(sys.argv[1]) if len(sys.argv) > 1 else 1000
for k in range(6, K + 1):
    for kp in range(5, k):
        print(k, kp, cert(k, kp), flush=True)
