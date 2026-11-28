// Engine 1c: windowed exhaustive search for Sun's N = p + 2^x + k*2^y (x,y>=1, p odd prime, class cls as in sun_pxky).
// Each thread handles blocks [A, A+W) of odd N; segmented sieve of [A-T, A+W) answers p = N - t for t <= T,
// deterministic Miller-Rabin for larger t.  usage: sun_win k cls N0 N1 threads
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <omp.h>
typedef unsigned __int128 u128;
static uint64_t mulm(uint64_t a,uint64_t b,uint64_t m){return (u128)a*b%m;}
static uint64_t powm(uint64_t a,uint64_t e,uint64_t m){uint64_t r=1;a%=m;while(e){if(e&1)r=mulm(r,a,m);a=mulm(a,a,m);e>>=1;}return r;}
static int isprime64(uint64_t n){
  if(n<2) return 0; static const uint64_t sp[]={2,3,5,7,11,13,17,19,23,29,31,37};
  for(int i=0;i<12;i++){ if(n==sp[i]) return 1; if(n%sp[i]==0) return 0; }
  uint64_t d=n-1; int s=0; while(!(d&1)){d>>=1;s++;}
  static const uint64_t B[]={2,325,9375,28178,450775,9780504,1795265022};
  for(int i=0;i<7;i++){ uint64_t a=B[i]%n; if(!a) continue; uint64_t x=powm(a,d,n); if(x==1||x==n-1) continue;
    int ok=0; for(int r=1;r<s;r++){ x=mulm(x,x,n); if(x==n-1){ok=1;break;} } if(!ok) return 0; }
  return 1;
}
#define W (1ULL<<27)
#define T (1ULL<<27)
static uint32_t *bp; static int nbp;
int main(int argc,char**argv){
  uint64_t K=strtoull(argv[1],0,10); int CLS=atoi(argv[2]);
  uint64_t N0=strtoull(argv[3],0,10), N1=strtoull(argv[4],0,10); int TH=atoi(argv[5]);
  uint64_t lim=1; while(lim*lim<=N1) lim++;
  char *c=calloc(lim+1,1); bp=malloc(sizeof(uint32_t)*(lim/2+10)); nbp=0;
  for(uint64_t q=3;q<=lim;q+=2) if(!c[q]){ bp[nbp++]=q; for(uint64_t j=q*q;j<=lim;j+=2*q) c[j]=1; }
  if(N0%2==0) N0++;
  uint64_t nblk=(N1-N0)/W+1; long zeros=0;
  #pragma omp parallel num_threads(TH) reduction(+:zeros)
  {
    uint8_t *cmp=malloc((W+T)/2+16);
    #pragma omp for schedule(dynamic,1)
    for(uint64_t b=0;b<nblk;b++){
      uint64_t A=N0+b*W, E=A+W; if(E>N1+1) E=N1+1; if(A%2==0) A++;
      uint64_t lo=(A>T)?A-T:1; if(lo%2==0) lo--; if(lo<1) lo=1; // odd lo
      uint64_t len=(E-lo)/2+1; memset(cmp,0,len); // cmp[i] -> lo+2i
      for(int i=0;i<nbp;i++){ uint64_t q=bp[i]; if(q*q>E) break;
        uint64_t s=q*q; if(s<lo){ s=((lo+q-1)/q)*q; if(s%2==0) s+=q; }
        for(uint64_t m=s;m<E;m+=2*q) cmp[(m-lo)/2]=1; }
      if(lo==1) cmp[0]=1;
      for(uint64_t N=A;N<E;N+=2){
        int found=0;
        for(int x=1;!found && x<63 && (1ULL<<x)<N;x++) for(int y=1;y<60;y++){
          u128 t=(u128)(1ULL<<x)+(u128)K*(1ULL<<y); if(t>=N) break; uint64_t p=N-(uint64_t)t; if(p<3) continue;
          if(CLS && (int)(p%6)!=CLS) continue;
          int pr = (p>=lo) ? !cmp[(p-lo)/2] : isprime64(p);
          if(pr){found=1;break;} }
        if(!found){ zeros++;
          #pragma omp critical
          { printf("NOREP %lu\n",N); fflush(stdout);} }
      }
    }
  }
  printf("DONE k=%lu cls=%d N in [%lu,%lu] odd, norep %ld\n",K,CLS,N0,N1,zeros);
}
