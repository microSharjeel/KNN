#define PHI 0x9e3779b9
//#define CMWC_CYCLE 4096
#define CMWC_CYCLE 256

/* Seed the pseudo-random number generator. */
/* This is shared by all functions. */
void random_init(unsigned int seed);

/* Multiply-with-carry pseudorandom number generator */
/* See https://stackoverflow.com/q/12884351 */
/* See https://en.wikipedia.org/wiki/Multiply-with-carry#Implementation */
unsigned int cmwc_rand(void);

