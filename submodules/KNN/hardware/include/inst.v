   //
   // KNN
   //
iob_knn knn
     (
      .clk      (clk),
      .rst      (reset),

      //cpu interface
      .valid(slaves_req[`valid(`KNN)]),
      .address(slaves_req[`address(`KNN,`KNN_ADDR_W+2)-2]),
      .wdata(slaves_req[`wdata(`KNN)-(`DATA_W-`KNN_WDATA_W)]),
      .wstrb(slaves_req[`wstrb(`KNN)]),
      .rdata(slaves_resp[`rdata(`KNN)]),
      .ready(slaves_resp[`ready(`KNN)]));
