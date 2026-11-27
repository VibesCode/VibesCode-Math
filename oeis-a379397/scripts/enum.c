/* Program 2: independent brute-force enumeration of nondecreasing tuples
   1 <= x1 <= ... <= xt, t <= 9, sum of cubes <= N. Counts per n. */
#include <stdio.h>
#include <stdlib.h>
static long long *cnt; static long N;
static void rec(int depth, int minx, long sum) {
  if (depth > 0) cnt[sum]++;
  if (depth == 9) return;
  for (long x = minx; sum + x*x*x <= N; x++) rec(depth+1, (int)x, sum + x*x*x);
}
int main(int argc, char **argv) {
  N = atol(argv[1]); cnt = calloc(N+1, sizeof(long long));
  rec(0, 1, 0);
  for (int k = 1; k <= 5; k++) {
    long c = 0, last = -1; printf("K %d", k);
    for (long n = 1; n <= N; n++) if (cnt[n] == k) { c++; last = n; }
    printf(" %ld %ld ", c, last);
    int first = 1;
    for (long n = 1; n <= N; n++) if (cnt[n] == k) { printf(first ? "%ld" : ",%ld", n); first = 0; }
    printf("\n");
  }
  return 0;
}
