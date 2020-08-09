
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
 #(localparam link_width_lp = `bsg_ready_and_link_sif_width(flit_width_gp)
   , localparam dirs_lp = 2*dims_gp+1
   )
  (input logic                                     clk_i
   , input logic                                   reset_i
  
   , input logic [cord_width_gp-1:0]               my_cord_i

   , input logic  [dirs_lp-1:0][link_width_lp-1:0] links_i
   , output logic [dirs_lp-1:0][link_width_lp-1:0] links_o
  
   , input logic [aux_width_gp-1:0]                aux_i
   , output logic [aux_width_gp-1:0]               aux_o
   );

  `declare_bsg_ready_and_link_sif_s(flit_width_gp, bsg_ready_and_link_sif_s);
  bsg_ready_and_link_sif_s [dirs_lp-1:0] links_li, links_lo;

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
     ,.link_i(links_li)
     ,.link_o(links_lo)
     );

  if (aux_type_gp == 1)
    begin : none
      assign links_li = links_i;
      assign links_o = links_lo;
    end
  else if (aux_type_gp == 2)
    begin : shift
      for (genvar i = 0; i < dirs_lp; i++)
        begin : dir
          logic [aux_width_gp-1:0] shifted_lo;
          bsg_dff_chain
           #(.width_p(aux_width_gp), .num_stages_p(aux_els_gp))
           shift
            (.clk_i(clk_i)
             ,.data_i(links_lo[i][0+:aux_width_gp])
             ,.data_o(shifted_lo)
             );

          assign links_li[i] = aux_i[i] ? link_width_lp'(shifted_lo) : links_i[i];
        end
    end
  else if (aux_type_gp == 3)
    begin : sram
      // Effectively random toggle
      wire v_li = my_cord_i[0];
      wire w_li = my_cord_i[1];
      wire [`BSG_SAFE_CLOG2(aux_els_gp)-1:0] addr_li = links_i;
      bsg_mem_1rw_sync_mask_write_byte
       #(.data_width_p(aux_width_gp), .els_p(aux_els_gp))
       mem
        (.clk_i(clk_i)
         ,.reset_i(reset_i)

         ,.v_i(v_li)
         ,.w_i(w_li)
         ,.addr_i(addr_li)
         ,.write_mask_i('1)

         // I/O
         ,.data_i(aux_i)
         ,.data_o(aux_o)
         );
    end
  else
    begin : error
      $fatal(1, "One of aux_none, aux_shift or aux_sram must be set");
    end

endmodule

