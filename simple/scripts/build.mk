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
SOURCE         := ../src/crc_gen.vhd 
SOURCES        := build.tcl parameter.tcl timing.xdc $(TOP_NAME).vhd

sources: $(SOURCES)

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

build.tcl :
	echo 'set     project_directory   [file dirname [info script]]' >  $@
	echo 'source                      [file join $$project_directory "parameter.tcl"]' >> $@
	echo 'lappend constrs_file_list   [file join $$project_directory "timing.xdc"]'    >> $@
	echo 'source                      [file join $$project_directory ".." "scripts" "create_project.tcl"]' >> $@
	echo 'source                      [file join $$project_directory ".." "scripts" "implementation.tcl"]' >> $@

$(TOP_NAME).vhd :
	$(TOPGEN) -n $(CRC_NAME) -b $(NR_DATA_BITS) > $@

$(PROJECT_NAME).rpt : $(SOURCES) $(SOURCE)
	$(VIVADO) -mode batch -source build.tcl
