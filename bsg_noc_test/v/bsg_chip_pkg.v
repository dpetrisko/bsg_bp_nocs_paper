
package bsg_chip_pkg;

  // Sweepable: cord+len->N
  localparam flit_width_gp = 32;
  // Sweepable: 1->N
  localparam len_width_gp = 5;
  // Parameter: 1, 2
  localparam dims_gp = 2;

  // Sweepable: 2*K, K>=1
  localparam cord_width_gp = 6;
  localparam cord_dims_gp = 2;
  localparam int cord_markers_pos_gp[cord_dims_gp:0] = '{cord_width_gp, cord_width_gp/2, 0};

  // Sweepable: 1->N
  // co-located logic
  localparam aux_width_gp = 2;

endpackage

