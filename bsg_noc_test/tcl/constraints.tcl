source -echo -verbose $::env(BSG_DESIGNS_DIR)/toplevels/common/bsg_tag.constraints.tcl
source -echo -verbose $::env(BSG_DESIGNS_DIR)/toplevels/common/bsg_chip_cdc.constraints.tcl
source -echo -verbose $::env(BSG_DESIGNS_DIR)/toplevels/common/bsg_comm_link.constraints.tcl
source -echo -verbose $::env(BSG_DESIGNS_DIR)/toplevels/common/bsg_clk_gen.constraints.tcl

  ########################################
  ##
  ## Clock Setup
  ##
  
  set clk_name "clk" ;# main clock running mul
  
  set clk_period_ps       1000
  set clk_uncertainty_ps  100
  
  set core_clk_name           ${clk_name}
  set core_clk_period_ps      ${clk_period_ps}
  set core_clk_uncertainty_ps ${clk_uncertainty_ps}
  
  # Arrive at 600 ps
  set core_input_delay_ps  [expr 600]
  set core_output_delay_ps [expr ${clk_period_ps} - ${core_input_delay_ps}]

  set driving_lib_cell "SC7P5T_INVX2_SSC14R"
  set load_lib_pin     "SC7P5T_INVX8_SSC14R/A"

  # Reg2Reg
  create_clock -period ${core_clk_period_ps} -name ${core_clk_name} [get_ports "clk_i"]
  set_clock_uncertainty ${core_clk_uncertainty_ps} [get_clocks ${core_clk_name}]
  
  # In2Reg
  set core_input_pins [filter_collection [all_inputs] "name!~*clk*"]
  set_driving_cell -no_design_rule -lib_cell ${driving_lib_cell} [remove_from_collection [all_inputs] [get_ports *clk*]]
  set_input_delay ${core_input_delay_ps} -clock ${core_clk_name} ${core_input_pins}
  
  # Reg2Out
  set core_output_pins [all_outputs]
  set_load [load_of [get_lib_pin */${load_lib_pin}]] ${core_output_pins}
  set_output_delay ${core_output_delay_ps} -clock ${core_clk_name} ${core_output_pins}

  # Set false paths for slow signals
  set_false_path -from [get_ports *cord*]

  # Derate
  set cells_to_derate [list]
  append_to_collection cells_to_derate [get_cells -quiet -hier -filter "ref_name=~gf14_*"]
  append_to_collection cells_to_derate [get_cells -quiet -hier -filter "ref_name=~IN12LP_*"]
  if { [sizeof $cells_to_derate] > 0 } {
    foreach_in_collection cell $cells_to_derate {
      set_timing_derate -cell_delay -early 0.97 $cell
      set_timing_derate -cell_delay -late  1.03 $cell
      set_timing_derate -cell_check -early 0.97 $cell
      set_timing_derate -cell_check -late  1.03 $cell
    }
  }

