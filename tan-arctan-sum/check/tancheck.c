/* Independent checker.
 *
 * P_n = prod_{k<=n} (1 + k i) = A_n + i B_n,  tan(arctan 1 + ... + arctan n) = B_n / A_n.
 * Let g_n = gcd(A_n, B_n) (the integer content of P_n in Z[i]) and Q_n = P_n / g_n, primitive.
 * Then tan = Im(Q_n)/Re(Q_n) in lowest terms, so it is an integer  <=>  Re(Q_n) = +-1.
 *
 * g_n from the factorisation of the norms 1 + k^2:
 *   - odd q = 3 mod 4 never divides 1 + k^2, so never divides g_n;
 *   - p = 1 mod 4 splits as pi * pibar; 1 + k i is divisible only by the pi whose root class contains k mod p
 *     (classes {c} and {p - c}, c^2 = -1 mod p) and then with exponent v_p(1 + k^2);
 *     v_p(g_n) = min(sum over class 0, sum over class 1);
 *   - p = 2: each odd k contributes (1+i)^1, so v_2(g_n) = floor(#odd k <= n / 2).
 * Test: for primes q = 3 mod 4 compute Re(Q_n) mod q = Re(P_n mod q) * g_n^{-1} mod q in F_q[i].
 * If Re(Q_n) mod q is not +-1 for some q, then Re(Q_n) != +-1: a PROOF that tan is not an integer (or that A_n = 0).
 * n is reported as CANDIDATE only if Re(Q_n) = +-1 mod both moduli.
 * Usage: tancheck NMAX [dumpmax [blocksize [spot n ...]]]   (dumpmax: print "n g mod q1  ReQ mod q1" for n <= dumpmax, for the exact cross-check)
 */
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
typedef unsigned __int128 u128; typedef uint64_t u64;
static const u64 Q1 = 2305843009213693951ULL;   /* 2^61 - 1, = 3 mod 4 */
static const u64 Q2 = 4611686018427387847ULL;   /* largest prime < 2^62 that is 3 mod 4 */
static inline u64 mm(u64 a, u64 b, u64 q){ return (u64)((u128)a*b % q); }
static u64 pw(u64 a, u64 e, u64 q){ u64 r=1; a%=q; while(e){ if(e&1) r=mm(r,a,q); a=mm(a,a,q); e>>=1;} return r; }
static u64 pwp(u64 a,u64 e,u64 p){ return pw(a,e,p); }

