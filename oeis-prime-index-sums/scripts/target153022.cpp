// Independent check for A153022 at fixed k: for each target k, accumulate Q mod (k+1) with 64-bit mulmod while
// iterating primes; at index k report (Q_k + 1) mod (k+1) and p_k. No u128 running sums, no prefix state.
#include <primesieve.hpp>
#include <cstdio>
#include <cstdlib>
#include <cstdint>
#include <vector>
typedef unsigned __int128 u128; typedef uint64_t u64;
int main(int c,char**v){ std::vector<u64> T; for(int i=1;i<c;i++) T.push_back(strtoull(v[i],0,10));
  std::vector<u64> acc(T.size(),0); u64 kmax=0; for(u64 t:T) if(t>kmax) kmax=t;
  primesieve::iterator it; u64 p,k=0;
  while(k<kmax){ p=it.next_prime(); k++;
    for(size_t i=0;i<T.size();i++) if(k<=T[i]){ u64 m=T[i]+1; u64 pm=p%m; acc[i]=(u64)((acc[i]+(u128)pm*pm)%m);
        if(k==T[i]) printf("k=%llu p=%llu (Q+1) mod (k+1) = %llu\n",(unsigned long long)k,(unsigned long long)p,(unsigned long long)((acc[i]+1)%m)); } }
}
