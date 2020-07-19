# simulation
SIMDIR = simul
SIMBIN = $(COMPONENT)_tb

# ghdl
GHDLCMD = ghdl

view:
	gunzip --stdout $(SIMDIR)/$(SIMBIN).vcdgz | gtkwave --vcd &

clean:
	$(GHDLCMD) --clean --workdir=$(SIMDIR)
	rm -r $(SIMDIR)
	rm -rf scripts/__pycache__
	rm -f testbench/multiplier/main_tb.vhdl
	rm -f testbench/adder/fa_tb.vhdl

lint:
	python3 -m vsg --fix -c .vsg_config.json

.PHONY: clean lint view
