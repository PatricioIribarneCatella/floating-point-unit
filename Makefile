# VHDL files
VHDLEX = .vhdl

# source files
SRC = src
SRCFILES = $(wildcard $(SRC)/*$(VHDLEX))

# testbench files
TESTBENCH = testbench
COMPONENT = fpu
TESTBENCHFILE = $(TESTBENCH)/$(COMPONENT)_tb$(VHDLEX)
SIMBIN := $(COMPONENT)_tb

# simulation
SIMDIR = simul
STOPTIME = 500ns
SIMFLAGS = --stop-time=$(STOPTIME) --vcdgz=$(SIMDIR)/$(SIMBIN).vcdgz

# ghdl
GHDLCMD = ghdl
GHDLFLAGS = --ieee=standard -fsynopsys --warn-no-vital-generic --workdir=$(SIMDIR) 

all: $(SIMBIN)

$(SIMBIN): $(SRCFILES) 
	@mkdir -p $(SIMDIR)
	$(GHDLCMD) -i $(GHDLFLAGS) --work=work $(TESTBENCHFILE) $(SRCFILES)
	$(GHDLCMD) -m $(GHDLFLAGS) --work=work $@

sim: $(SIMBIN)
	$(GHDLCMD) -r $(GHDLFLAGS) $^ $(SIMFLAGS) 

view:
	gunzip --stdout $(SIMDIR)/$(SIMBIN).vcdgz | gtkwave --vcd &

clean:
	$(GHDLCMD) --clean --workdir=$(SIMDIR)
	rm -r $(SIMDIR)

lint:
	python3 -m vsg --fix -c .vsg_config.json

.PHONY: clean lint view
