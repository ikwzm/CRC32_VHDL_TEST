set     project_directory   [file dirname [info script]]
source                      [file join $project_directory "parameter.tcl"]
lappend constrs_file_list   [file join $project_directory "timing.xdc"]
source                      [file join $project_directory ".." "scripts" "create_project.tcl"]
