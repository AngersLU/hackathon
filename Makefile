

RTL_CODE := ./vsrc/tb.v \
	./vsrc/ht.v \
	./vsrc/max_min.v \
	./vsrc/step1.v \
	./vsrc/step2.v \
	./vsrc/step3.v \


SIM_TOOL := iverilog

WAVE_TOOL := gtkwave
WAVE_FILE := tb.vcd

comp:
	$(SIM_TOOL) -g2005-sv -s tb ${RTL_CODE}
	

run: comp
	vvp -n a.out

wave:
	${WAVE_TOOL} $(WAVE_FILE)

.PHONY: clean

clean:
	rm -rf tb.vcd* *.log a.out


