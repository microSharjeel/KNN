`timescale 1ns/1ps
`include "iob_lib.vh"
//`include "KNNsw_reg.vh"
`include "KNN_Header.vh"
module	knn_fsm
  #(
	parameter SIZE =    3,
	parameter INIT  =   3'b001,
	parameter COMPUTE = 3'b010,
	parameter OUTPUT =  3'b100 
    )
	(
	//to and from datapath
	 output reg [`WDATA_W-1:0] KNN_TEST_PT_O,
	 output reg [`WDATA_W-1:0] KNN_DATA_PT_O,
	 output reg KNN_START_O,
	//to and from KNN top level and KNN core 
	`INPUT(KNN_START_FSM,      1),
	`INPUT(KNN_DATA_PT_FSM,    `WDATA_W),
	`INPUT(KNN_TEST_PT_FSM,    `WDATA_W),
	`INPUT(KNN_VALID_IN_FSM,   `KNN_VALID_W),
	`INPUT(KNN_SAMPLE_FSM,1),
	 output reg KNN_VALID_O,
	`INPUT(clk,                1),
	`INPUT(rst,                1)
	);

reg [(`KNN_LOW_W+`KNN_HIGH_W)-1:0]data_points[`K_NUM_DATA_PTS:0];

`SIGNAL(state, SIZE)
`SIGNAL(count, 7)
`SIGNAL(addr, 7)

integer i;

always @(posedge clk or posedge rst)
begin
	if(rst)	
	begin
		for (i = 0; i < (`K_NUM_DATA_PTS-1); i = i + 1) begin data_points[i] <= 0; end
		addr <= 7'b0;
	end	
	else 
	begin
		if((KNN_VALID_IN_FSM)&& state==INIT)
		begin	
			
			data_points[addr]<=KNN_DATA_PT_FSM;
			addr <= addr+1;	
		end
		else
		begin
			addr<=0;
		end
	end
    
end

 always @(posedge clk or posedge rst)

 begin : FSM_SEQ
    
	if(rst)
	begin
		state<= INIT;
	end
	else
	begin
	  case(state)
	     INIT:	
			if((KNN_START_FSM==1) )
			begin	
				state <= COMPUTE;
			end	
	    		else if((KNN_START_FSM==0))
			begin
				state <=  INIT;
     			end
	     COMPUTE:
			if( (count <= `K_NUM_DATA_PTS-1)  &&(KNN_START_FSM==1) )
			begin
				state <= COMPUTE;
			end
			else if ( (count > `K_NUM_DATA_PTS-1)&&(KNN_START_FSM==1)  )
			begin
	
				state <= OUTPUT;
			end
		 
             OUTPUT:
		 	if( (KNN_START_FSM==1))
			begin
				state <= OUTPUT;
			end
			else if( (KNN_START_FSM==0))
			begin
				state<= INIT;
			end 
			

	      default : 
			state <= INIT;

	endcase
	end
  
 end 

 always @(posedge clk or posedge rst)
 begin
	if(rst)
	begin
		count<=7'd0;
		KNN_START_O   <= 1'b0;
		KNN_TEST_PT_O <= 32'd0;
		KNN_DATA_PT_O <= 32'd0;
		
	end
	else 
	begin
		 if(state==COMPUTE &&  count <= (`K_NUM_DATA_PTS-1))
		 begin	
			KNN_TEST_PT_O <= KNN_TEST_PT_FSM;
			KNN_DATA_PT_O <= data_points[count];
			KNN_START_O   <= 1'b1;
			count <= count +1;
			
		 end
		 else 
		 begin
			KNN_TEST_PT_O <= 32'd0;
			KNN_DATA_PT_O <= 32'd0;
			KNN_START_O   <= 1'b0;
			count<= 7'd0;
			
		 end
	end
end	

 always @(posedge clk or posedge rst)
 begin
	if(rst)
	begin
		KNN_VALID_O   <= 1'b0;
	end
	else 
	begin
		 if( (state==OUTPUT))
		 begin	
			KNN_VALID_O   <= 1'b1;
		 end

		 else
		 	KNN_VALID_O   <= 1'b0;
		 
	end
end
endmodule 


	
