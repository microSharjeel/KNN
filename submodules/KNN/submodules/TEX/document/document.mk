XIL_LOG=vivado.log
INT_LOG=quartus.log

EXPORT_LIST=\
INTEL=$(INTEL)\
XILINX=$(XILINX)\
IS_CORE=$(IS_CORE)

TEX:=$(TEX_DIR)/document
TEX_SW_DIR:=$(TEX_DIR)/software

pb.pdf: pb.tex figures fpga_res
	$(EXPORT_LIST) pdflatex '\def\TEX{$(TEX)}\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'
	$(EXPORT_LIST) pdflatex '\def\TEX{$(TEX)}\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'
	evince $@ &

ug.pdf: $(SRC) figures fpga_res $(CORE_NAME)_version.txt
	git rev-parse --short HEAD > shortHash.txt
	$(EXPORT_LIST) pdflatex '\def\TEX{$(TEX)}\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'
	$(EXPORT_LIST) pdflatex '\def\TEX{$(TEX)}\def\XILINX{$(XILINX)}\def\INTEL{$(INTEL)}\input{$<}'
	evince $@ &

export TD_FIGS
figures:
	cp -u $(TEX_DIR)/document/figures/* ../figures
	make -C ../figures

fpga_res:
	echo $(IS_CORE)
ifeq ($(XILINX),1)
ifeq ($(IS_CORE),1)
	cp $($(CORE_NAME)_HW_DIR)/fpga/vivado/$(XIL_FAMILY)/vivado.log .
else
	cp $(HW_DIR)/fpga/AES-KU040-DB-G/vivado.log .
endif
endif
ifeq ($(INTEL),1)
ifeq ($(IS_CORE),1)
	cp $($(CORE_NAME)_HW_DIR)/fpga/quartus/$(INT_FAMILY)/quartus.log .
else
	cp $(HW_DIR)/fpga/CYCLONEV-GT-DK/top_system.fit.summary quartus.log
endif
endif
	$(EXPORT_LIST) $(TEX_SW_DIR)/fpga2tex.sh


gen_is_tab.tex: $(INTERCON_DIR)/hardware/include/gen_if.v
	$(TEX_SW_DIR)/io2tex.py $< $@

cpu_nat_s_is_tab.tex: $(INTERCON_DIR)/hardware/include/cpu_nat_s_if.v
	$(TEX_SW_DIR)/io2tex.py $< $@

cpu_axi4lite_s_is_tab.tex: $(INTERCON_DIR)/hardware/include/cpu_axi4lite_s_if.v
	$(TEX_SW_DIR)/io2tex.py $< $@

sw_reg_tab.tex: $($(CORE_NAME)_DIR)/hardware/include/$(CORE_NAME)sw_reg.v
	$(TEX_SW_DIR)/swreg2tex.py $<

texclean:
	@rm -f *~ *.aux *.out *.log *.summary 
	@rm -f *.lof *.toc *.fdb_latexmk  ug.fls  *.lot *.txt
	make -C ../figures clean
	@rm -f $(TEX_SRC) $(addprefix ../figures/, $(TEX_FIG))

resultsclean:
	@rm *_results*

pdfclean: clean
	@rm -f *.pdf

.PHONY:  figures fpga_res texclean pdfclean
