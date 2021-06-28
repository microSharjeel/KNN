#include "system.h"
#include "periphs.h"
#include "iob-uart.h"
#include "printf.h"
#include "timer.h"

int main()
{
  unsigned long long cycles;
  uart_init(UART_BASE, FREQ/BAUD);  
  timer_init(TIMER_BASE);
  printf("\nHello world Sharjeel!\n");
  cycles=timer_get_count();
  unsigned int timer_val_sec = timer_time_sec();
  unsigned int timer_val_usec = timer_time_usec();
  printf("\nExecution time: %d clock cycles\n",(unsigned int)cycles );
  printf("\nExecution time: %d in secs and %d in usec @ Freq:%dMHz\n", timer_val_sec,timer_val_usec,(int )FREQ/1000000);
  timer_disable();
  uart_finish();

}
 // uart_init(UART_BASE, FREQ/BAUD);  
 // timer_init(TIMER_BASE);
 // printf("\nHello world!\n");
 // uint64_t* timer_val_clk= timer_get_count();
 // uint32_t timer_val_sec = timer_time_sec();
 // printf("\nExecution time: %d clock cycles\n", *timer_val_clk);
 // printf("\nExecution time: %d in secs\n", timer_val_sec);
 // timer_disable();
 // uart_finish();

}

