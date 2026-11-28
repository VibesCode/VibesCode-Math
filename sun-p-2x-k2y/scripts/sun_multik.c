// Engine 1 (general) for Sun's p + 2^x + k*2^y family: odd N in [N0,N1] with NO representation
// N = p + 2^x + k*2^y, x,y>=1, p odd prime with class condition cls: 0 = any odd prime, 1 = p%6==1, 5 = p%6==5.
// usage: sun_pxky k cls N0 N1 threads
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <omp.h>
#include <string.h>
static uint64_t *bits; // bit i set => 2i+1 composite
static inline int isoddprime(uint64_t p){ uint64_t i=p>>1; return !((bits[i>>6]>>(i&63))&1); }
int main(int argc,char**argv){
  int cls=atoi(argv[2]); char *klist=argv[1];
  uint64_t N0=strtoull(argv[3],0,10), N1=strtoull(argv[4],0,10); int T=atoi(argv[5]);
  uint64_t M=N1/2+2; bits=calloc(M/64+2,8); bits[0]|=1; // 1 not prime
  uint64_t lim=1; while(lim*lim<=N1) lim++;
  char *sp=calloc(lim+1,1);
  for(uint64_t q=3;q<=lim && q*q<=N1;q+=2) if(!sp[q]){ for(uint64_t j=q*q;j<=lim;j+=q) sp[j]=1;
    uint64_t start=q*q, step=2*q, cnt=(N1-start)/step+1;
    #pragma omp parallel for num_threads(T) schedule(static)
    for(int r=0;r<T;r++){ uint64_t per=cnt/T+1, a=r*per, b=a+per; if(b>cnt) b=cnt;
      for(uint64_t t=a;t<b;t++){ uint64_t i=(start+t*step)>>1; __atomic_fetch_or(&bits[i>>6],1ULL<<(i&63),__ATOMIC_RELAXED);} }
  }
  fprintf(stderr,"sieve done\n");
  uint64_t N0s=N0;
  for(char *tok=strtok(klist,",");tok;tok=strtok(NULL,",")){ uint64_t k=strtoull(tok,0,10); uint64_t N0=N0s;
  if(N0%2==0) N0++; if(N0<2*k+5) N0=2*k+5; if(N0%2==0) N0++;
  uint64_t chunk=1<<22, nch=(N1-N0)/chunk+1; long zeros=0;
  #pragma omp parallel for num_threads(T) schedule(dynamic,1) reduction(+:zeros)
  for(uint64_t c=0;c<nch;c++){
    uint64_t a=N0+c*chunk, b=a+chunk; if(b>N1+1) b=N1+1; if(a%2==0) a++;
    for(uint64_t N=a;N<b;N+=2){
      int found=0;
      for(int x=1;!found && (1ULL<<x)<N;x++) for(int y=1;;y++){ uint64_t t=(1ULL<<x)+k*(1ULL<<y); if(t>=N) break; uint64_t p=N-t;
          if(p<3) continue; if(cls && (int)(p%6)!=cls) continue; if(isoddprime(p)){found=1;break;} }
      if(!found){ zeros++;
        #pragma omp critical
        { printf("NOREP k=%llu %llu\n",(unsigned long long)k,(unsigned long long)N); fflush(stdout);} }
    }
  }
  printf("DONE k=%llu cls=%d N in [%llu,%llu] odd, count %ld\n",(unsigned long long)k,cls,(unsigned long long)N0,(unsigned long long)N1,zeros);
  }
}
