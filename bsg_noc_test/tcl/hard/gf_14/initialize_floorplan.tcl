
set router_ref_name [get_attribute [get_cells *router*] ref_name]
set flit_width [lindex [split $router_ref_name "_"] 5]
set link_width [expr $flit_width + 2]
set dims       [lindex [split $router_ref_name "_"] 6]
set dirs       [lindex [split $router_ref_name "_"] 7]
set len_width  [lindex [split $router_ref_name "_"] 8]

set nets [sizeof_collection [get_cells -hier *router*]]

# Tracks between adjacent pins (K layers require 2 spaces to alternate pins)
#   so we divide by 2 in the calculation and pin placement script
#set tracks $::env(TRACKS)
#set layers $::env(LAYERS)

#set k_pitch 0.128
#set link_pin_length [expr 2*$nets*$tracks/$layers*$link_width*$k_pitch]

# Adding a single pin of padding on each corner
#set side_length [expr $tracks*$k_pitch + $link_pin_length + $tracks*$k_pitch]

set side_length $::env(SIDE)

initialize_floorplan        \
  -control_type die         \
  -coincident_boundary true \
  -shape R                  \
  -core_offset 0.0          \
  -side_length [list $side_length $side_length]

