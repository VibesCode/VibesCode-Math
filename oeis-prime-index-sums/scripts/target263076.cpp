// Independent check for A263076 at fixed even k: (sum of first k primes) mod k accumulated in 64-bit from the first prime.
#include <primesieve.hpp>
#include <cstdio>
#include <cstdlib>
#include <cstdint>
#include <vector>
typedef uint64_t u64;
int main(int c,char**v){ std::vector<u64> T; for(int i=1;i<c;i++) T.push_back(strtoull(v[i],0,10));
  std::vector<u64> acc(T.size(),0); u64 kmax=0; for(u64 t:T) if(t>kmax) kmax=t;
  primesieve::iterator it; u64 p,k=0;
  while(k<kmax){ p=it.next_prime(); k++;
    for(size_t i=0;i<T.size();i++) if(k<=T[i]){ acc[i]=(acc[i]+p%T[i])%T[i];
      if(k==T[i]){ printf("k=%llu p=%llu S mod k = %llu (k/2 = %llu)\n",(unsigned long long)k,(unsigned long long)p,(unsigned long long)acc[i],(unsigned long long)(k/2)); fflush(stdout);} } } }
