//software accessible registers
//INPUT REGS 

`SWREG_W(KNN_RESET,            1, 0) 
`SWREG_W(KNN_START,            1, 0) 
`SWREG_W(KNN_VALID_IN,         `KNN_VALID_W, 0)
`SWREG_W(KNN_TEST_PT,          `WDATA_W, 0) 
`SWREG_W(KNN_DATA_PT,          `WDATA_W, 0)
`SWREG_W(KNN_SAMPLE,            1, 0) 
`SWREG_W(KNN_ADDR,8,0)
//OUTPUT REGS

`SWREG_R(KNN_VALID_OUT,        1, 0)
`SWREG_R(KNN_ADD,`WDATA_W,0)
