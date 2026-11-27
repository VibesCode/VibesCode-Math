// Own scan for A224241: k^2 XOR (k+1)^2 and k^2 XOR (k+2)^2 both perfect squares, k in [A,B).
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <pthread.h>
typedef unsigned long long u64; typedef unsigned __int128 u128;
static u64 A,B,STEP=1000000000ULL,nexts; static pthread_mutex_t mu=PTHREAD_MUTEX_INITIALIZER; static unsigned char q64[64],q63[63],q65[65];
static int sq(u128 v,u64*r){ if(!q64[(unsigned)v&63]||!q63[(unsigned)(v%63)]||!q65[(unsigned)(v%65)]) return 0;
  long double x=sqrtl((long double)v); u128 s=(u128)x; if(s>2) s-=2; else s=0; while(s*s<v) s++; if(s*s==v){*r=(u64)s;return 1;} return 0; }
static void*w(void*_){ for(;;){ pthread_mutex_lock(&mu); u64 a=nexts; nexts+=STEP; pthread_mutex_unlock(&mu); if(a>=B) break; u64 b=a+STEP>B?B:a+STEP;
  for(u64 k=a;k<b;k++){ u128 s0=(u128)k*k, s1=s0+2*(u128)k+1, s2=s0+4*(u128)k+4; u64 r1,r2;
    if(sq(s0^s1,&r1) && sq(s0^s2,&r2)){ pthread_mutex_lock(&mu); printf("HIT k=%llu r1=%llu r2=%llu\n",k,r1,r2); fflush(stdout); pthread_mutex_unlock(&mu);} } }
  return 0; }
int main(int c,char**v){ A=strtoull(v[1],0,10); B=strtoull(v[2],0,10); int T=atoi(v[3]); nexts=A;
  for(int i=0;i<64;i++)q64[i*i%64]=1; for(int i=0;i<63;i++)q63[i*i%63]=1; for(int i=0;i<65;i++)q65[i*i%65]=1;
  pthread_t th[64]; for(int i=0;i<T;i++) pthread_create(&th[i],0,w,0); for(int i=0;i<T;i++) pthread_join(th[i],0); printf("END [%llu,%llu)\n",A,B); }
