// A226472: n such that n^2 XOR n(n+1)/2 is a perfect square. Scan n in [LO, HI).
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
typedef unsigned __int128 u128;
static char q64[64],q63[63],q65[65],q11[11];
static int issq(u128 a, u128 *root){
  if(!q64[(unsigned)(a&63)]) return 0;
  if(!q63[(unsigned)(a%63)]||!q65[(unsigned)(a%65)]||!q11[(unsigned)(a%11)]) return 0;
  long double d=sqrtl((long double)a); u128 r=(u128)d;
  while(r*r>a) r--; while((r+1)*(r+1)<=a) r++;
  *root=r; return r*r==a; }
int main(int c,char**v){ uint64_t LO=strtoull(v[1],0,10),HI=strtoull(v[2],0,10);
  for(int i=0;i<64;i++)q64[(i*i)%64]=1; for(int i=0;i<63;i++)q63[(i*i)%63]=1;
  for(int i=0;i<65;i++)q65[(i*i)%65]=1; for(int i=0;i<11;i++)q11[(i*i)%11]=1;
  for(uint64_t n=LO;n<HI;n++){ u128 N=n; u128 a=(N*N)^((N*(N+1))>>1); u128 r;
    if(issq(a,&r)){ printf("hit n=%llu root=",(unsigned long long)n);
      char b[50];int k=0; u128 t=r; do{b[k++]='0'+(int)(t%10);t/=10;}while(t); while(k)putchar(b[--k]); putchar('\n'); fflush(stdout);} }
  printf("END [%llu,%llu)\n",(unsigned long long)LO,(unsigned long long)HI); return 0; }
