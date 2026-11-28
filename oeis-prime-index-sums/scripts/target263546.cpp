// Independent check for A263546 at fixed j: accumulate (sum of prime(2i), i<=j) mod j with 64-bit arithmetic only.
#include <primesieve.hpp>
#include <cstdio>
#include <cstdlib>
#include <cstdint>
#include <vector>
typedef uint64_t u64;
int main(int c,char**v){ std::vector<u64> T; for(int i=1;i<c;i++) T.push_back(strtoull(v[i],0,10));
  std::vector<u64> acc(T.size(),0); u64 jmax=0; for(u64 t:T) if(t>jmax) jmax=t;
  primesieve::iterator it; u64 p,k=0,j=0;
  while(j<jmax){ p=it.next_prime(); k++; if(k&1) continue; j++;
    for(size_t i=0;i<T.size();i++) if(j<=T[i]){ acc[i]=(acc[i]+p%T[i])%T[i];
        if(j==T[i]){ printf("j=%llu p=%llu sum mod j = %llu\n",(unsigned long long)j,(unsigned long long)p,(unsigned long long)acc[i]); fflush(stdout);} } }
}
