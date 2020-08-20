
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

      if (aux_type_gp == 0)
        begin : passthrough
          assign links_li[j][dirs_lp-1:W] = links_i[j][dirs_lp-1:W];
          assign links_li[j][P]           = links_lo[j][P];
        end
      else if (aux_type_gp == 1)
        begin : chain
          for (genvar i = W; i < dirs_lp; i++)
            begin : dirs
              logic [aux_width_gp-1:0] aux_lo;
              bsg_dff_chain
                #(.width_p(aux_width_gp), .num_stages_p(aux_els_gp))
                chain_block
                 (.clk_i(clk_i)

                  ,.data_i(links_lo[j][i][0+:aux_width_gp])
                  ,.data_o(aux_lo)
                  );
              assign links_li[j][i][0+:aux_width_gp] = my_cord_i[j] ? links_i[j][i][0+:aux_width_gp] : aux_lo;
              for (genvar k = aux_width_gp; k < link_width_lp; k++)
                begin : tieoff
                  assign links_li[j][i][k] = links_i[j][i][k];
                end
            end
          assign links_li[j][P] = links_lo[j][P];
        end
      else if (aux_type_gp == 2)
        begin : sram
          logic [aux_els_gp-1:0][31:0] sram_data_lo;
          for (genvar i  = 0; i < aux_els_gp; i++)
            begin : b
              // We use 64x32 as an sram atomic unit
              wire v_li = my_cord_i[0];
              wire w_li = my_cord_i[1];
              wire [5:0] addr_li = my_cord_i[0+:6];
              wire [31:0] data_li = links_lo[j][P][0+:32];
              bsg_mem_1rw_sync
               #(.width_p(32), .els_p(64))
               bank
                (.clk_i(clk_i)
                 ,.reset_i(reset_i)

                 ,.v_i(v_li)
                 ,.w_i(w_li)
                 ,.addr_i(addr_li)
                 ,.data_i(data_li)
                 ,.data_o(sram_data_lo[i])
                 );
            end
          assign links_li[j][dirs_lp-1:W] = links_i[j][dirs_lp-1:W];
          assign links_li[j][P][0+:32] = {32{&sram_data_lo}};
          for (genvar k = 32; k < link_width_lp; k++)
            begin : tieoff
              assign links_li[j][P][k] = links_i[j][P][k];
            end
        end
    end

endmodule

