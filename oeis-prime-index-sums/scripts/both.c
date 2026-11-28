// Own exhaustive scan over all primes p_i <= HI (i = 1, 2, ...; p_1 = 2), two passes.
// A263546: j such that j | (p_2 + p_4 + ... + p_{2j})   -> test at i = 2j: Seven mod j == 0
// A153022: k such that (k+1) | (1 + p_1^2 + ... + p_k^2) -> test at i = k: (Q+1) mod (k+1) == 0
// A263076: n with S_n mod n = n/2, S_n = p_1+...+p_n -> test at i = n (even): Sall mod n == n/2
// Also prints exact Q_i (and Q_i mod small) at user-given indices (dump list in argv after HI CH T).
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <math.h>
#include <pthread.h>
typedef unsigned long long u64; typedef unsigned __int128 u128;
static u64 HI,CH; static int NC,T,nextc,pass; static uint32_t*bp; static int nbp;
typedef struct { u64 cnt; u128 sodd, seven, q, sall; } St;   // local-odd/even position sums, sum of squares
static St *ps; static St *start; static u64 dump[64]; static int nd;
static pthread_mutex_t mu=PTHREAD_MUTEX_INITIALIZER;
static void pr128(FILE*f,u128 v){char b[50];int i=49;b[i]=0;if(!v)b[--i]='0';while(v){b[--i]='0'+(int)(v%10);v/=10;}fputs(b+i,f);}
#define SEG (1u<<21)
static void chunk(int c,unsigned char*s){ u64 a=(u64)c*CH,b=a+CH; if(b>HI)b=HI; // primes in (a,b]
  St st={0,0,0,0,0}; u64 I=0; u128 Se=0,Q=0,Sa=0; if(pass==2){ I=start[c].cnt; Se=start[c].seven; Q=start[c].q; Sa=start[c].sall; }
  if(a<2&&b>=2){ // the prime 2
    if(pass==1){ st.cnt++; st.sodd+=2; st.q+=4; st.sall+=2; } else { I++; Q+=4; Sa+=2; /* i=1 odd */ 
      if(((Q+1)%(u128)(I+1))==0){pthread_mutex_lock(&mu);printf("A153022 k=%llu\n",I);fflush(stdout);pthread_mutex_unlock(&mu);} 
      for(int d=0;d<nd;d++) if(dump[d]==I){pthread_mutex_lock(&mu);printf("DUMP i=%llu p=2 Q=",I);pr128(stdout,Q);printf("\n");pthread_mutex_unlock(&mu);} } }
  u64 n0=a+1; if(n0<3) n0=3; if(!(n0&1)) n0++;
  for(u64 s0=n0;s0<=b;s0+=2ULL*SEG){ u64 len=SEG; if(s0+2*(len-1)>b) len=(b-s0)/2+1; memset(s,1,len);
    for(int i=0;i<nbp;i++){ u64 q=bp[i]; if(q*q>s0+2*(len-1)) break; u64 f=((s0+q-1)/q)*q; if(f<q*q) f=q*q; if(!(f&1)) f+=q; for(u64 j=(f-s0)/2;j<len;j+=q) s[j]=0; }
    for(u64 j=0;j<len;j++) if(s[j]){ u64 p=s0+2*j;
      if(pass==1){ st.cnt++; if(st.cnt&1) st.sodd+=p; else st.seven+=p; st.q+=(u128)p*p; st.sall+=p; }
      else { I++; Q+=(u128)p*p; Sa+=p; if(!(I&1)){ if(Sa%(u128)I==I/2){pthread_mutex_lock(&mu);printf("A263076 n=%llu p=%llu\n",I,p);fflush(stdout);pthread_mutex_unlock(&mu);} Se+=p; u64 jj=I/2; if(Se%(u128)jj==0){pthread_mutex_lock(&mu);printf("A263546 j=%llu p=%llu\n",jj,p);fflush(stdout);pthread_mutex_unlock(&mu);} }
        if(((Q+1)%(u128)(I+1))==0){pthread_mutex_lock(&mu);printf("A153022 k=%llu p=%llu\n",I,p);fflush(stdout);pthread_mutex_unlock(&mu);}
        for(int d=0;d<nd;d++) if(dump[d]==I){pthread_mutex_lock(&mu);printf("DUMP i=%llu p=%llu Q=",I,p);pr128(stdout,Q);printf("\n");fflush(stdout);pthread_mutex_unlock(&mu);} } } }
  if(pass==1) ps[c]=st; else if(I!=start[c].cnt+ps[c].cnt) fprintf(stderr,"count mismatch chunk %d\n",c); }
static void*w(void*_){ unsigned char*s=malloc(SEG); for(;;){ pthread_mutex_lock(&mu); int c=nextc++; pthread_mutex_unlock(&mu); if(c>=NC) break; chunk(c,s);} free(s); return 0; }
int main(int argc,char**argv){ HI=strtoull(argv[1],0,10); CH=strtoull(argv[2],0,10); T=atoi(argv[3]); for(int i=4;i<argc;i++) dump[nd++]=strtoull(argv[i],0,10);
  NC=(HI+CH-1)/CH; ps=calloc(NC,sizeof(St)); start=calloc(NC,sizeof(St));
  u64 L=(u64)sqrtl((long double)HI)+2; char*cp=calloc(L+1,1); bp=malloc(4*L); for(u64 i=3;i<=L;i+=2) if(!cp[i]){ bp[nbp++]=i; for(u64 j=i*i;j<=L;j+=2*i) cp[j]=1; }
  pthread_t th[64];
  for(pass=1;pass<=2;pass++){ if(pass==2){ u64 I=0; u128 Se=0,Q=0,Sa=0; for(int c=0;c<NC;c++){ start[c].cnt=I; start[c].seven=Se; start[c].q=Q; start[c].sall=Sa; Sa+=ps[c].sall;
        // local odd positions are global odd iff I is even
        Se += (I%2==0)? ps[c].seven : ps[c].sodd; I+=ps[c].cnt; Q+=ps[c].q; }
      printf("pi(HI)=%llu Seven=",I); pr128(stdout,Se); printf(" Q="); pr128(stdout,Q); printf(" Sall="); pr128(stdout,Sa); printf("\n"); fflush(stdout); }
    nextc=0; for(int t=0;t<T;t++) pthread_create(&th[t],0,w,0); for(int t=0;t<T;t++) pthread_join(th[t],0); printf("pass %d done\n",pass); fflush(stdout); }
  return 0; }
