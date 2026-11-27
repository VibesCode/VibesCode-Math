// A058627 search: n with phi(n) = product of decimal digits of n, all n with k digits for k in [K1, K2] (K2 <= 38).
// Method (see ../RESULT.md): P = digit product is 7-smooth and P >= 10^(k-1)/C, C = 8.2586 (bound on n/phi(n) when phi(n) is
// 7-smooth). n = A * B with A 7-smooth and B a squarefree product of primes p > 7 with p - 1 | P (each such p divides n
// exactly once, since p^2 | n would put p into phi(n)). DFS over B (largest prime first), then solve phi(A) = rest exactly.
#include <cstdio>
#include <cstdlib>
#include <cmath>
#include <vector>
#include <set>
#include <algorithm>
#include <functional>
typedef unsigned __int128 u128;
struct E { int a, b, c, d; };
static std::vector<E> Q; static std::vector<double> Qval; static std::vector<u128> QX;   // primes p > 7: p - 1 = 2^a 3^b 5^c 7^d, ascending
static const double LOG2 = log(2.0), LOG3 = log(3.0), LOG5 = log(5.0), LOG7 = log(7.0);
static u128 pw(u128 b, int e) { u128 r = 1; while (e--) r *= b; return r; }
static u128 val(E e) { return pw(2, e.a) * pw(3, e.b) * pw(5, e.c) * pw(7, e.d); }
static double lval(E e) { return e.a * LOG2 + e.b * LOG3 + e.c * LOG5 + e.d * LOG7; }
static u128 LO, HI, PV; static E PE; static int K;
static std::vector<int> cand; static std::vector<double> prefLog;  // candidate prime indices for this P, ascending
static unsigned long long nodes = 0, leaves = 0;
static std::vector<u128> hits;
static double logLo, logHi;
static void prt(u128 x) { char s[64]; int i = 63; s[i] = 0; if (!x) s[--i] = '0'; while (x) { s[--i] = '0' + (int)(x % 10); x /= 10; } printf("%s", s + i); }
static bool dprod_ok(u128 n) {          // digit product of n == PV ?
    u128 p = 1;
    while (n) { int d = (int)(n % 10); if (!d) return false; p *= d; if (p > PV) return false; n /= 10; }
    return p == PV;
}
static void check(u128 n) {
    leaves++;
    if (n >= LO && n < HI && dprod_ok(n)) hits.push_back(n);
}
// solve phi(A) = 2^a 3^b 5^c 7^d with A 7-smooth; for each A, test n = B * A
static void finish(E R, u128 B) {
    for (int w = 0; w <= 1 + R.d; w++) {            // exponent of 7 in A
        if (R.d > 0 && w != R.d + 1) continue;
        if (R.d == 0 && w > 1) break;
        E r = R; if (w) { r.a -= 1; r.b -= 1; r.d -= (w - 1); } if (r.a < 0 || r.b < 0) continue;
        for (int z = 0; z <= 1 + r.c; z++) {        // exponent of 5
            if (r.c > 0 && z != r.c + 1) continue;
            if (r.c == 0 && z > 1) break;
            E s = r; if (z) { s.a -= 2; s.c -= (z - 1); } if (s.a < 0) continue;
            // now s.c == 0, s.d == 0; exponent of 3: y
            for (int y = 0; y <= 1 + s.b; y++) {
                if (s.b > 0 && y != s.b + 1) continue;
                if (s.b == 0 && y > 1) break;
                E t = s; if (y) { t.a -= 1; t.b -= (y - 1); } if (t.a < 0) continue;
                // 2^t.a = phi(2^x): x = t.a + 1 if t.a > 0; if t.a == 0, x in {0, 1}
                u128 A0 = pw(3, y) * pw(5, z) * pw(7, w);
                if (t.a > 0) check(B * A0 * pw(2, t.a + 1));
                else { check(B * A0); check(B * A0 * 2); }
            }
        }
    }
}
// i: candidates cand[0..i-1] still available. R: remaining phi. lB = log B, lphiB = log phi(B)
static void dfs(int i, E R, u128 B, double lB, double lphiB) {
    nodes++;
    double lR = lval(R);
    // lower bound on final n: B * (something with phi = R) >= B * R ; need < HI
    if (lB + lR >= logHi + 1e-9) return;
    // upper bound on final n: B * R * (prod of remaining candidate ratios) * 4.375 (max ratio of a 7-smooth A)
    if (lB + lR + prefLog[i] + log(4.375) < logLo - 1e-9) return;
    finish(R, B);
    for (int j = i - 1; j >= 0; j--) {
        const E &q = Q[cand[j]];
        if (q.a > R.a || q.b > R.b || q.c > R.c || q.d > R.d) continue;
        E r = {R.a - q.a, R.b - q.b, R.c - q.c, R.d - q.d};
        double lp = log(Qval[cand[j]]);
        dfs(j, r, B * QX[cand[j]], lB + lp, lphiB + lval(q));
    }
}
int main(int argc, char **argv) {
    int K1 = atoi(argv[1]), K2 = atoi(argv[2]); const char *qf = argv[3];
    FILE *f = fopen(qf, "r"); E e; while (fscanf(f, "%d %d %d %d", &e.a, &e.b, &e.c, &e.d) == 4) { Q.push_back(e); Qval.push_back(0); } fclose(f);
    for (size_t i = 0; i < Q.size(); i++) Qval[i] = (double)(val(Q[i]) + 1);  // exact below 2^53 only; B uses exact below
    // keep exact prime values for B
    QX.resize(Q.size()); for (size_t i = 0; i < Q.size(); i++) QX[i] = val(Q[i]) + 1;
    for (K = K1; K <= K2; K++) {
        LO = pw(10, K - 1); HI = pw(10, K); logLo = (K - 1) * log(10.0); logHi = K * log(10.0);
        double logLowP = logLo - log(8.2586);
        // distinct digit-product exponent vectors for k digits with log P >= logLowP
        std::set<std::vector<int>> Ps;
        int dexp[10][4] = {{0,0,0,0},{0,0,0,0},{1,0,0,0},{0,1,0,0},{2,0,0,0},{0,0,1,0},{1,1,0,0},{0,0,0,1},{3,0,0,0},{0,2,0,0}};
        // counts c1..c8 then 9s fill
        std::vector<int> cnt(10, 0);
        std::function<void(int,int,double,int,int,int,int)> go;
        unsigned long long nP = 0;
        go = [&](int d, int left, double lP, int a, int b, int c, int dd) {
            if (lP + left * log(9.0) < logLowP - 1e-9) return;
            if (d == 9) { Ps.insert({a, b + 2 * left, c, dd}); return; }
            for (int cc = 0; cc <= left; cc++) {
                double l2 = lP + cc * log((double)d);
                if (l2 + (left - cc) * log(9.0) < logLowP - 1e-9) break;
                go(d + 1, left - cc, l2, a + dexp[d][0] * cc, b + dexp[d][1] * cc, c + dexp[d][2] * cc, dd + dexp[d][3] * cc);
            }
        };
        go(1, K, 0.0, 0, 0, 0, 0);
        nodes = leaves = 0; size_t h0 = hits.size();
        for (auto &v : Ps) {
            PE = {v[0], v[1], v[2], v[3]}; PV = val(PE);
            cand.clear(); prefLog.assign(1, 0.0);
            for (size_t i = 0; i < Q.size(); i++) { const E &q = Q[i]; if (q.a <= PE.a && q.b <= PE.b && q.c <= PE.c && q.d <= PE.d) { cand.push_back(i); prefLog.push_back(prefLog.back() + log(Qval[i] / (Qval[i] - 1.0))); } }
            dfs((int)cand.size(), PE, 1, 0.0, 0.0);
            nP++;
        }
        printf("k=%d Pvalues=%llu nodes=%llu leaves=%llu hits:", K, nP, nodes, leaves);
        for (size_t t = h0; t < hits.size(); t++) { printf(" "); prt(hits[t]); }
        printf("\n"); fflush(stdout);
    }
}
