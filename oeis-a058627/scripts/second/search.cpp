// Independent exhaustive search for A058627: phi(n) = product of decimal digits of n, n < 10^KMAX.
// Soundness notes (all pruning justified):
//  (F1) digit 0 impossible; P = digit product = 2^a3^b5^c7^d.
//  (F2) every prime p|n has p-1 | P ; p>7 appears to exponent 1 (else p|P).  So n = prod p^e with
//       phi(n)=P tracked EXACTLY as exponent vector rem (no rounding), n/phi(n)=prod p/(p-1).
//  (F3) n/phi(n) <= 8.2586 (given) -> n <= 8.26 P ; also n >= phi(n) = P.
//  Per-k window: n in [10^(k-1), 10^k-1]. P must satisfy: P<=9^k (k digits), P needs mindig(P)<=k digits
//  (exact DP over digits 2,3,4,6,8,9 for 2^a3^b plus one digit per factor 5 or 7), and 8.26P>=10^(k-1).
//  DFS over primes (descending) building n with remaining totient rem (exponent vector):
//   (a) rem odd and >1 -> dead (every odd prime / 2^e,e>=2 contributes even phi except 2^1 which gives 1).
//   (b) rem <= M[j] = product over remaining candidate primes of max phi contribution -> else dead (sound: each
//       remaining prime used contributes phi factor <= (p-1) [p>7] or <= (p-1)*p^{expo of p in P} [p<=7]).
//   (c) n' >= rem  (n'>=phi(n')) so cur*rem <= hi required.
//   (d) n' = rem * prod p/(p-1) over the remaining chosen primes <= rem * S[j] (S = product over ALL remaining
//       candidates, min'd with 8.26) so cur*rem*S[j] >= lo required.
//  Logs in long double with eps 1e-9 slack (only makes pruning weaker -> sound).
//  Candidate primes: p with p-1 7-smooth, p-1 <= 9^41, probable prime by OpenSSL BN_check_prime (true primes always pass).
//  Leaves: exact U256 n; digit count == k, no zero digit, digit product == P (exact exponent vector).  Reported terms
//  re-verified: factorization multiplied back, phi from factorization, digit product by full arithmetic.
#include <bits/stdc++.h>
#include <openssl/bn.h>
#include <omp.h>
using namespace std;
typedef long double ld; typedef unsigned long long u64; typedef unsigned __int128 u128;
struct U { u64 w[4]; };
static U uone(){U r={{1,0,0,0}};return r;}
static U umul(const U&a,const U&b){u64 r[4]={0,0,0,0};for(int i=0;i<4;i++){u64 c=0;for(int j=0;i+j<4;j++){u128 t=(u128)a.w[i]*b.w[j]+r[i+j]+c;r[i+j]=(u64)t;c=(u64)(t>>64);}}U x;memcpy(x.w,r,32);return x;}
static U umulw(const U&a,u64 b){U B={{b,0,0,0}};return umul(a,B);}
static u64 udivw(U&a,u64 d){u128 rem=0;for(int i=3;i>=0;i--){u128 cur=(rem<<64)|a.w[i];a.w[i]=(u64)(cur/d);rem=cur%d;}return (u64)rem;}
static bool uiszero(const U&a){return !(a.w[0]|a.w[1]|a.w[2]|a.w[3]);}
static string utos(U a){if(uiszero(a))return "0";string s;while(!uiszero(a)){u64 r=udivw(a,10);s+=char('0'+r);}reverse(s.begin(),s.end());return s;}
static const int PR[4]={2,3,5,7};
static const ld LP[4]={logl(2),logl(3),logl(5),logl(7)};
struct Pr{int v[4];ld lp,lphi;int small;U p;};
static vector<Pr> G; // sorted by p descending
static int KMAX=41;
static const ld EPS=1e-9L, RMAX=8.26L;
// min digits table
static int md[200][130];
static void mdinit(){const int dg[6][3]={{2,1,0},{3,0,1},{4,2,0},{6,1,1},{8,3,0},{9,0,2}};
  for(int a=0;a<200;a++)for(int b=0;b<130;b++)md[a][b]=1000;md[0][0]=0;
  for(int a=0;a<200;a++)for(int b=0;b<130;b++){if(!a&&!b)continue;int best=1000;for(auto&d:dg){int pa=a-d[1],pb=b-d[2];if(pa>=0&&pb>=0)best=min(best,md[pa][pb]+1);}md[a][b]=best;}}
