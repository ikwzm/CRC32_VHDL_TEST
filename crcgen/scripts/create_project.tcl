#
# create_project.tcl  Tcl script for creating project
#
if {[info exists crc_name    ] == 0} {
    puts "ERROR: Please set crc_name."
    return 1
}
if {[info exists top_name    ] == 0} {
    puts "ERROR: Please set top_name."
    return 1
}
if {[info exists data_width  ] == 0} {
    puts "ERROR: Please set data_width."
    return 1
}
if {[info exists project_name     ] == 0} {
    set project_name        "project"
}
if {[info exists project_directory] == 0} {
    set project_directory   [pwd]
}
#
# Create Project
#
create_project -force $project_name $project_directory
#
# Set project properties
#
if       {[info exists board_part ] && [string equal $board_part  "" ] == 0} {
    set_property "board_part"     $board_part      [current_project]
} elseif {[info exists device_part] && [string equal $device_part "" ] == 0} {
    set_property "part"           $device_part     [current_project]
} else {
    puts "ERROR: Please set board_part or device_part."
    return 1
}
set_property "default_lib"        "xil_defaultlib" [current_project]
set_property "simulator_language" "Mixed"          [current_project]
set_property "target_language"    "VHDL"           [current_project]
#
# Create fileset "sources_1"
#
if {[string equal [get_filesets -quiet sources_1] ""]} {
    create_fileset -srcset sources_1
}
#
# Create fileset "constrs_1"
#
if {[string equal [get_filesets -quiet constrs_1] ""]} {
    create_fileset -constrset constrs_1
}
#
# Create fileset "sim_1"
#
if {[string equal [get_filesets -quiet sim_1] ""]} {
    create_fileset -simset sim_1
}
#
# Create run "synth_1" and set property
#
set synth_1_flow     "Vivado Synthesis 2020"
set synth_1_strategy "Vivado Synthesis Defaults"
if {[string equal [get_runs -quiet synth_1] ""]} {
    create_run -name synth_1 -flow $synth_1_flow -strategy $synth_1_strategy -constrset constrs_1
} else {
    set_property flow     $synth_1_flow     [get_runs synth_1]
    set_property strategy $synth_1_strategy [get_runs synth_1]
}
current_run -synthesis [get_runs synth_1]
#
# Create run "impl_1" and set property
#
set impl_1_flow      "Vivado Implementation 2020"
set impl_1_strategy  "Performance_Explore"
if {[string equal [get_runs -quiet impl_1] ""]} {
    create_run -name impl_1 -flow $impl_1_flow -strategy $impl_1_strategy -constrset constrs_1 -parent_run synth_1
} else {
    set_property flow     $impl_1_flow      [get_runs impl_1]
    set_property strategy $impl_1_strategy  [get_runs impl_1]
}
current_run -implementation [get_runs impl_1]
#
# Set IP Repository
#
if {[info exists ip_repo_path_list] && [llength $ip_repo_path_list] > 0 } {
    set_property ip_repo_paths $ip_repo_path_list [current_fileset]
    update_ip_catalog
}
#
# Import Constraint files
#
if {[info exists constrs_file_list] && [llength $constrs_file_list] > 0 } {
    add_files    -fileset constrs_1 -norecurse $constrs_file_list
}
#
# Add VHDL Files
#
proc add_vhdl_file {fileset_name library_name file_name} {
    set file    [file normalize $file_name]
    set fileset [get_filesets   $fileset_name] 
    add_files -norecurse -fileset $fileset $file
    set file_obj [get_files -of_objects $fileset $file]
    set_property "file_type" "VHDL"        $file_obj
    set_property "library"   $library_name $file_obj
}
add_vhdl_file sources_1 "WORK"  [file join $project_directory "${crc_name}.vhd"]
add_vhdl_file sources_1 "WORK"  [file join $project_directory "${top_name}.vhd"]
add_vhdl_file sim_1     "WORK"  [file join $project_directory "${top_name}_test.vhd"]
set_property top     "${top_name}"      [get_filesets sources_1]
set_property top     "${top_name}_test" [get_filesets sim_1]
set_property generic FINISH_ABORT=true  [get_filesets sim_1]
set_property -name {xsim.simulate.runtime} -value {10000ns} -objects [get_filesets sim_1]
#
# Close Project
#
close_project
