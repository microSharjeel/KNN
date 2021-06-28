#include "stdint.h"
#pragma once

//Functions prototypes
void timer_soft_rst(void);
void timer_enable(void);	
void timer_disable(void);
void timer_init( uint32_t base_address);	
void timer_wrap(void);
uint64_t timer_get_count(void);
unsigned int timer_time_sec();
unsigned int timer_time_usec();
extern uint64_t timer_count;
extern uint32_t timer_half;