static void buildG(){
  string cache="primes_"+to_string(KMAX)+".txt";
  ld lim=KMAX*logl(9.0L)+1e-6L;
  BN_CTX*ctx=BN_CTX_new();
  vector<array<int,4>> found;
  FILE*f=fopen(cache.c_str(),"r");
  if(f){int a,b,c,d;while(fscanf(f,"%d %d %d %d",&a,&b,&c,&d)==4)found.push_back({a,b,c,d});fclose(f);}
  else{
    for(int a=0;a<=140;a++)for(int b=0;b<=90;b++)for(int c=0;c<=60;c++)for(int d=0;d<=50;d++){
      ld l=a*LP[0]+b*LP[1]+c*LP[2]+d*LP[3]; if(l>lim)break;
      if(a==0&&!(b==0&&c==0&&d==0))continue; // d+1 even needed unless d=1 (p=2)
      U x=uone();for(int i=0;i<a;i++)x=umulw(x,2);for(int i=0;i<b;i++)x=umulw(x,3);for(int i=0;i<c;i++)x=umulw(x,5);for(int i=0;i<d;i++)x=umulw(x,7);
      x=U{{x.w[0]+1,x.w[1],x.w[2],x.w[3]}}; // no carry possible issue: handle
      if(x.w[0]==0){x.w[1]++;}
      string s=utos(x);BIGNUM*bn=NULL;BN_dec2bn(&bn,s.c_str());
      int r=BN_check_prime(bn,ctx,NULL);BN_free(bn);
      if(r==1)found.push_back({a,b,c,d});
    }
    f=fopen(cache.c_str(),"w");for(auto&q:found)fprintf(f,"%d %d %d %d\n",q[0],q[1],q[2],q[3]);fclose(f);
  }
  for(auto&q:found){Pr p;for(int i=0;i<4;i++)p.v[i]=q[i];U x=uone();for(int i=0;i<q[0];i++)x=umulw(x,2);for(int i=0;i<q[1];i++)x=umulw(x,3);for(int i=0;i<q[2];i++)x=umulw(x,5);for(int i=0;i<q[3];i++)x=umulw(x,7);
    p.lphi=q[0]*LP[0]+q[1]*LP[1]+q[2]*LP[2]+q[3]*LP[3];
    x.w[0]++; if(x.w[0]==0)x.w[1]++; p.p=x;
    // log p exactly-ish: log(p) = lphi + log1p(1/(p-1))
    p.lp=logl(expl(p.lphi)+1.0L); if(p.lphi>600)p.lp=p.lphi; else p.lp=p.lphi+log1pl(expl(-p.lphi));
    p.small=-1;if(x.w[1]==0&&x.w[2]==0&&x.w[3]==0){for(int i=0;i<4;i++)if(x.w[0]==(u64)PR[i])p.small=i;}
    G.push_back(p);}
  sort(G.begin(),G.end(),[](const Pr&a,const Pr&b){return a.lp>b.lp;});
  BN_CTX_free(ctx);
}
struct Task{int a,b,c,d;};
struct Ctx{
  int Pe[4]; ld lP; vector<int> L; vector<ld> M,S; vector<ld> lph; ld llo,lhi; int k; U lo,hi;
  vector<pair<int,int>> st; // (L index, e)
  u64 nodes=0,leaves=0; vector<U> terms; vector<vector<pair<int,int>>> tfac;
  int pos2;
  vector<ld> CC,CG,CGc; vector<ld> ilo,ihi; };
