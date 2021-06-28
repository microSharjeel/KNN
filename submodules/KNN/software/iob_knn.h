#pragma once
 static int base;
//Functions
void knn_reset();
void knn_init( int base_address);
void knn_validin_set();
void knn_validin_reset();
void knn_start();
void knn_stop();
//void knn_wr_test( struct datum a);
//void knn_wr_data(struct datum a);
int knn_validout();
uint32_t knn_rd_data();

void knn_sample_data();

void knn_reset_data();
void knn_address_wr(short address);

#ifdef DEBUG //type make DEBUG=1 to print debug info
#define S 3  //random seed
#define N 127  //data set size
#define K 6   //number of neighbours (K)
#define C 4   //number data classes
#define M 10   //number samples to be classified
#else
#define S 12   
#define N 100000
#define K 10  
#define C 4  
#define M 100 
#endif
//#define INFINITE ~0
struct datum {
  short x;
  short y;
  unsigned char label;
} data[N], x[M];

//neighbor info
struct neighbor {
  uint32_t idx; //index in dataset array
  uint32_t dist; //distance to test point
} neighbor[K];
#define INFINITE ~0
uint32_t data_wrt=0;
int inc=1;
uint32_t data_wrd=0;
//volatile int valid;
uint32_t distance [127];
