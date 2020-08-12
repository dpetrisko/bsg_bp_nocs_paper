
set router_ref_name [get_attribute [get_cells *router*] ref_name]
set flit_width [lindex [split $router_ref_name "_"] 5]
set link_width [expr $flit_width + 2]
set dims       [lindex [split $router_ref_name "_"] 6]
set dirs       [lindex [split $router_ref_name "_"] 7]
set len_width  [lindex [split $router_ref_name "_"] 8]

set nets [sizeof_collection [get_cells -hier *router*]]

# Tracks between adjacent pins (K layers require 2 spaces to alternate pins)
#   so we divide by 2 in the calculation and pin placement script
set tracks 4

# Enough space on the sides for bidirectional links for each net + 20 tracks of corner padding
set side_length [expr 0.384 * 10 + $tracks / 2 * 0.384 * $link_width * $nets + 0.384 * 10]

initialize_floorplan        \
  -control_type die         \
  -coincident_boundary true \
  -shape R                  \
  -core_offset 0.0          \
  -side_length [list $side_length $side_length]

