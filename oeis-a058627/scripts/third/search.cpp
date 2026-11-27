// Third, separately written search for A058627 (phi(n) = digit product), k digits, k<=36.
#include <bits/stdc++.h>
typedef unsigned __int128 U; typedef long double LD;
struct Q{int e[4]; U q; LD lr;};
std::vector<Q> QS; const int PR[4]={2,3,5,7};
U P10[40]; U pw(U b,int e){U r=1;while(e--)r*=b;return r;}
int K; U LO,HI,PV; std::vector<int> cand; std::vector<LD> suf; unsigned long long nodes=0; std::vector<U> hits;
const LD C=8.2586L;
bool dp(U n){U p=1; while(n){int d=n%10; if(!d)return false; p*=d; if(p>PV) return false; n/=10;} return p==PV;}
void leafA(U B,const int*r){
  // solve phi(A)=R, A=2^x3^y5^z7^w
  for(int w0=0;w0<2;w0++){ int w; int r2=r[0],r3=r[1],r5=r[2],r7=r[3];
    if(r7>0){ if(w0) continue; w=r7+1;} else w=w0;
    if(w>=1){ r2-=1; r3-=1; }
    for(int z0=0;z0<2;z0++){ int z; int s2=r2,s3=r3;
      if(r5>0){ if(z0) continue; z=r5+1;} else z=z0;
      if(z>=1) s2-=2;
      if(s3<0) continue;
      for(int y0=0;y0<2;y0++){ int y; int t2=s2;
        if(s3>0){ if(y0) continue; y=s3+1;} else y=y0;
        if(y>=1) t2-=1;
        if(t2<0) continue;
        for(int x0=0;x0<2;x0++){ int x;
          if(t2>0){ if(x0) continue; x=t2+1;} else x=x0;
          LD l=x*logl(2)+y*logl(3)+z*logl(5)+w*logl(7)+logl((LD)B);
          if(l>logl((LD)HI)+1e-9) continue;
          U n=B*pw(2,x)*pw(3,y)*pw(5,z)*pw(7,w);
          if(n>=LO && n<HI && dp(n)) hits.push_back(n);
        }}}}
}
void dfs(size_t i,U B,int*r){
  nodes++;
  U R=pw(2,r[0])*pw(3,r[1])*pw(5,r[2])*pw(7,r[3]);
  // n >= B*R ; if B*R >= HI stop (monotone)
  if((LD)B*(LD)R >= (LD)HI*(1+1e-12L)) return;
  if(logl((LD)B)+logl((LD)R)+suf[i]+logl(35.0L/8) < logl((LD)LO)-1e-9) return;
  leafA(B,r);
  for(size_t j=i;j<cand.size();j++){ const Q&q=QS[cand[j]];
    bool ok=true; for(int t=0;t<4;t++) if(q.e[t]>r[t]){ok=false;break;}
    if(!ok) continue;
    if((LD)B*(LD)q.q>(LD)HI*1.000001L) continue;
    int r2[4]; for(int t=0;t<4;t++) r2[t]=r[t]-q.e[t];
    dfs(j+1,B*q.q,r2);
  }
}
int main(int argc,char**argv){
  int k1=atoi(argv[1]),k2=atoi(argv[2]);
  P10[0]=1; for(int i=1;i<40;i++) P10[i]=P10[i-1]*10;
  FILE*f=fopen("q.txt","r"); int a,b,c,d;
  while(fscanf(f,"%d %d %d %d",&a,&b,&c,&d)==4){Q q; q.e[0]=a;q.e[1]=b;q.e[2]=c;q.e[3]=d; U s=pw(2,a)*pw(3,b)*pw(5,c)*pw(7,d); q.q=s+1; q.lr=logl((LD)q.q/(LD)s); QS.push_back(q);}
  for(K=k1;K<=k2;K++){
    LO=P10[K-1]; HI=P10[K];
    // digit-product candidates P >= LO/C
    std::set<std::array<int,4>> Ps;
    LD need=logl((LD)LO)-logl(C)-1e-9;
    int ex[10][4]={{0},{0,0,0,0},{1,0,0,0},{0,1,0,0},{2,0,0,0},{0,0,1,0},{1,1,0,0},{0,0,0,1},{3,0,0,0},{0,2,0,0}};
    std::function<void(int,int,LD,std::array<int,4>)> rec=[&](int dig,int left,LD lp,std::array<int,4> e){
      if(lp+left*logl((LD)dig) < need) return;
      if(left==0){ Ps.insert(e); return;}
      if(dig==1){ rec(0,0,lp,e); return;}
      if(dig==0) return;
      for(int x=left;x>=0;x--){ auto e2=e; for(int t=0;t<4;t++) e2[t]+=x*ex[dig][t]; rec(dig-1,left-x,lp+x*logl((LD)dig),e2);} };
    rec(9,K,0,{0,0,0,0});
    nodes=0; size_t nh0=hits.size();
    for(auto&e:Ps){
      PV=pw(2,e[0])*pw(3,e[1])*pw(5,e[2])*pw(7,e[3]);
      cand.clear();
      for(size_t j=0;j<QS.size();j++){ bool ok=true; for(int t=0;t<4;t++) if(QS[j].e[t]>e[t]){ok=false;break;} if(ok && QS[j].q<=HI) cand.push_back(j);}
      std::reverse(cand.begin(),cand.end()); // largest first
      suf.assign(cand.size()+1,0); for(int j=(int)cand.size()-1;j>=0;j--) suf[j]=suf[j+1]+QS[cand[j]].lr;
      int r[4]={e[0],e[1],e[2],e[3]};
      dfs(0,1,r);
    }
    printf("k=%d P=%zu nodes=%llu hits:",K,Ps.size(),nodes);
    std::sort(hits.begin()+nh0,hits.end()); hits.erase(std::unique(hits.begin()+nh0,hits.end()),hits.end());
    for(size_t i=nh0;i<hits.size();i++){ unsigned long long v=(unsigned long long)hits[i]; printf(" %llu",v);} printf("\n"); fflush(stdout);
  }
}
