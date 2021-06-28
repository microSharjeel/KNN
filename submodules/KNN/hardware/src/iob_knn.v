`timescale 1ns/1ps
`include "iob_lib.vh"
`include "interconnect.vh"
`include "iob_knn.vh"
//`include "KNNsw_reg.vh"
module iob_knn
  #(
    parameter ADDR_W = `KNN_ADDR_W, 
    parameter DATA_W = 32, 
    parameter WDATA_W = `KNN_WDATA_W 
    )
	(
		//CPU native interface	
		//cpu generic slave interface copied from
		`include "cpu_nat_s_if.v"
		//clk rst generic interface copied from
		`include "gen_if.v"
	);
	`include "KNN_Header.vh"
 	`include "KNNsw_reg.v"
	`include "KNNsw_reg_gen.v"

	`SIGNAL_OUT(KNN_VALID_OUT_CORE,1)
	`SIGNAL_OUT(KNN_ADD_OUT_CORE,`WDATA_W)
	wire rst_comb;
	assign rst_comb = rst | KNN_RESET; 
	knn_core knn_core_top
	(
	  .KNN_START_IN    (KNN_START),
	  .KNN_DATA_PT_IN  (KNN_DATA_PT),
	  .KNN_TEST_PT_IN  (KNN_TEST_PT),
	  .KNN_VALID_IN    (KNN_VALID_IN),
	  .KNN_SAMPLE_ADD(KNN_SAMPLE),
	  .KNN_ADDRESS_TOP(KNN_ADDR),
	  .KNN_ADD(KNN_ADD_OUT_CORE),
	  .KNN_VALID_OUT(KNN_VALID_OUT_CORE),
          .clk_top(clk),
	  .rst_top(rst_comb)

	); 

	assign KNN_ADD       = KNN_ADD_OUT_CORE; 
	assign KNN_VALID_OUT = KNN_VALID_OUT_CORE;


endmodule
