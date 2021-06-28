#include "system.h"
#include "periphs.h"
#include <iob-uart.h>
#include "timer.h"
#include "iob_knn.h"
#include "random.h" //random generator for bare metal
#include "printf.h" 
#include "stdint.h"
#include "KNNsw_reg.h"
#include "interconnect.h"

//uncomment to use rand from C lib 
#define cmwc_rand rand
//square distance between 2 points a and b
//unsigned int sq_dist( struct datum a, struct datum b) {
//  short X = a.x-b.x;
//  unsigned int X2=X*X;
//  short Y = a.y-b.y;
//  unsigned int Y2=Y*Y;
//  return (X2 + Y2);
//}

//insert element in ordered array of neighbours
void insert (struct neighbor element, unsigned int position) {
  for (int j=K-1; j>position; j--)
    neighbor[j] = neighbor[j-1];

  neighbor[position] = element;

}
//Base address of KNN HW

int main() {

  unsigned long long elapsed;
  unsigned long long elapsedua;
  unsigned long long elapsedub;

  //init uart and timer
  uart_init(UART_BASE, FREQ/BAUD);
  printf("\nInit timer\n");
  uart_txwait();

  timer_init(TIMER_BASE);
  //read current timer count, compute elapsed time
  //elapsed  = timer_get_count();   
  int votes_acc[C] = {0};
  //generate random seed 
  random_init(S);
   inc=0;
  //init dataset
  for (int i=0; i<N; i++) {

    //init coordinates
    data[i].x = (short)cmwc_rand();
    data[i].y = (short)cmwc_rand();
    inc= inc+1; 
   // printf("x:%d y:%d\n",data[i].x,data[i].y);
    //init label
    data[i].label = (unsigned char) (cmwc_rand()%C);
  }

//#ifdef DEBUG
//  printf("\n\n\nDATASET\n");
//  printf("Idx \tX \tY \tLabel\n");
 // for (int i=0; i<N; i++)
  //  printf("%d \t%d \t%d \t%d\n", i, data[i].x,  data[i].y, data[i].label);
//#endif
  inc=0;
  //init test points
  for (int k=0; k<M; k++) {
    x[k].x  = (short)cmwc_rand();
    x[k].y  = (short)cmwc_rand();
     inc= inc+1; 
    //x[k].label will be calculated by the algorithm
  }

//#ifdef DEBUG
//  printf("\n\nTEST POINTS\n");
//  printf("Idx \tX \tY\n");
 // for (int k=0; k<M; k++)
  //  printf("%d \t%d \t%d\n", k, x[k].x, x[k].y);
//#endif
    //init all k neighbors infinite distance
    for (int j=0; j<K; j++)
      neighbor[j].dist = INFINITE;
 elapsedua = timer_time_usec();
// PROCESS DATA
//start knn here
//soft reset for KNN core

  knn_init( KNN_BASE);
// WRITE DATA TO FPGA ONLY ONCE FOR ALL TEST POINTS
  knn_validin_set();
  data_wrd = 0;
  for(int i=0;i<N;i++)
  {
   data_wrd = 0;
   data_wrd = data[i].x;
   data_wrd <<=16;
   data_wrd |= data[i].y;
   IO_SET(base,KNN_DATA_PT,data_wrd);
   
     }
  knn_validin_reset();
  
  for (int k=0; k<M; k++) { 
	  //for all test points
	  //compute distances to dataset points

	#ifdef DEBUG
	    printf("\n\nProcessing x[%d]:\n", k);
	#endif
	#ifdef DEBUG
	    printf("Datum \tX \tY \tLabel \tDistance\n");
	#endif
	   data_wrt=0;
	   data_wrt = x[k].x;
	   data_wrt <<=16;
	   data_wrt |= x[k].y;
	   IO_SET(base,KNN_TEST_PT,data_wrt);
	  
	   knn_start();
	    
	   while(1)
	    {	
	       if(knn_validout())
	       {
		 printf("hi\n");
		 break;  		
	       }    
	     }
	   
	   knn_sample_data();
	   for (short ind=0;ind<=126;ind++)
	   {
		knn_address_wr(ind);
		 knn_sample_data();
		distance[ind] = knn_rd_data();
		printf("%d\n",distance[ind]);
	   }
	   knn_reset_data();
	   knn_stop();
	    
	    
	    for (int i=3; i<N; i++) { 
	    
	    //for all dataset points
	    //compute distance to x[k]
	    //  unsigned int d = sq_dist(x[k], data[i]);   
	    //insert in ordered list
	    for (int j=0; j<K; j++)
	        if ( distance[i] < neighbor[j].dist ) 
	        {
	         insert( (struct neighbor){i,distance[i]}, j);
	         break;
	        } 

	//#ifdef DEBUG
	    //dataset
	  //    printf("%d \t%d \t%d \t%d \t%u\n", i, data[i].x, data[i].y, data[i].label, (uint32_t)neighbor[i].dist);//d);
	//#endif

	    }
	      
	    //classify test point

	    //clear all votes
	    int votes[C] = {0};
	    int best_votation = 0;
	    int best_voted = 0;

	    //make neighbours vote
	    for (int j=0; j<K; j++) { //for all neighbors
	      if ( (++votes[data[neighbor[j].idx].label]) > best_votation ) {
		best_voted = data[neighbor[j].idx].label;
		best_votation = votes[best_voted];
	      }
    	}

	    x[k].label = best_voted;

	    votes_acc[best_voted]++;
	    
	#ifdef DEBUG
	    printf("\n\nNEIGHBORS of x[%d]=(%d, %d):\n", k, x[k].x, x[k].y);
	    printf("K \tIdx \tX \tY \tDist \t\tLabel\n");
	    for (int j=0; j<K; j++)
	      printf("%d \t%d \t%d \t%d \t%u \t%d\n", j+1, neighbor[j].idx, data[neighbor[j].idx].x,  data[neighbor[j].idx].y, 				neighbor[j].dist,  data[neighbor[j].idx].label);
	    
	    printf("\n\nCLASSIFICATION of x[%d]:\n", k);
	    printf("X \tY \tLabel\n");
	    printf("%d \t%d \t%d\n\n\n", x[k].x, x[k].y, x[k].label);

	#endif

  } //all test points classified

  //stop knn here
  //read current timer count, compute elapsed time
  elapsedub = timer_time_usec();
  printf("\nExecution time: %llu us %llu us @%dMHz\n\n", elapsedua,elapsedub, FREQ/1000000);

  
  //print classification distribution to check for statistical bias
  for (int l=0; l<C; l++)
    printf("%d ", votes_acc[l]);
  printf("\n");
 return 0; 
}

// functions definitions
void knn_reset()
{
  IO_SET(base, KNN_RESET, 1);
  IO_SET(base, KNN_RESET, 0);	
}

void knn_init( int base_address)
{
  base = base_address;
  knn_reset();
  knn_validin_reset();
}

void knn_validin_set()
{
 IO_SET(base,KNN_VALID_IN,1);
}

void knn_validin_reset()
{
 IO_SET(base,KNN_VALID_IN,0);
}

void knn_start()
{
 IO_SET(base,KNN_START,1);
 	
}

void knn_stop()
{
 IO_SET(base,KNN_START,0);	
}

 int   knn_validout ()
{
 return (int)IO_GET(base,KNN_VALID_OUT);	
}

uint32_t knn_rd_data()
{
  return (uint32_t) IO_GET(base,KNN_ADD); 
}

void knn_sample_data()
{
 IO_SET(base,KNN_SAMPLE,1);	
}

void knn_reset_data()
{
 IO_SET(base,KNN_SAMPLE,0);	
}
void knn_address_wr(short address)
{
 IO_SET(base,KNN_ADDR,address);	
}

