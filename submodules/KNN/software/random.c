#include <stdint.h>
#include "random.h"

static unsigned int Q[CMWC_CYCLE], c = 362436;

void random_init(unsigned int seed){
    int i;

    Q[0] = seed;
    Q[1] = seed + PHI;
    Q[2] = seed + PHI + PHI;

    for (i = 3; i < CMWC_CYCLE; i++)
        Q[i] = Q[i - 3] ^ Q[i - 2] ^ PHI ^ i;
}

unsigned int cmwc_rand(void){
    uint64_t t, a = 18782LL;
    static uint32_t i = 4095;
    uint32_t x, r = 0xfffffffe;
    i = (i + 1) & 4095;
    t = a * Q[i] + c;
    c = (t >> 32);
    x = t + c;
    if (x < c) {
        x++;
        c++;
    }
    return (Q[i] = r - x);
}

