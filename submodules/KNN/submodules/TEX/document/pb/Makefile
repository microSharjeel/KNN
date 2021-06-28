CORE_DIR:=../..

include $(CORE_DIR)/submodules/TEX/document/document.mk

pb.pdf: pb.tex figures fpga
	$(EXPORT_LIST) pdflatex '\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'
	$(EXPORT_LIST) pdflatex '\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'
	evince $@ &

clean: texclean

.PHONY: clean