static bool digcheck(const U&n,int k,const int Pe[4],Ctx&C){
  // returns true if n has exactly k digits, no zeros, digit product == P
  U x=n;int cnt[10]={0};int len=0;
  while(!uiszero(x)){int r=udivw(x,10);cnt[r]++;len++;}
  if(len!=k)return false; // counted elsewhere
  C.leaves++;
  if(cnt[0])return false;
  int a=cnt[2]+2*cnt[4]+cnt[6]+3*cnt[8],b=cnt[3]+cnt[6]+2*cnt[9],c=cnt[5],d=cnt[7];
  return a==Pe[0]&&b==Pe[1]&&c==Pe[2]&&d==Pe[3];
}
static int digitsOf(const U&n){U x=n;int l=0;while(!uiszero(x)){udivw(x,10);l++;}return l;}
static void leaf(Ctx&C,U n){
  if(digcheck(n,C.k,C.Pe,C)){C.terms.push_back(n);C.tfac.push_back(C.st);}
}
static U curN(Ctx&C){U n=uone();for(auto&s:C.st){const Pr&p=G[C.L[s.first]];for(int i=0;i<s.second;i++)n=umul(n,p.p);}return n;}
static void dfs(Ctx&C,int j,const int*rem,ld lncur){
  C.nodes++;
  ld lrem=0;bool one=true;for(int i=0;i<4;i++){lrem+=rem[i]*LP[i];if(rem[i])one=false;}
  int len=C.L.size();
  if(one){
    U n=curN(C);leaf(C,n);
    bool used2=false;for(auto&s:C.st)if(G[C.L[s.first]].small==0)used2=true;
    if(!used2){int t2=-1;for(int q=0;q<(int)C.L.size();q++)if(G[C.L[q]].small==0)t2=q;C.st.push_back({t2,1});leaf(C,umulw(n,2));C.st.pop_back();}
    return;
  }
  if(rem[0]==0)return;
  if(j>=len)return;
  if(lrem>C.M[j]+EPS)return;
  ld s=min(C.S[j],logl(RMAX));
  { // tight knapsack bound on log(n'/rem): chosen distinct primes have sum ln(p-1)<=lrem, gain ln(p/(p-1)); greedy by efficiency (ascending p) is a valid fractional-knapsack upper bound
    int mmax=len-j; int lo2=0,hi2=mmax; // largest m<=mmax with CC[m]<=lrem+EPS
    while(lo2<hi2){int m=(lo2+hi2+1)/2; if(C.CC[m]<=lrem+EPS)lo2=m; else hi2=m-1;}
    ld g=C.CG[lo2];
    if(lo2<mmax){int it=len-1-lo2; const Pr&q=G[C.L[it]]; ld cost=q.lphi, gain=q.lp-q.lphi; ld fr=(lrem-C.CC[lo2])/cost; if(fr>1)fr=1; if(fr<0)fr=0; g+=gain*fr;}
    if(g<s)s=g; }
  if(lncur+lrem+s<C.llo-EPS)return;
  if(lncur+lrem>C.lhi+EPS)return;
  { ld a=lncur+lrem-EPS,b=lncur+lrem+s+EPS; // some allowed leading-digit interval must meet [a,b]
    int lo3=0,hi3=C.ihi.size(); while(lo3<hi3){int m=(lo3+hi3)/2; if(C.ihi[m]>=a)hi3=m; else lo3=m+1;}
    if(lo3==(int)C.ihi.size()||C.ilo[lo3]>b)return; }
  // binary search start: first t>=j with lph[t]<=lrem+EPS
  int lo=j,hi=len;while(lo<hi){int m=(lo+hi)/2;if(C.lph[m]<=lrem+EPS)hi=m;else lo=m+1;}
  for(int t=lo;t<len;t++){
    if(lrem>C.M[t]+EPS)break;
    const Pr&p=G[C.L[t]];
    bool ok=true;for(int i=0;i<4;i++)if(p.v[i]>rem[i]){ok=false;break;}
    if(!ok)continue;
    int nr[4];for(int i=0;i<4;i++)nr[i]=rem[i]-p.v[i];
    int f=0;
    while(true){
      // exponent e=f+1 (f extra only for small primes)
      ld ln=lncur+p.lp*(f+1);
      C.st.push_back({t,f+1});
      dfs(C,t+1,nr,ln);
      C.st.pop_back();
      if(p.small<0)break;
      if(nr[p.small]<1)break;
      nr[p.small]--;f++;
    }
  }
}
// exact verification of a reported term
static bool verify(const U&n,const vector<pair<int,int>>&fac,Ctx&C,string&desc){
  // multiply back
  U m=uone();U phi=uone();BN_CTX*ctx=BN_CTX_new();bool ok=true;
  for(auto&s:fac){const Pr&p=G[C.L[s.first]];int e=s.second;
    BIGNUM*bn=NULL;BN_dec2bn(&bn,utos(p.p).c_str());if(BN_check_prime(bn,ctx,NULL)!=1)ok=false;BN_free(bn);
    if(e>1&&p.small<0)ok=false;
    U pe=uone();for(int i=0;i<e;i++)pe=umul(pe,p.p);m=umul(m,pe);
    // phi(p^e)=p^(e-1)(p-1)
    U ph=uone();for(int i=0;i<e-1;i++)ph=umul(ph,p.p);U pm1=p.p;pm1.w[0]--; // p>=2, w0>=... borrow impossible when p.w0>0
    if(p.p.w[0]==0){ok=false;}
    ph=umul(ph,pm1);phi=umul(phi,ph);
    desc+=utos(p.p)+"^"+to_string(e)+" ";}
  BN_CTX_free(ctx);
  if(memcmp(m.w,n.w,32))ok=false;
  string s=utos(n);U dp=uone();for(char ch:s){if(ch=='0')ok=false;dp=umulw(dp,ch-'0');}
  if(memcmp(dp.w,phi.w,32))ok=false;
  desc="phi="+utos(phi)+" digprod="+utos(dp)+" fac: "+desc;
  return ok;
}
int main(int argc,char**argv){
  int k1=1,k2=41; if(argc>1)k2=atoi(argv[1]); if(argc>2)k1=atoi(argv[2]); KMAX=41;
  omp_set_num_threads(2);
  mdinit();buildG();
  fprintf(stderr,"candidate primes: %zu\n",G.size());
  auto T0=chrono::steady_clock::now();
  vector<U> allterms;
  for(int k=k1;k<=k2;k++){
    auto t0=chrono::steady_clock::now();
    vector<Task> tasks;
    ld lk9=k*logl(9.0L),lk10=(k-1)*logl(10.0L);
    for(int a=0;a<200;a++){ld la=a*LP[0];if(la>lk9+EPS)break;
      for(int b=0;b<130;b++){ld lb=la+b*LP[1];if(lb>lk9+EPS)break;
        if(md[a][b]>k)continue;
        for(int c=0;c<80;c++){ld lc=lb+c*LP[2];if(lc>lk9+EPS)break;
          for(int d=0;d<60;d++){ld l=lc+d*LP[3];if(l>lk9+EPS)break;
            if(md[a][b]+c+d>k)continue;
            if(l+logl(RMAX)<lk10-EPS)continue;
            tasks.push_back({a,b,c,d});}}}}
    u64 nodes=0,leaves=0;vector<pair<U,string>> found;
    size_t T=tasks.size();
    #pragma omp parallel
    {
      Ctx C;C.k=k;
      // n window
      U lo=uone();for(int i=0;i<k-1;i++)lo=umulw(lo,10);C.lo=lo;
      C.llo=(k-1)*logl(10.0L);C.lhi=k*logl(10.0L);
      vector<pair<U,string>> myfound;
      #pragma omp for schedule(dynamic,1)
      for(size_t ti=0;ti<T;ti++){
        Task&tk=tasks[ti];C.Pe[0]=tk.a;C.Pe[1]=tk.b;C.Pe[2]=tk.c;C.Pe[3]=tk.d;
        C.lP=tk.a*LP[0]+tk.b*LP[1]+tk.c*LP[2]+tk.d*LP[3];
        C.L.clear();for(size_t g=0;g<G.size();g++){bool ok=true;for(int i=0;i<4;i++)if(G[g].v[i]>C.Pe[i]){ok=false;break;}if(ok)C.L.push_back(g);}
        int len=C.L.size();C.M.assign(len+1,0);C.S.assign(len+1,0);C.lph.assign(len,0);
        for(int i=len-1;i>=0;i--){const Pr&p=G[C.L[i]];ld m=p.lphi;if(p.small>=0)m+=C.Pe[p.small]*LP[p.small];C.M[i]=C.M[i+1]+m;C.S[i]=C.S[i+1]+(p.lp-p.lphi);C.lph[i]=p.lphi;}
        // window for n: lower max(P,10^(k-1)) handled by llo and lrem; upper from 8.26 P
        // use llo=(k-1)ln10 ; hi: n<10^k
        C.CC.assign(len+1,0);C.CG.assign(len+1,0);
        for(int m=1;m<=len;m++){const Pr&q=G[C.L[len-m]];C.CC[m]=C.CC[m-1]+q.lphi;C.CG[m]=C.CG[m-1]+(q.lp-q.lphi);}
        // allowed leading-digit prefixes (necessary conditions: remaining exponents formable with remaining digits (exact DP), product exactly P)
        {
          struct Pf{u64 v;int e[4];ld cost;};
          vector<Pf> cur,nxt;Pf r0;r0.v=0;for(int i=0;i<4;i++)r0.e[i]=C.Pe[i];r0.cost=0;cur.push_back(r0);
          ld BP=k*logl(10.0L)-C.lP; ld c9=logl(10.0L/9.0L);
          const int dga[10]={0,0,1,0,2,0,1,0,3,0},dgb[10]={0,0,0,1,0,0,1,0,0,2},dgc[10]={0,0,0,0,0,1,0,0,0,0},dgd[10]={0,0,0,0,0,0,0,1,0,0};
          int depth=0;const int JMAX=10;const size_t CAP=400000;
          while(depth<k&&depth<JMAX){
            nxt.clear();
            for(auto&q:cur)for(int dd=1;dd<=9;dd++){
              int e0=q.e[0]-dga[dd]; int e1=q.e[1]-dgb[dd]; int e2=q.e[2]-dgc[dd]; int e3=q.e[3]-dgd[dd];
              if(e0<0||e1<0||e2<0||e3<0)continue;
              if(md[e0][e1]+e2+e3>k-depth-1)continue;
              ld cost=q.cost+logl(10.0L/dd);
              if(cost+(k-depth-1)*c9>BP+1e-9L)continue;
              Pf z;z.v=q.v*10+dd;z.e[0]=e0;z.e[1]=e1;z.e[2]=e2;z.e[3]=e3;z.cost=cost;nxt.push_back(z);
            }
            if(nxt.size()>CAP&&depth>0)break;
            cur.swap(nxt);depth++;
          }
          C.ilo.clear();C.ihi.clear();
          ld sh=(k-depth)*logl(10.0L);
          for(auto&q:cur){ld lo_=logl((ld)q.v)+sh-1e-12L,hi_=logl((ld)q.v+1)+sh+1e-12L;
            if(!C.ilo.empty()&&lo_<=C.ihi.back()+1e-12L){C.ihi.back()=hi_;}else{C.ilo.push_back(lo_);C.ihi.push_back(hi_);}}
          if(C.ilo.empty())continue;
        }
        C.st.clear();
        size_t before=C.terms.size();
        dfs(C,0,C.Pe,0);
        for(size_t q=before;q<C.terms.size();q++){string d;bool ok=verify(C.terms[q],C.tfac[q],C,d);
          myfound.push_back({C.terms[q],(ok?"VERIFIED ":"FAILED ")+d});}
      }
      #pragma omp critical
      {nodes+=C.nodes;leaves+=C.leaves;for(auto&x:myfound)found.push_back(x);}
    }
    sort(found.begin(),found.end(),[](const pair<U,string>&a,const pair<U,string>&b){for(int i=3;i>=0;i--)if(a.first.w[i]!=b.first.w[i])return a.first.w[i]<b.first.w[i];return false;});
    double secs=chrono::duration<double>(chrono::steady_clock::now()-t0).count();
    printf("k=%d P_candidates=%zu dfs_nodes=%llu examined_k-digit_n_with_phi=P:%llu terms=%zu time=%.1fs\n",k,T,nodes,leaves,found.size(),secs);
    for(auto&x:found)printf("  TERM %s  %s\n",utos(x.first).c_str(),x.second.c_str());
    fflush(stdout);
  }
  printf("total time %.1fs\n",chrono::duration<double>(chrono::steady_clock::now()-T0).count());
}
