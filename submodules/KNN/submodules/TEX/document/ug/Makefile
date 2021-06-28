CORE_DIR:=../..

SRC:=ug.tex $(wildcard ./*.tex) $(wildcard ../*.tex)
TD_FIGS:= 

include $(CORE_DIR)/submodules/TEX/document/document.mk

IS_TAB:=gen_is_tab.tex cpu_nat_s_is_tab.tex cpu_axi4lite_s_is_tab.tex cpu_axi4_m_is_tab.tex 

REG_TAB:=sw_reg_tab.tex 

BD_TAB:=bd_tab.tex

PARAM_TAB:=sp_tab.tex

gen_is_tab.tex: $(HW_DIR)/include/gen_if.v
	$(SW_DIR)/io2tex.py $< $@
cpu_nat_s_is_tab.tex: $(INTERCON_DIR)/cpu_nat_s_if.v
	$(SW_DIR)/io2tex.py $< $@
cpu_axi4lite_s_is_tab.tex: $(INTERCON_DIR)/cpu_axi4lite_s_if.v
	$(SW_DIR)/io2tex.py $< $@
cpu_axi4_m_is_tab.tex: $(INTERCON_DIR)/cpu_axi4_m_if.v
	$(SW_DIR)/io2tex.py $< $@
sw_reg_tab.tex: $(HW_DIR)/include/sw_reg.v
	$(SW_DIR)/swreg2tex.py $<
bd_tab.tex: $(HW_DIR)/src/iob_i2s_tdm.v $(HW_DIR)/src/hardcore.v
	$(SW_DIR)/block2tex.py $@ $(HW_DIR)/src/iob_i2s_tdm.v $(HW_DIR)/src/hardcore.v
sp_tab.tex: $(HW_DIR)/src/iob_i2s_tdm.v $(HW_DIR)/include/export.vh
	$(SW_DIR)/param2tex.py $(HW_DIR)/src/iob_i2s_tdm.v $@ $(HW_DIR)/include/export.vh

clean: texclean
	@rm -f $(IS_TAB) $(REG_TAB) $(BD_TAB) $(PARAM_TAB)

.PHONY: clean
