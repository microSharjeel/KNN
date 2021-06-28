include $(KNN_DIR)/core.mk

#path
KNN_SW_DIR:=$(KNN_DIR)/software

#define
ifeq ($D,1)
DEFINE+=-DDEBUG
endif

#include
INCLUDE+=-I$(KNN_SW_DIR)

#headers
HDR+=$(KNN_SW_DIR)/*.h $(KNN_SW_DIR)/KNNsw_reg.h

#sources
SRC+=$(KNN_SW_DIR)/*.c

$(KNN_SW_DIR)/KNNsw_reg.h: $(KNN_HW_INC_DIR)/KNNsw_reg.v
	$(LIB_DIR)/software/mkregs.py $< SW
	mv KNNsw_reg.h $@

