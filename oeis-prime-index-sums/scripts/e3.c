/* Batch 2, engine 2: own odd-only segmented sieve, plain u128 %, Newton isqrt, trial-division primality.
   args: lo hi k0 S0. Sieves from lo-20000 to rebuild the window history itself (no primesieve). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
typedef unsigned __int128 u128; typedef uint64_t u64;
static u128 parse(const char*s){u128 v=0; while(*s) v=v*10+(*s++-'0'); return v;}
static u128 isqrt128(u128 x){ if(x<2) return x; int b=(x>>64)? 128-__builtin_clzll((u64)(x>>64)) : 64-__builtin_clzll((u64)x);
  u128 r=(u128)1<<((b+1)/2); for(;;){ u128 y=(r+x/r)>>1; if(y>=r) return r; r=y; } }
static int issq(u128 v,u128*rt){ u128 r=isqrt128(v); if(rt)*rt=r; return r*r==v; }
static int isprime64(u64 n){ if(n<2) return 0; for(u64 d=2;d*d<=n;d++) if(n%d==0) return 0; return 1; }
static u64 LO,k; static u128 S; static u64 ring[256]; static long long pre_n=0; static u128 pre_s=0; static u64 pre[4096];
static u64 cnt_seen=0;
static void P(const char*n,u64 i,u64 p){ printf("%s k=%llu p=%llu\n",n,(unsigned long long)i,(unsigned long long)p); }
static void test(u64 p){
  k++; S+=p; ring[k&255]=p; u64 pm1=ring[(k-1)&255], pm2=ring[(k-2)&255];
  if(k>=70){ u128 w=0; for(int i=0;i<70;i++) w+=ring[(k-i)&255]; if(issq(w,0)) P("A166255",k-69,ring[(k-69)&255]); }
  if(k>=120){ u128 w=0; for(int i=0;i<120;i++) w+=ring[(k-i)&255]; if(issq(w,0)) P("A166261",k-119,ring[(k-119)&255]); }
  if(k%2==0 && S%k==k/2) P("A263076",k,p);
  if(k>=2){ u64 j=k-1;
    if(((u128)pm1+p)%(2*(u128)j+1)==0) P("A278693",j,pm1);
    if(issq((u128)pm1*pm1+(u128)p*p-1,0)) P("A160054",j,pm1);
    if(issq((u128)pm1+2*(u128)p,0)) P("A064504",j,pm1);
    { u128 a=(u128)j*p, b=(u128)(j+1)*pm1; if(a>=b && issq(a-b,0)) P("A067805",j,pm1); } }
  if(k>=3 && p-pm2==8 && issq((u128)pm2+7,0)) P("A158470",k-1,pm1);
  { u128 r; if(issq((u128)k+p,&r) && isprime64((u64)r)) P("A104911",k,p); }
}
static void visit(u64 x){ if(x<=LO){ pre[pre_n++]=x; pre_s+=x; return; }
  if(!cnt_seen){ cnt_seen=1; k-=pre_n; S-=pre_s; for(long long i=0;i<pre_n;i++){ k++; S+=pre[i]; ring[k&255]=pre[i]; } } test(x); }
int main(int argc,char**argv){
  LO=strtoull(argv[1],0,10); u64 HI=strtoull(argv[2],0,10); k=strtoull(argv[3],0,10); S=parse(argv[4]);
  u64 A=LO>20000?LO-20000:0;
  if(A<2 && HI>=2) visit(2);
  u64 start=(A<3)?3:((A%2)?A+2:A+1); u64 sq=1; while(sq*sq<=HI) sq++;
  char *small=calloc(sq+1,1); uint32_t *prm=malloc(sizeof(uint32_t)*sq); int np=0;
  for(u64 i=3;i<=sq;i+=2) if(!small[i]){ prm[np++]=i; for(u64 j=i*i;j<=sq;j+=2*i) small[j]=1; }
  const u64 SEG=1<<22; char *seg=malloc(SEG);
  for(u64 a=start;a<=HI;a+=2*SEG){ u64 b=a+2*(SEG-1); if(b>HI) b=HI; if(b%2==0) b--; if(b<a) break; u64 len=(b-a)/2+1; memset(seg,0,len);
    for(int i=0;i<np;i++){ u64 p=prm[i]; if(p*p>b) break; u64 s=((a+p-1)/p)*p; if(s<p*p) s=p*p; if(s%2==0) s+=p; for(u64 j=(s-a)/2;j<len;j+=p) seg[j]=1; }
    for(u64 t=0;t<len;t++) if(!seg[t]) visit(a+2*t); }
  printf("# END k=%llu\n",(unsigned long long)k); return 0; }
