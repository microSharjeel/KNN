include $(KNN_DIR)/core.mk

#define
DEFINE+=$(defmacro) DATA_W=32

#include
INCLUDE+=$(incdir) $(KNN_HW_INC_DIR)
INCLUDE+=$(incdir) $(LIB_DIR)/hardware/include
INCLUDE+=$(incdir) $(INTERCON_DIR)/hardware/include 

#headers
VHDR+=$(wildcard $(KNN_HW_INC_DIR)/*.vh)
VHDR+=$(wildcard $(LIB_DIR)/hardware/include/*.vh)
VHDR+=$(wildcard $(INTERCON_DIR)/hardware/include/*.vh $(INTERCON_DIR)/hardware/include/*.v)
VHDR+=$(KNN_HW_INC_DIR)/KNNsw_reg_gen.v

#sources
KNN_SRC_DIR:=$(KNN_DIR)/hardware/src
VSRC+=$(wildcard $(KNN_HW_DIR)/src/*.v)

$(KNN_HW_INC_DIR)/KNNsw_reg_gen.v: $(KNN_HW_INC_DIR)/KNNsw_reg.v
	$(LIB_DIR)/software/mkregs.py $< HW
	mv KNNsw_reg_gen.v $(KNN_HW_INC_DIR)
	mv KNNsw_reg.vh $(KNN_HW_INC_DIR)

knn_clean_hw:
	@rm -rf $(KNN_HW_INC_DIR)/sw_reg_gen.v $(KNN_HW_INC_DIR)/sw_reg_w.vh tmp $(KNN_HW_DIR)/fpga/vivado/XCKU $(KNN_HW_DIR)/fpga/quartus/CYCLONEV-GT

.PHONY: knn_clean_hw
