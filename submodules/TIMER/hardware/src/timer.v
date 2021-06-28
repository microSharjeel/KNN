`timescale 1ns/1ps
/* `include "include/iob_lib.vh"
`include "include/Timer_Header.vh" */
`include "iob_lib.vh"
`include "Timer_Header.vh"
`include "TIMERsw_reg.vh"
//Free runnning timer version with wrap
module	timer
(
	`INPUT(TIMER_EN,`TIMER_ENABLE_W),
	`INPUT(WRAP_H,`WDATA_W),
	`INPUT(WRAP_L,`WDATA_W),
	`INPUT(TIMER_S,1),
	`OUTPUT(TIMER_COUNT, (`TIMER_LOW_DW+`TIMER_HIGH_DW)),
	`INPUT(clk, 1),
    	`INPUT(rst, 1)
);
	//defining the counter register
	`SIGNAL(counter,`TIMER_WIDTH)
	`SIGNAL(wrap,`TIMER_WIDTH)
	`SIGNAL(timer_sample,`TIMER_WIDTH)
	//defining counter with async reset and enable
	//`COUNTER_ARE(clk,rst,TIMER_EN,counter)
	`COMB wrap={WRAP_H,WRAP_L};
	`WRAPCNT_ARE(clk, rst,TIMER_EN, counter, wrap)
	`REG_RE(clk,rst,1, TIMER_S, timer_sample,counter)
	`SIGNAL2OUT(TIMER_COUNT,timer_sample)	
		
endmodule
