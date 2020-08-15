
//==============================================================================
//
// BSG CHIP
//
// This is the toplevel for the ASIC. This chip uses the UW BGA package found
// inside bsg_packaging/uw_bga. For physical design reasons, the input pins
// have been swizzled (ie. re-arranged) from their original meaning. We use the
// bsg_chip_swizzle_adapter in every ASIC to abstract away detail.
//

`include "bsg_defines.v"
`include "bsg_noc_links.vh"
`include "bsg_wormhole_router.vh"

module bsg_chip
 import bsg_chip_pkg::*;
 import bsg_noc_pkg::*;
 #(localparam link_width_lp = `bsg_ready_and_link_sif_width(flit_width_gp)
   , localparam dirs_lp = 2*dims_gp+1
   )
  (input logic                                                      clk_i
   , input logic                                                    reset_i
  
   , input logic [cord_width_gp-1:0]                                my_cord_i

   , input logic  [networks_gp-1:0][dirs_lp-1:W][link_width_lp-1:0] links_i
   , output logic [networks_gp-1:0][dirs_lp-1:W][link_width_lp-1:0] links_o
   );

  `declare_bsg_ready_and_link_sif_s(flit_width_gp, bsg_ready_and_link_sif_s);
  bsg_ready_and_link_sif_s [networks_gp-1:0][dirs_lp-1:0] links_li, links_lo;

  for (genvar j = 0; j < networks_gp; j++)
    begin : rtr
      bsg_wormhole_router
       #(.flit_width_p(flit_width_gp)
         ,.dims_p(dims_gp)
         ,.cord_dims_p(cord_dims_gp)
         ,.cord_markers_pos_p(cord_markers_pos_gp)
         ,.len_width_p(len_width_gp)
         )
       router
        (.clk_i(clk_i)
         ,.reset_i(reset_i)

         ,.my_cord_i(my_cord_i)
         ,.link_i(links_li[j])
         ,.link_o(links_lo[j])
         );
      assign links_o[j] = links_lo[j][dirs_lp-1:W];

      assign links_li[j][dirs_lp-1:W] = links_i[j][dirs_lp-1:W];
      assign links_li[j][P]           = links_lo[j][P];
    end

endmodule

