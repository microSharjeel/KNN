CORE_NAME:=CACHE
IS_CORE:=1
USE_NETLIST ?=0

#RTL simulator
CACHE_SIMULATOR:=icarus

#FPGA board
CACHE_FPGA_BOARD:=AES-KU040-DB-G

#paths
CACHE_SW_DIR:=$(CACHE_DIR)/software
CACHE_HW_DIR:=$(CACHE_DIR)/hardware
CACHE_SIM_DIR:=$(CACHE_HW_DIR)/simulation/$(CACHE_SIMULATOR)
CACHE_FPGA_DIR:=$(CACHE_HW_DIR)/fpga/$(CACHE_FPGA_BOARD)

