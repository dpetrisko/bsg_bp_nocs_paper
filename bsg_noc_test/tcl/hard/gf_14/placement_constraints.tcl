
current_design ${DESIGN_NAME}

# Start script fresh
set_locked_objects -unlock [get_cells -hier]
remove_bounds -all
remove_edit_groups -all

set keepout_margin_x 2
set keepout_margin_y 2
set keepout_margins [list $keepout_margin_x $keepout_margin_y $keepout_margin_x $keepout_margin_y]

set aux_mems [get_cells -hier -filter "ref_name=~gf14_*"]

create_keepout_margin -type hard -outer $keepout_margins $aux_mems
