`timescale 1ns/1ps
`include "iob_lib.vh"
`include "interconnect.vh"
`include "iob_timer.vh"


module iob_timer
  #(
    parameter ADDR_W = `TIMER_ADDR_W, 
    parameter DATA_W = 32, 
    parameter WDATA_W = `TIMER_WDATA_W 
    )
	(
		//clk rst generic interface copied from
		
		//cpu generic slave interface copied from
		`include "cpu_nat_s_if.v"
		//CPU native interface
/*         `INPUT(valid,   1),  //Native CPU interface valid signal
	    `INPUT(address, `ADDR_W),  //Native CPU interface address signal
        `INPUT(wdata,   `WDATA_W), //Native CPU interface data write signal
	    `INPUT(wstrb,   `DATA_W/8),  //Native CPU interface write strobe signal
	    output reg [`DATA_W-1:0]rdata, //Native CPU interface read data signal
	    `OUTPUT(ready,  1),  //Native CPU interface ready signal */
/*
		`INPUT(clk, 1), //System clock input
		`INPUT(rst, 1) //System reset, asynchronous and active high */
		`include "gen_if.v"
	);
	`include "Timer_Header.vh"
 	`include "TIMERsw_reg.v"
	`include "TIMERsw_reg_gen.v"

	//Hardware reset and software reset combined in one signal
	//Software acessible Registers for testing only.
	/* `SIGNAL(SOFT_RESET,1)
	`SIGNAL(TIMER_SAMPLE,1)
	`SIGNAL(TIMER_ENABLE,1) */
	 
/* 	`SIGNAL(COUNT_REG_HIGH,2*`DATA_W)
	`SIGNAL(COUNT_REG_LOW,2*`DATA_W)
	always @(posedge clk or posedge rst)
	
		if(rst_comb)
		begin
			SOFT_RESET<=1'b0;
			TIMER_SAMPLE<=1'b0;
			TIMER_ENABLE<=1'b0;
			rdata <= 0;

		end	
		else if(clk)
		 begin
			if(valid)
			begin
				if((wstrb!=4'b0000) &&(address==32'd4))		 
					SOFT_RESET<=wdata[0];
				else if((wstrb!=4'b0000) &&(address==32'd0))	
					TIMER_ENABLE<=wdata[0];
				else if((wstrb!=4'b0000) &&(address==32'd1))	
					TIMER_SAMPLE<=wdata[0];	
				else if((wstrb==4'b0000) &&(address==32'd2))
					rdata <= COUNT_REG_LOW;

			end	
				
		end	
 	`REG_R(clk, rst_comb, 1, COUNT_REG_HIGH, TIMER_COUNT_TOP[2*`DATA_W-1:`DATA_W]) 
	`REG_R(clk, rst_comb, 1, COUNT_REG_LOW, TIMER_COUNT_TOP[`DATA_W-1:0]) */ 
	 
	wire rst_comb;
	assign rst_comb = rst | TIMER_RESET; 

	//Instantiating timer and register blocks here
	`SIGNAL_OUT(TIMER_COUNT_TOP,2*`DATA_W)
    timer timer_TOP
	(
		.TIMER_EN(TIMER_ENABLE),
		.WRAP_H(TIMER_WRAP_HIGH),
		.WRAP_L(TIMER_WRAP_LOW),
		.TIMER_S(TIMER_SAMPLE),
		.TIMER_COUNT(TIMER_COUNT_TOP),
		.clk(clk),
		.rst(rst_comb)
	);


	assign TIMER_DATA_HIGH = TIMER_COUNT_TOP[2*`DATA_W-1:`DATA_W];
	assign TIMER_DATA_LOW  = TIMER_COUNT_TOP[`DATA_W-1:0];
	//assign ready= 1'b1;

endmodule
