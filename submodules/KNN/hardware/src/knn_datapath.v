`timescale 1ns/1ps
`include "iob_lib.vh"
`include "KNN_Header.vh"

module	knn_datapath
(
	//from fsm
	input signed [`WDATA_W-1:0]KNN_TEST_PT_DP,//`INPUT(KNN_TEST_PT_DP,`WDATA_W),
	input signed [`WDATA_W-1:0]KNN_DATA_PT_DP,// `INPUT(KNN_DATA_PT_DP,`WDATA_W),
	`INPUT(KNN_START_DP,1),
	//from sw reg
	`INPUT(KNN_SAMPLE_DP,1),
	`INPUT(KNN_ADDRESS_DP,8),
	`OUTPUT(ADD,`WDATA_W),
	
	`INPUT(clk, 1),
    	`INPUT(rst, 1)
      );
	//defining signals for datapath
	wire  [15:0]two_comp_X;
	wire  [15:0]two_comp_Y;

	reg signed   [15:0]sub_X;
	reg signed  [15:0]sub_Y;
	reg   [31:0] mul_X;
    	reg   [31:0] mul_Y;
    	reg   [31:0] add;
    	
    	reg [7:0] addr_wr;
	reg [`WDATA_W-1:0] distances[`K_NUM_DATA_PTS-1:0];
	`SIGNAL(add_reg,`WDATA_W)
	integer i;
	//TEST AND DATA POINTS HAS BOTH X AND Y CO-ORDINATE IN ONE REG 16BIT MSBs  X  16 BIT LSBb ARE Y
	always @ (posedge clk or posedge rst)
	begin
		if(rst)
		begin
			sub_X<= 17'd0;
			sub_Y<= 17'd0;
			mul_X<= 32'd0;
			mul_Y<= 32'd0;
			add <=  33'd0;
			addr_wr<= 8'd0;
			
			for (i = 0; i < (`K_NUM_DATA_PTS-1); i = i + 1) begin distances[i] <= 0; end
		end
		else
		begin
			if(KNN_START_DP)
			begin
							
				sub_X<= KNN_TEST_PT_DP[31:16] - KNN_DATA_PT_DP[31:16];
				sub_Y<= KNN_TEST_PT_DP[15:0] -  KNN_DATA_PT_DP[15:0];
				
				if(sub_X[15])
				begin
					
					mul_X<= two_comp_X*two_comp_X;
				end	
				else
				begin
					mul_X<= sub_X[15:0] * sub_X[15:0];
				end
				if(sub_Y[15])
				begin
					
					mul_Y<= two_comp_Y*two_comp_Y;
				end
				else
				begin
					mul_Y<= sub_Y[15:0] * sub_Y[15:0];
				end
				add <= mul_X + mul_Y;
				distances[addr_wr]<=add[31:0];
				addr_wr<=addr_wr+1;
					
			end
		 	else
			begin
				sub_X<= 17'd0;
				sub_Y<= 17'd0;
				mul_X<= 32'd0;
				mul_Y<= 32'd0;
				add <=  33'd0;
				addr_wr<=0;
				
			end 
		end
			
	end
	always@ (posedge clk or posedge rst)
	begin
	    if(rst)
	    begin
	    	add_reg<=32'd0;	
	    end
	    else
	    begin
	       if(KNN_SAMPLE_DP==1)
	       begin
	    	 add_reg<=distances[KNN_ADDRESS_DP];
	    
	       end
	    	 
	    	
	    end	
	    	
	end
 
	assign two_comp_X = (~(sub_X[15:0])+16'b0000_0000_0000_0001);
	assign two_comp_Y =(~(sub_Y[15:0])+16'b0000_0000_0000_0001);
        
	//`REG_RE(clk,rst,0, KNN_SAMPLE_DP, add_reg,add[31:0])
	`SIGNAL2OUT(ADD,add_reg)
	
		
endmodule 
