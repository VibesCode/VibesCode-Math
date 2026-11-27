// Independent scan for A073614: m*(prime(m)+1) a square. Own segmented odd-only sieve.
// Pass 1: count primes per chunk in (LO,HI]. Pass 2: with exact starting indices, test each prime.
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
#include <pthread.h>
typedef unsigned long long u64; typedef unsigned __int128 u128;
static u64 LO, HI, CH; static int NC; static u64 *cnt, *start;
static uint32_t *bp; static int nbp; static int pass; static int nextc=0;
static pthread_mutex_t mu=PTHREAD_MUTEX_INITIALIZER;
static FILE *hits;
#define SEG (1u<<21)  /* odds per segment */
static int issq_u128(u128 v, u64 *root){
  static const int dummy=0; (void)dummy;
  unsigned r64=(unsigned)(v&63); // squares mod 64
  if(!((0x0202021202030213ULL>>r64)&1)) return 0;
  long double x=sqrtl((long double)v); u128 s=(u128)x;
  if(s>2) s-=2; else s=0;
  while(s*s<v) s++;
  if(s*s==v){*root=(u64)s;return 1;} return 0;
}
static void do_chunk(int c, unsigned char *seg){
  u64 a=LO+(u64)c*CH, b=a+CH; if(b>HI) b=HI;  // numbers in (a,b]
  u64 n0=a+1; if(n0%2==0) n0++;               // first odd
  u64 count=0, idx=start?start[c]:0;
  for(u64 s0=n0; s0<=b; s0+=2ULL*SEG){
    u64 len=SEG; if(s0+2*(len-1)>b) len=(b-s0)/2+1;
    memset(seg,1,len);
    for(int i=0;i<nbp;i++){ u64 q=bp[i]; if(q*q> s0+2*(len-1)) break;
      u64 f=((s0+q-1)/q)*q; if(f<q*q) f=q*q; if(f%2==0) f+=q;
      for(u64 j=(f-s0)/2;j<len;j+=q) seg[j]=0; }
    for(u64 j=0;j<len;j++) if(seg[j]){ count++;
      if(pass==2){ idx++; u64 p=s0+2*j; u128 v=(u128)idx*(u128)(p+1); u64 r;
        if(issq_u128(v,&r)){ pthread_mutex_lock(&mu); fprintf(hits,"HIT m=%llu p=%llu root=%llu\n",idx,p,r); fflush(hits); pthread_mutex_unlock(&mu);} }
    }
  }
  if(pass==1) cnt[c]=count; else if(idx!=start[c]+count) fprintf(stderr,"bad\n");
}
static void *worker(void*arg){ unsigned char *seg=malloc(SEG);
  for(;;){ pthread_mutex_lock(&mu); int c=nextc++; pthread_mutex_unlock(&mu); if(c>=NC) break; do_chunk(c,seg); }
  free(seg); return 0; }
int main(int argc,char**argv){
  LO=strtoull(argv[1],0,10); HI=strtoull(argv[2],0,10); u64 PILO=strtoull(argv[3],0,10); CH=strtoull(argv[4],0,10); int T=atoi(argv[5]);
  // check point: argv[6]=X, argv[7]=pi(X) expected
  u64 X=argc>7?strtoull(argv[6],0,10):0, PIX=argc>7?strtoull(argv[7],0,10):0;
  NC=(HI-LO+CH-1)/CH; cnt=calloc(NC,8);
  u64 L=(u64)sqrtl((long double)HI)+2; char *sv=calloc(L+1,1); bp=malloc(sizeof(uint32_t)*L/2);
  for(u64 i=2;i<=L;i++) if(!sv[i]){ if(i>2) bp[nbp++]=i; for(u64 j=i*i;j<=L;j+=i) sv[j]=1; }
  hits=stdout; pthread_t th[64];
  for(pass=1;pass<=2;pass++){ nextc=0; if(pass==2){ start=malloc(8*NC); u64 acc=PILO; for(int c=0;c<NC;c++){ start[c]=acc; acc+=cnt[c]; }
      printf("pi(HI)=%llu\n",acc); if(X){ u64 x=PILO; for(int c=0;c<NC&&LO+(u64)c*CH<X;c++) x+=cnt[c]; printf("pi(%llu) via chunks=%llu expected=%llu %s\n",X,x,PIX,x==PIX?"OK":"MISMATCH"); } fflush(stdout); }
    for(int t=0;t<T;t++) pthread_create(&th[t],0,worker,0); for(int t=0;t<T;t++) pthread_join(th[t],0);
    printf("pass %d done\n",pass); fflush(stdout); }
  return 0; }
