#include "interconnect.h"
#include "timer.h"
#include "TIMERsw_reg.h"
#include <stdint.h>
#include <stdio.h>
//base address
//IO_SET(start, TIMER_RESET, value)
//IO_GET(start, TIMER_DATA_HIGH)
static uint32_t start_addr;
uint64_t timer_count;
uint32_t timer_half;


void timer_soft_rst(void) {	
  short int val=1;
 
  IO_SET(start_addr, TIMER_RESET, val);
  val=0;
  IO_SET(start_addr, TIMER_RESET, val);

}

void timer_enable(void) {	
  short int val=1;  
    IO_SET(start_addr, TIMER_ENABLE, val);
}
void timer_wrap(void)
{
  uint64_t wrap=0;
  IO_SET(start_addr,TIMER_WRAP_HIGH , wrap);
  wrap=~0;
  IO_SET(start_addr,TIMER_WRAP_LOW , wrap);	
}
void timer_disable(void) {	
   short int val=0;  
   IO_SET(start_addr, TIMER_ENABLE, val);
}


void timer_init(uint32_t base_address) {
  //capture base address for good
  start_addr = base_address;
  timer_soft_rst();
  timer_wrap();
  timer_enable();
}

uint64_t timer_get_count(void)
 {
   short int val=1;
  // sample timer
  IO_SET(start_addr, TIMER_SAMPLE, val);
  val=0; 
  IO_SET(start_addr, TIMER_SAMPLE, val);
   
  // get count
  timer_half = (unsigned int) IO_GET(start_addr, TIMER_DATA_HIGH);
  timer_count=timer_half;
  timer_half  =  (unsigned int)  IO_GET(start_addr, TIMER_DATA_LOW);
  timer_count<<=32;
  timer_count = timer_count|timer_half;
  return  timer_count;
} 


unsigned int timer_time_sec() {

  //get time count
  uint64_t  timer_total = timer_get_count();

  unsigned long long time_tu = (timer_total)/(long long) FREQ;
 
  return (unsigned int) time_tu;
}

unsigned int timer_time_usec() {

  //get time count
  uint64_t  timer_total = timer_get_count();

  unsigned long long time_tu = (timer_total)/((long long) FREQ/1000000);
 
  return (unsigned int) time_tu;
}

