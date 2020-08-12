remove_individual_pin_constraints
remove_block_pin_constraints

### Just make sure that other layers are not used.

set_block_pin_constraints -allowed_layers { C4 C5 K1 K2 K3 K4 }

set router_ref_name [get_attribute [get_cells -hier *router*] ref_name]
set flit_width [lindex [split $router_ref_name "_"] 5]
set link_width [expr $flit_width + 2]
set dims       [lindex [split $router_ref_name "_"] 6]
set dirs       [lindex [split $router_ref_name "_"] 7]
set len_width  [lindex [split $router_ref_name "_"] 8]

set nets [sizeof_collection [get_cells -hier *router*]]

set tracks $::env(TRACKS)
set layers $::env(LAYERS)

if {$layers == 2} {
  set hor_layers  "K1 K3"
  set ver_layers "K2 K4"
} else {
  set hor_layers  "K1"
  set ver_layers "K2"
}

set start_x [expr 10*0.384]
set start_y [expr 10*0.384]

set link_i_pins [get_ports -filter "name=~*links_i*"]
set link_o_pins [get_ports -filter "name=~*links_o*"]
for {set net 0} {$net < $nets} {incr net} {
  if {$dims == 2} {
    set link_S_pins [index_collection $link_i_pins [expr 0*$link_width] [expr 1*$link_width-1]]
    append_to_collection link_S_pins [index_collection $link_o_pins [expr 0*$link_width] [expr 1*$link_width-1]]
    set link_N_pins [index_collection $link_i_pins [expr 1*$link_width] [expr 2*$link_width-1]]
    append_to_collection link_N_pins [index_collection $link_o_pins [expr 1*$link_width] [expr 2*$link_width-1]]

    set start_x [bsg_pins_line_constraint $link_N_pins $ver_layers top $start_x "self" $link_S_pins $tracks 0]

    set link_E_pins [index_collection $link_i_pins [expr 2*$link_width] [expr 3*$link_width-1]]
    append_to_collection link_E_pins [index_collection $link_o_pins [expr 2*$link_width] [expr 3*$link_width-1]]
    set link_W_pins [index_collection $link_i_pins [expr 3*$link_width] [expr 4*$link_width-1]]
    append_to_collection link_W_pins [index_collection $link_o_pins [expr 3*$link_width] [expr 4*$link_width-1]]

    set start_y [bsg_pins_line_constraint $link_W_pins $hor_layers left $start_y "self" $link_E_pins $tracks 0]

    set link_i_pins [remove_from_collection $link_i_pins [index_collection $link_i_pins 0 [expr 4*$link_width-1]]]
    set link_o_pins [remove_from_collection $link_o_pins [index_collection $link_o_pins 0 [expr 4*$link_width-1]]]
  } else {
    set link_E_pins [index_collection $link_i_pins [expr 0*$link_width] [expr 1*$link_width-1]]
    append_to_collection link_E_pins [index_collection $link_o_pins [expr 0*$link_width] [expr 1*$link_width-1]]
    set link_W_pins [index_collection $link_i_pins [expr 1*$link_width] [expr 2*$link_width-1]]
    append_to_collection link_W_pins [index_collection $link_o_pins [expr 1*$link_width] [expr 2*$link_width-1]]

    set start_y [bsg_pins_line_constraint $link_W_pins $hor_layers left $start_y "self" $link_E_pins $tracks 0]

    set link_i_pins [remove_from_collection $link_i_pins [index_collection $link_i_pins 0 [expr 2*$link_width-1]]]
    set link_o_pins [remove_from_collection $link_o_pins [index_collection $link_o_pins 0 [expr 2*$link_width-1]]]
  }
}

  set                  misc_pins [get_ports -filter "name=~*clk_i*"]
  append_to_collection misc_pins [get_ports -filter "name=~*reset_i*"]
  append_to_collection misc_pins [get_ports -filter "name=~*my_cord_i*"]

  set_individual_pin_constraints -ports $misc_pins -allowed_layers "C5" -side 2