int main(int argc, char**argv){
  long N = atol(argv[1]); long dump = argc>2 ? atol(argv[2]) : 0;
  long PM = N;                         /* sieve primes up to N >= sqrt(N^2+1) - 1 */
  char *comp = calloc(PM+1,1);
  for(long i=2;i*i<=PM;i++) if(!comp[i]) for(long j=i*i;j<=PM;j+=i) comp[j]=1;
  long np=0; for(long p=5;p<=PM;p+=4) if(!comp[p]) np++;
  u64 *pr = malloc(np*8), *nx0 = malloc(np*8), *nx1 = malloc(np*8); long t=0;
  for(long p=5;p<=PM;p+=4) if(!comp[p]){
    u64 c=0; for(u64 a=2;;a++){ u64 x=pwp(a,(p-1)/4,p); if(mm(x,x,p)==(u64)p-1){ c=x; break; } }
    if(c > (u64)p/2) c = p - c;        /* class 0 = root <= p/2 */
    pr[t]=p; nx0[t]=c; nx1[t]=p-c; t++;
  }
  free(comp);
  /* exponent sums per prime, for primes up to 2N (large cofactors in (N,2N] can recur once) */
  long SM = 2*N+2;
  uint32_t *S0 = calloc(SM,4), *S1 = calloc(SM,4);
  long BLK = argc>3 ? atol(argv[3]) : (1<<20); u64 *rem = malloc(BLK*8);
  /* per-k factor list inside a block: store (p,e) pairs via linked arrays */
  long cap = BLK*12; u64 *fp = malloc(cap*8); uint8_t *fe = malloc(cap); int32_t *fnext = malloc(cap*4); int32_t *head = malloc(BLK*4);
  u64 A1=1,B1=0,A2=1,B2=0, g1=1,g2=1; long odd=0, g2exp=0;
  long cand=0, zero=0; u64 hash=1469598103934665603ULL;
  for(long lo=1; lo<=N; lo+=BLK){
    long hi = lo+BLK-1; if(hi>N) hi=N; long L = hi-lo+1, used=0;
    for(long i=0;i<L;i++){ u64 k=lo+i; rem[i]=1+k*k; head[i]=-1; if(k&1) rem[i]>>=1; }
    for(long j=0;j<np;j++){ u64 p=pr[j];
      for(int cl=0;cl<2;cl++){ u64 *nx = cl?nx1:nx0; u64 k=nx[j];
        for(; k<=(u64)hi; k+=p){ long i=k-lo; int e=0; while(rem[i]%p==0){ rem[i]/=p; e++; }
          if(e==0){ fprintf(stderr,"sieve error p=%lu k=%lu\n",p,k); return 2; }
          if(used>=cap){ fprintf(stderr,"cap\n"); return 2; }
          fp[used]=p; fe[used]=e; fnext[used]=head[i]; head[i]=used; used++; }
        nx[j]=k; }
    }
    for(long i=0;i<L;i++){ u64 k=lo+i;
      /* P *= (1 + k i) mod q */
      u64 kk1=k%Q1, kk2=k%Q2;
      u64 a=(A1 + Q1 - mm(kk1,B1,Q1))%Q1, b=(B1 + mm(kk1,A1,Q1))%Q1; A1=a; B1=b;
      a=(A2 + Q2 - mm(kk2,B2,Q2))%Q2; b=(B2 + mm(kk2,A2,Q2))%Q2; A2=a; B2=b;
      if(k&1){ odd++; long ne = odd/2; if(ne>g2exp){ g1=mm(g1,2,Q1); g2=mm(g2,2,Q2); g2exp=ne; } }
      /* factors p<=N from the sieve, plus cofactor */
      for(int32_t f=head[i]; f>=0; f=fnext[f]){
        u64 p=fp[f]; int e=fe[f]; int cl = (k%p) > p/2;
        long om = S0[p]<S1[p]?S0[p]:S1[p]; if(cl) S1[p]+=e; else S0[p]+=e;
        long nm = S0[p]<S1[p]?S0[p]:S1[p];
        if(nm>om){ g1=mm(g1,pw(p,nm-om,Q1),Q1); g2=mm(g2,pw(p,nm-om,Q2),Q2); } }
      u64 R=rem[i];
      if(R>1){ if(R<=(u64)N){ fprintf(stderr,"unfactored small cofactor %lu at k=%lu\n",R,k); return 2; }
        if(R < (u64)SM){ u64 p=R; int cl=(k%p) > p/2;
          long om = S0[p]<S1[p]?S0[p]:S1[p]; if(cl) S1[p]+=1; else S0[p]+=1;
          long nm = S0[p]<S1[p]?S0[p]:S1[p];
          if(nm>om){ g1=mm(g1,pw(p,nm-om,Q1),Q1); g2=mm(g2,pw(p,nm-om,Q2),Q2); } } }
      u64 r1 = mm(A1, pw(g1,Q1-2,Q1), Q1), r2 = mm(A2, pw(g2,Q2-2,Q2), Q2);
      hash = (hash ^ r1) * 1099511628211ULL;
      int spot=0; for(int a=4;a<argc;a++) if(atol(argv[a])==(long)k) spot=1;
      if((long)k<=dump || spot) printf("%lu %lu %lu\n", k, g1, r1);
      int pm1 = (r1==1||r1==Q1-1), pm2=(r2==1||r2==Q2-1);
      if(pm1 && pm2){ cand++; fprintf(stderr,"CANDIDATE n=%lu (Re(Q) = +-1 mod q1 and q2)\n",k); }
      else if(pm1 || pm2) fprintf(stderr,"note: n=%lu is +-1 mod only one modulus\n",k);
      if(r1==0 && r2==0){ zero++; fprintf(stderr,"Re(P)=0 suspect n=%lu\n",k); }
    }
  }
  fprintf(stderr,"N=%ld candidates=%ld zeroRe=%ld hash=%016lx\n",N,cand,zero,hash);
  return 0;
}
