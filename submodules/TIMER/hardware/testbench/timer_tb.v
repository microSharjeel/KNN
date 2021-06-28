`timescale 1ns/1ps
`include "iob_lib.vh"
`include "interconnect.vh"

module timer_tb;

   localparam PERIOD=10;
   
   `CLOCK(clk, PERIOD)
   `RESET(rst, 7, 10)
   `SIGNAL(TIMER_WRAP_HIGH,32)
   `SIGNAL(TIMER_WRAP_LOW,32) 	
   `SIGNAL(TIMER_ENABLE, 1)
   `SIGNAL(TIMER_SAMPLE, 1)
   `SIGNAL_OUT(TIMER_COUNT_TOP, 2*`DATA_W)
    timer timer_TOP
	(
	.TIMER_EN(TIMER_ENABLE),
	.WRAP_H(TIMER_WRAP_HIGH),
	.WRAP_L(TIMER_WRAP_LOW),
	.TIMER_S(TIMER_SAMPLE),
	.TIMER_COUNT(TIMER_COUNT_TOP),
	.clk(clk),
	.rst(rst)
	);
   initial begin

      $dumpfile("timer_core.vcd");
      $dumpvars(1,);
      $dumpfile("waveform.vcd");
      $dumpvars(3,TB_timer_reg_impl);
      TIMER_WRAP_HIGH <=32'd0;
      TIMER_WRAP_LOW  <=32'd0;
      TIMER_ENABLE    <=1'b0;
      TIMER_SAMPLE    <=1'b0;
	//reset
  @(posedge rst);
  @(negedge rst);	
//Enable timer
  @(posedge clk)
	begin
      #1 TIMER_ENABLE    <=1'b1;
      #1 TIMER_SAMPLE    <=1'b0;
      #1 TIMER_WRAP_HIGH <=32'd0;
      #1 TIMER_WRAP_LOW  <=32'd150;

	end

repeat(100) @(posedge clk);	
//sample timer	
  @(posedge clk)
	begin
      #1 TIMER_ENABLE    <=1'b1;
      #1 TIMER_SAMPLE    <=1'b1;
      #1 TIMER_WRAP_HIGH <=32'd0;
      #1 TIMER_WRAP_LOW  <=32'd150;
	end
   @(posedge clk)
	begin
      #1 TIMER_ENABLE    <=1'b1;
      #1 TIMER_SAMPLE    <=1'b0;
      #1 TIMER_WRAP_HIGH <=32'd0;
      #1 TIMER_WRAP_LOW  <=32'd150;

	end
//Enable timer
  @(posedge clk)
	begin
      #1 TIMER_ENABLE    <=1'b1;
      #1 TIMER_SAMPLE    <=1'b0;
      #1 TIMER_WRAP_HIGH <=32'd0;
      #1 TIMER_WRAP_LOW  <=32'd150;

	end

repeat(100) @(posedge clk);	
//sample timer	
  @(posedge clk)
	begin
      #1 TIMER_ENABLE    <=1'b1;
      #1 TIMER_SAMPLE    <=1'b1;
      #1 TIMER_WRAP_HIGH <=32'd0;
      #1 TIMER_WRAP_LOW  <=32'd150;
	end
   @(posedge clk)
	begin
      #1 TIMER_ENABLE    <=1'b1;
      #1 TIMER_SAMPLE    <=1'b0;
      #1 TIMER_WRAP_HIGH <=32'd0;
      #1 TIMER_WRAP_LOW  <=32'd150;

	end
 
   @(posedge clk)	
      #1 TIMER_ENABLE <= 1'b0;	
      repeat(20) @(posedge CLK_tb);
	
	$finish;
	
end	
endmodule


