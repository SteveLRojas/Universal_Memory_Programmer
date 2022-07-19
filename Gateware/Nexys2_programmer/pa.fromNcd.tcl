
# PlanAhead Launch Script for Post PAR Floorplanning, created by Project Navigator

create_project -name Nexys2_programmer -dir "/home/ise/VM_share/Nexys2_programmer/planAhead_run_1" -part xc3s500efg320-4
set srcset [get_property srcset [current_run -impl]]
set_property design_mode GateLvl $srcset
set_property edif_top_file "/home/ise/VM_share/Nexys2_programmer/Nexys2_programmer.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/home/ise/VM_share/Nexys2_programmer} {ipcore_dir} }
add_files [list {ipcore_dir/BRAM_16K.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "Nexys2_500General.ucf" [current_fileset -constrset]
add_files [list {Nexys2_500General.ucf}] -fileset [get_property constrset [current_run]]
link_design
read_xdl -file "/home/ise/VM_share/Nexys2_programmer/Nexys2_programmer.ncd"
if {[catch {read_twx -name results_1 -file "/home/ise/VM_share/Nexys2_programmer/Nexys2_programmer.twx"} eInfo]} {
   puts "WARNING: there was a problem importing \"/home/ise/VM_share/Nexys2_programmer/Nexys2_programmer.twx\": $eInfo"
}
