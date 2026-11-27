// Own scan: x in (L, H], running k = #squarefree <= x and S = sum of squarefree <= x, starting from given (k0,S0) at L.
// Prints every squarefree x with S a perfect square, and the final (k,S) at H.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
typedef unsigned long long u64; typedef unsigned __int128 u128;
static u128 parse128(const char*s){u128 v=0; while(*s) v=v*10+(*s++-'0'); return v;}
static void pr128(u128 v){char b[50];int i=49;b[i]=0; if(!v) b[--i]='0'; while(v){b[--i]='0'+(int)(v%10); v/=10;} fputs(b+i,stdout);}
int main(int c,char**v){ u64 L=strtoull(v[1],0,10),H=strtoull(v[2],0,10),k=strtoull(v[3],0,10); u128 S=parse128(v[4]);
  u64 R=(u64)sqrtl((long double)H)+2; char*cp=calloc(R+1,1); u64*pr=malloc(8*R); int np=0;
  for(u64 i=2;i<=R;i++) if(!cp[i]){ pr[np++]=i; for(u64 j=i*i;j<=R;j+=i) cp[j]=1; }
  unsigned char q64[64]={0},q63[63]={0},q65[65]={0},q11[11]={0}; for(int i=0;i<64;i++)q64[i*i%64]=1; for(int i=0;i<63;i++)q63[i*i%63]=1; for(int i=0;i<65;i++)q65[i*i%65]=1; for(int i=0;i<11;i++)q11[i*i%11]=1;
  const u64 B=1<<24; unsigned char*sf=malloc(B);
  for(u64 a=L+1;a<=H;a+=B){ u64 n=B; if(a+n-1>H) n=H-a+1; memset(sf,1,n);
    for(int i=0;i<np;i++){ u64 q=pr[i]*pr[i]; if(q>a+n-1) break; u64 f=((a+q-1)/q)*q; for(u64 j=f-a;j<n;j+=q) sf[j]=0; }
    for(u64 j=0;j<n;j++) if(sf[j]){ u64 x=a+j; k++; S+=x;
      if(q64[(unsigned)S&63]&&q63[(unsigned)(S%63)]&&q65[(unsigned)(S%65)]&&q11[(unsigned)(S%11)]){ long double r=sqrtl((long double)S); u128 s=(u128)r; if(s>2)s-=2; else s=0; while(s*s<S) s++;
        if(s*s==S){ printf("HIT x=%llu k=%llu S=",x,k); pr128(S); printf("\n"); fflush(stdout);} } } }
  printf("END H=%llu k=%llu S=",H,k); pr128(S); printf("\n"); return 0; }
