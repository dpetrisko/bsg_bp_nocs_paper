
package bsg_chip_pkg;

  // Number of networks
  localparam networks_gp = BSG_NETWORKS;

  //// Dimensions of the router
  // Parameter: 1, 2
  localparam dims_gp = BSG_DIMS;

  // Sweepable: cord+len->N
  localparam flit_width_gp = BSG_FLIT_WIDTH;

  // Theoeretically sweepable, but we assume 1 flit header + cache line maximum message size and derive
  localparam data_width_gp = 512;
  localparam len_width_gp = `BSG_SAFE_CLOG2(data_width_gp / flit_width_gp);

  // cord of 6 == 8x8 tiles
  localparam row_cord_width_gp = 3;
  localparam cord_dims_gp = 2;
  localparam int cord_markers_pos_gp[cord_dims_gp:0] = '{2*row_cord_width_gp, row_cord_width_gp, 0};
  localparam cord_width_gp = cord_markers_pos_gp[dims_gp];

endpackage

