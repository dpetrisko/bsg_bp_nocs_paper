
set basejump_stl_dir        $::env(BASEJUMP_STL_DIR)
set bsg_designs_target_dir  $::env(BSG_DESIGNS_TARGET_DIR)

set bsg_packaging_dir $::env(BSG_PACKAGING_DIR)
set bsg_package       $::env(BSG_PACKAGE)
set bsg_pinout        $::env(BSG_PINOUT)
set bsg_padmapping    $::env(BSG_PADMAPPING)

set SVERILOG_INCLUDE_PATHS [join "
  $basejump_stl_dir/bsg_clk_gen
  $basejump_stl_dir/bsg_dataflow
  $basejump_stl_dir/bsg_mem
  $basejump_stl_dir/bsg_misc
  $basejump_stl_dir/bsg_test
  $basejump_stl_dir/bsg_noc
  $basejump_stl_dir/bsg_tag
"]
