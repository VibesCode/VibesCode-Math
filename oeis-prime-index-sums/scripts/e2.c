/* Engine 2: own odd-only segmented sieve (no primesieve), plain u128 % and Newton isqrt.
   mode 0: e2 0 LO HI           -> local count, sum p, sum p^2, sum at local odd positions over primes in (LO,HI]
   mode 1: e2 1 LO HI k0 S0 Q0 E0 O0 pprev -> test predicates for primes in (LO,HI] */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
typedef unsigned __int128 u128; typedef uint64_t u64;
static u128 parse(const char*s){u128 v=0; while(*s) v=v*10+(*s++-'0'); return v;}
static void pr(u128 v){ char b[64]; int i=63; b[i]=0; if(!v){printf("0");return;} while(v){b[--i]='0'+(int)(v%10); v/=10;} printf("%s",b+i); }
static u128 isqrt128(u128 x){ if(x<2) return x; int b=(x>>64)? 128-__builtin_clzll((u64)(x>>64)) : 64-__builtin_clzll((u64)x);
  u128 r=(u128)1<<((b+1)/2); for(;;){ u128 y=(r+x/r)>>1; if(y>=r) return r; r=y; } }
static char q64[64],q63[63],q65[65],q11[11];
static int issq(u128 v){ if(!q64[(int)(v%64)]||!q63[(int)(v%63)]||!q65[(int)(v%65)]||!q11[(int)(v%11)]) return 0; u128 r=isqrt128(v); return r*r==v; }
static int mode; static u64 k,pp; static u128 S,Q,E,O; static u64 n_loc;
static void visit(u64 p){
  if(mode==0){ n_loc++; S+=p; Q+=(u128)p*p; if(n_loc&1) O+=p; return; }
  k++; S+=p; Q+=(u128)p*p;
  if(k>1 && issq((u128)(k-1)*pp+(u128)k*p)) printf("A175897 k=%llu p=%llu\n",(unsigned long long)(k-1),(unsigned long long)pp);
  if(issq((u128)k*(p+1))) printf("A073614 k=%llu p=%llu\n",(unsigned long long)k,(unsigned long long)p);
  if(issq(S)) printf("A033997 k=%llu p=%llu\n",(unsigned long long)k,(unsigned long long)p);
  if(issq(S+1)) printf("A264858 k=%llu p=%llu\n",(unsigned long long)k,(unsigned long long)p);
  if(S%(k+1)==0) printf("A098074 k=%llu p=%llu\n",(unsigned long long)k,(unsigned long long)p);
  if((S+1)%(k+1)==0) printf("A158682 k=%llu p=%llu\n",(unsigned long long)k,(unsigned long long)p);
  if((S*S)%k==0) {} /* S*S overflows u128 for large S; use modular */
  { u128 r=S%k; if((r*r)%k==0) printf("A111452 k=%llu p=%llu\n",(unsigned long long)k,(unsigned long long)p); }
  if((Q+1)%(k+1)==0) printf("A153022 k=%llu p=%llu\n",(unsigned long long)k,(unsigned long long)p);
  if(Q%p==0) printf("A077022 k=%llu p=%llu\n",(unsigned long long)k,(unsigned long long)p);
  if(k%2){ O+=p; if(O%((k+1)/2)==0) printf("A263549 j=%llu p=%llu\n",(unsigned long long)((k+1)/2),(unsigned long long)p); }
  else   { E+=p; if(E%(k/2)==0) printf("A263546 j=%llu p=%llu\n",(unsigned long long)(k/2),(unsigned long long)p); }
  pp=p; }
int main(int argc,char**argv){
  for(int i=0;i<64;i++) q64[(i*i)%64]=1; for(int i=0;i<63;i++) q63[(i*i)%63]=1; for(int i=0;i<65;i++) q65[(i*i)%65]=1; for(int i=0;i<11;i++) q11[(i*i)%11]=1;
  mode=atoi(argv[1]); u64 LO=strtoull(argv[2],0,10), HI=strtoull(argv[3],0,10);
  if(mode==1){ k=strtoull(argv[4],0,10); S=parse(argv[5]); Q=parse(argv[6]); E=parse(argv[7]); O=parse(argv[8]); pp=strtoull(argv[9],0,10); }
  if(LO<2 && HI>=2) visit(2);
  u64 start=(LO<3)?3:((LO%2)?LO+2:LO+1); u64 sq=1; while(sq*sq<=HI) sq++;
  char *small=calloc(sq+1,1); uint32_t *prm=malloc(sizeof(uint32_t)*sq); int np=0;
  for(u64 i=3;i<=sq;i+=2) if(!small[i]){ prm[np++]=i; for(u64 j=i*i;j<=sq;j+=2*i) small[j]=1; }
  const u64 SEG=1<<22; char *seg=malloc(SEG);
  for(u64 a=start;a<=HI;a+=2*SEG){ u64 b=a+2*(SEG-1); if(b>HI) b=HI; if(b%2==0) b--; if(b<a) break; u64 len=(b-a)/2+1; memset(seg,0,len);
    for(int i=0;i<np;i++){ u64 p=prm[i]; if(p*p>b) break; u64 s=((a+p-1)/p)*p; if(s<p*p) s=p*p; if(s%2==0) s+=p; for(u64 j=(s-a)/2;j<len;j+=p) seg[j]=1; }
    for(u64 t=0;t<len;t++) if(!seg[t]) visit(a+2*t); }
  if(mode==0){ printf("%llu %llu %llu ",(unsigned long long)LO,(unsigned long long)HI,(unsigned long long)n_loc); pr(S); printf(" "); pr(Q); printf(" "); pr(O); printf("\n"); }
  else { printf("# END k=%llu S=",(unsigned long long)k); pr(S); printf(" Q="); pr(Q); printf(" E="); pr(E); printf(" O="); pr(O); printf(" last=%llu\n",(unsigned long long)pp); }
  return 0; }
