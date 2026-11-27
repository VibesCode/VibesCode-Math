// Own scan: n in [A,B), v = n^2 XOR n(n+1)/2 (unsigned __int128), test perfect square.
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <pthread.h>
typedef unsigned long long u64; typedef unsigned __int128 u128;
static u64 A,B,STEP; static int T; static u64 nexts; static pthread_mutex_t mu=PTHREAD_MUTEX_INITIALIZER;
static unsigned char sq64[64], sq63[63], sq65[65], sq11[11];
static void *w(void*_){ for(;;){ pthread_mutex_lock(&mu); u64 a=nexts; nexts+=STEP; pthread_mutex_unlock(&mu); if(a>=B) break; u64 b=a+STEP>B?B:a+STEP;
  for(u64 n=a;n<b;n++){ u128 v=((u128)n*n) ^ (((u128)n*(n+1))>>1);
    if(!sq64[(unsigned)v&63]) continue; if(!sq63[(unsigned)(v%63)]) continue; if(!sq65[(unsigned)(v%65)]) continue; if(!sq11[(unsigned)(v%11)]) continue;
    long double x=sqrtl((long double)v); u128 s=(u128)x; if(s>2) s-=2; else s=0; while(s*s<v) s++;
    if(s*s==v){ pthread_mutex_lock(&mu); printf("HIT n=%llu root=%llu\n",n,(u64)s); fflush(stdout); pthread_mutex_unlock(&mu);} } }
  return 0; }
int main(int c,char**v){ A=strtoull(v[1],0,10); B=strtoull(v[2],0,10); T=atoi(v[3]); STEP=100000000ULL; nexts=A;
  for(int i=0;i<64;i++) sq64[i*i%64]=1; for(int i=0;i<63;i++) sq63[i*i%63]=1; for(int i=0;i<65;i++) sq65[i*i%65]=1; for(int i=0;i<11;i++) sq11[i*i%11]=1;
  pthread_t th[64]; for(int i=0;i<T;i++) pthread_create(&th[i],0,w,0); for(int i=0;i<T;i++) pthread_join(th[i],0); printf("END [%llu,%llu)\n",A,B); }
