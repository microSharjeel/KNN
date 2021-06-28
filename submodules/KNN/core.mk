CORE_NAME=KNN
IS_CORE=1
USE_NETLIST ?=0

#PATHS
KNN_HW_DIR:=$(KNN_DIR)/hardware
KNN_HW_INC_DIR:=$(KNN_HW_DIR)/include
KNN_DOC_DIR:=$(KNN_DIR)/document
KNN_SUBMODULES_DIR:=$(KNN_DIR)/submodules

#submodules
KNN_SUBMODULES:=INTERCON LIB TEX
$(foreach p, $(KNN_SUBMODULES), $(eval $p_DIR:=$(KNN_DIR)/submodules/$p))

REMOTE_ROOT_DIR ?= sandbox/iob-soc/submodules/KNN

#
#SIMULATION
#
SIMULATOR ?=icarus
SIM_SERVER ?=localhost
SIM_USER ?=$(USER)

#SIMULATOR ?=ncsim
#SIM_SERVER ?=micro7.lx.it.pt
#SIM_USER ?=user19

SIM_DIR ?=hardware/simulation/$(SIMULATOR)

#
#FPGA
#
#FPGA_FAMILY ?=CYCLONEV-GT
FPGA_FAMILY ?=XCKU
#FPGA_SERVER ?=localhost
FPGA_SERVER ?=pudim-flan.iobundle.com
FPGA_USER ?= $(USER)

ifeq ($(FPGA_FAMILY),XCKU)
	FPGA_COMP:=vivado
	FPGA_PART:=xcku040-fbva676-1-c
else
	FPGA_COMP:=quartus
	FPGA_PART:=5CGTFD9E5F35C7
endif
FPGA_DIR ?=$(KNN_DIR)/hardware/fpga/$(FPGA_COMP)

ifeq ($(FPGA_COMP),vivado)
FPGA_LOG:=vivado.log
else ifeq ($(FPGA_COMP),quartus)
FPGA_LOG:=quartus.log
endif

#
#DOCUMENT
#
DOC_TYPE:=pb
#DOC_TYPE:=ug
INTEL ?=1
XILINX ?=1

VLINE:="V$(VERSION)"
$(CORE_NAME)_version.txt:
ifeq ($(VERSION),)
	$(error "variable VERSION is not set")
endif
	echo $(VLINE) > $@

.PHONY: version.txt
