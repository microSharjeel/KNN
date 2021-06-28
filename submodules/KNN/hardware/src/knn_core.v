`timescale 1ns/1ps
`include "KNN_Header.vh"
`include "iob_lib.vh"
 module knn_core
(
  `INPUT(KNN_START_IN,1),
  `INPUT(KNN_DATA_PT_IN,`WDATA_W),
  `INPUT(KNN_TEST_PT_IN,`WDATA_W),
  `INPUT(KNN_VALID_IN,1),
  `INPUT(KNN_SAMPLE_ADD,1),
  `INPUT(KNN_ADDRESS_TOP,8),
  `OUTPUT(KNN_ADD,`WDATA_W),
  `OUTPUT(KNN_VALID_OUT,1),

  //`OUTPUT(ADD_TOP,`WDATA_W),  
  `INPUT(clk_top, 1),
  `INPUT(rst_top, 1)

);

`SIGNAL_OUT(KNN_TST_FSM,`WDATA_W)
`SIGNAL_OUT(KNN_DAT_FSM,`WDATA_W)
`SIGNAL_OUT(KNN_ST_FSM,1)
//`SIGNAL_OUT(KNN_INIT_SIGNAL_FSM,1)
knn_fsm  knn_fsm_inst
(
	//to and from datapath
	.KNN_TEST_PT_O    (KNN_TST_FSM),
	.KNN_DATA_PT_O    (KNN_DAT_FSM),
	.KNN_START_O      (KNN_ST_FSM),
	
  //  .KNN_INIT_O(KNN_INIT_SIGNAL_FSM),
	//to and from KNN top level and KNN core 
	.KNN_START_FSM    (KNN_START_IN),
	.KNN_DATA_PT_FSM  (KNN_DATA_PT_IN),
	.KNN_TEST_PT_FSM  (KNN_TEST_PT_IN),
	.KNN_VALID_IN_FSM (KNN_VALID_IN),
	.KNN_SAMPLE_FSM(KNN_SAMPLE_ADD),
	.KNN_VALID_O      (KNN_VALID_OUT),
	.clk(clk_top),
	.rst(rst_top)
);
knn_datapath knn_datapath_inst
(
	//from fsm
	 .KNN_TEST_PT_DP(KNN_TST_FSM),
	 .KNN_DATA_PT_DP(KNN_DAT_FSM),
	 .KNN_START_DP(KNN_ST_FSM),
	 //from top level
	 .KNN_SAMPLE_DP(KNN_SAMPLE_ADD),
	//to top level and knn core
	.KNN_ADDRESS_DP(KNN_ADDRESS_TOP),
	 .ADD(KNN_ADD),
	 .clk(clk_top),
   	 .rst(rst_top)
);	
		
endmodule 
