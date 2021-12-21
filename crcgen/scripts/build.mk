PROJECT_NAME   ?= crc32_0032
NR_DATA_BITS   ?= 32
DEVICE_NAME    ?= "xczu3eg-sbva484-1-e"
CLOCK_PERIOD   ?= 1.0

PYTHON         ?= python3.7
CRCGEN         ?= $(PYTHON) ../crcgen/crcgen
TOPGEN         ?= $(PYTHON) ../scripts/topgen.py
VIVADO         ?= vivado

CRC_NAME       := $(PROJECT_NAME)
TOP_NAME       := $(PROJECT_NAME)_top
DATA_PARAM     := d
CRC_IN_PARAM   := c
CRC_OUT_PARAM  := o

TARGET         := $(PROJECT_NAME).rpt
SOURCES        := create.tcl build.tcl parameter.tcl timing.xdc $(CRC_NAME).vhd $(TOP_NAME).vhd $(TOP_NAME)_test.vhd

sources: $(SOURCES)

project: $(PROJECT_NAME).xpr

build: $(TARGET)

clean:
	-rm $(SOURCES)

parameter.tcl :
	echo "set data_width    " $(NR_DATA_BITS) >  $@
	echo "set crc_name      " $(CRC_NAME)     >> $@
	echo "set top_name      " $(TOP_NAME)     >> $@
	echo "set device_part   " $(DEVICE_NAME)  >> $@
	echo "set project_name  " $(PROJECT_NAME) >> $@

timing.xdc:
	echo "create_clock -period " $(CLOCK_PERIOD) " -name CLK [get_port CLK]" > $@

create.tcl : 
	echo 'set     project_directory   [file dirname [info script]]' >  $@
	echo 'source                      [file join $$project_directory "parameter.tcl"]' >> $@
	echo 'lappend constrs_file_list   [file join $$project_directory "timing.xdc"]'    >> $@
	echo 'source                      [file join $$project_directory ".." "scripts" "create_project.tcl"]' >> $@

build.tcl :
	echo 'set     project_directory   [file dirname [info script]]' >  $@
	echo 'source                      [file join $$project_directory "parameter.tcl"]' >> $@
	echo 'lappend constrs_file_list   [file join $$project_directory "timing.xdc"]'    >> $@
	echo 'source                      [file join $$project_directory ".." "scripts" "implementation.tcl"]' >> $@

$(CRC_NAME).vhd :
	$(CRCGEN) -V -a CRC-32 -b $(NR_DATA_BITS) -n $(CRC_NAME) -D d -C c -o o > $@

$(TOP_NAME).vhd :
	$(TOPGEN) -n $(CRC_NAME) -b $(NR_DATA_BITS) > $@

$(TOP_NAME)_test.vhd : ../src/top_test.vhd
	sed -e 's/crc_top/'$(TOP_NAME)'/g' < ../src/top_test.vhd > $@

$(PROJECT_NAME).xpr : $(SOURCES) create.tcl
	$(VIVADO) -mode batch -source create.tcl

$(PROJECT_NAME).rpt : $(PROJECT_NAME).xpr build.tcl
	$(VIVADO) -mode batch -source build.tcl
