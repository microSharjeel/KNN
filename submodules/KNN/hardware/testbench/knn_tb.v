`timescale 1ns/1ps
`include "iob_lib.vh"
//`include "interconnect.vh"

module knn_tb;

   localparam PER=10;
   
   `CLOCK(clk_tb, PER)
   //`RESET(rst_tb, 7, 10)
   reg rst_tb;
  `SIGNAL(KNN_START_IN_TB,1)
  `SIGNAL(KNN_DATA_PT_IN_TB,32)
  `SIGNAL(KNN_TEST_PT_IN_TB,32)
  `SIGNAL(KNN_VALID_IN_TB,1)
  `SIGNAL(KNN_SAMPLE_ADD_TB,1)
  `SIGNAL_OUT(KNN_VALID_OUT_TB,1)
  `SIGNAL_OUT(KNN_ADD_TB,32)

  `SIGNAL(DATA_X,16)
  `SIGNAL(DATA_Y,16)
  `SIGNAL(DATA,32)
	   //instantiate knn core
  knn_core knn_core_tb
	(
	  .KNN_START_IN(KNN_START_IN_TB),
	  .KNN_DATA_PT_IN(KNN_DATA_PT_IN_TB),
	  .KNN_TEST_PT_IN(KNN_TEST_PT_IN_TB),
	  .KNN_VALID_IN(KNN_VALID_IN_TB),
	  .KNN_SAMPLE_ADD(KNN_SAMPLE_ADD_TB),
	  .KNN_ADD(KNN_ADD_TB),
	  .KNN_VALID_OUT(KNN_VALID_OUT_TB),
	  
	  .clk_top(clk_tb),
	  .rst_top(rst_tb)

	);
 
  initial begin
   $dumpfile("knn.vcd");
   $dumpvars(3,knn_tb);
   #1 KNN_START_IN_TB    <=1'b0;
   #1 KNN_DATA_PT_IN_TB  <=32'd0;
   #1 KNN_TEST_PT_IN_TB  <=32'd0;
   #1 KNN_VALID_IN_TB    <=1'b0;
   #1 DATA_X <=16'd 20;
   #1 DATA_Y <=16'd 20;
  	//reset
  @(posedge clk_tb)
  #5 rst_tb = 1; 
  @(posedge clk_tb)  
  #5 rst_tb = 0;

//forever
//begin
	//valid_in data test
	 repeat(127) @(posedge clk_tb)
	  begin
	   
	   #1 KNN_START_IN_TB    <=1'b0;
	   #1 KNN_DATA_PT_IN_TB  <= {DATA_X,DATA_Y};
	   #1 KNN_TEST_PT_IN_TB  <={16'd30,16'd31};
	   #1 KNN_VALID_IN_TB    <=1'b1;
	   #1 DATA_X <= DATA_X +10;
	   #1 DATA_Y <= DATA_Y +10; 
	   #1 KNN_SAMPLE_ADD_TB<=1'b0;
	  end
	//start fsm 	
	  @(posedge clk_tb)
		begin
	   #1 KNN_START_IN_TB    <=1'b1;
	   #1 KNN_VALID_IN_TB    <=1'b0;
		end
				
	repeat(200) @(posedge clk_tb)	;
	//@(posedge clk_tb)
	//begin
 	 // #1 KNN_START_IN_TB    <=1'b0;
	//end	  
	//@(posedge clk_tb)
	//begin
	//#1 DATA_X <=16'd 10;
   // #1 DATA_Y <=16'd 10;
	//end
//final code
		/* @(posedge clk_tb)
		#1 KNN_START_IN_TB    <=1'b0;
	   @(posedge clk_tb)
	   
		begin
	   #1 DATA_X <=16'd 3595;
	   #1 DATA_Y <=16'd 3595;
	  
	  end
	repeat(127) @(posedge clk_tb)
	  begin
	   
	   #1 KNN_START_IN_TB    <=1'b0;
	   #1 KNN_DATA_PT_IN_TB  <= {DATA_X,DATA_Y};
	   #1 KNN_TEST_PT_IN_TB  <={16'd0,16'd100};
	   #1 KNN_VALID_IN_TB    <=1'b1;
	   #1 DATA_X <= DATA_X -2;
	   #1 DATA_Y <= DATA_Y -2; 
	  end
	//start fsm 	
	  repeat (1000)@(posedge clk_tb)
		begin
	   #1 KNN_START_IN_TB    <=1'b1;
	   #1 KNN_VALID_IN_TB    <=1'b0;
		end
		@(posedge clk_tb)
		#1 KNN_START_IN_TB    <=1'b0;
	   @(posedge clk_tb); */
   //end
	$stop;
end	
always@(posedge clk_tb)
begin
	if(KNN_VALID_OUT_TB)
		KNN_SAMPLE_ADD_TB<=1'b1;
end

endmodule
