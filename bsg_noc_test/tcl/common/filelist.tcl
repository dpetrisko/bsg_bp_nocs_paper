#------------------------------------------------------------
# Do NOT arbitrarily change the order of files. Some module
# and macro definitions may be needed by the subsequent files
#------------------------------------------------------------

set bsg_chip_dir           $::env(BSG_CHIP_DIR)
set basejump_stl_dir       $::env(BASEJUMP_STL_DIR)
set black_parrot_dir       $::env(BLACK_PARROT_DIR)
set bsg_designs_dir        $::env(BSG_DESIGNS_DIR)
set bsg_designs_target_dir $::env(BSG_DESIGNS_TARGET_DIR)
set bsg_packaging_dir      $::env(BSG_PACKAGING_DIR)
#set hardfloat_dir          $::env(HARDFLOAT_DIR)
set hardfloat_dir "/home/petrisko/tapeout/bsg_berkeley_hardfloat/toplevels/bsg_berkeley_hardfloat_rc0/HardFloat"

set bsg_package           $::env(BSG_PACKAGE)
set bsg_pinout            $::env(BSG_PINOUT)
set bsg_padmapping        $::env(BSG_PADMAPPING)
set bsg_packaging_foundry $::env(BSG_PACKAGING_FOUNDRY)

set SVERILOG_INCLUDE_PATHS [join "
  ${hardfloat_dir}/source/
  ${hardfloat_dir}/source/RISCV/
  ${bsg_designs_target_dir}/v/
"]

set SVERILOG_PACKAGE_FILES [join "
  $hardfloat_dir/source/HardFloat_specialize.vi
"]

# Best Practice: Keep bsg_defines first, then all pacakges (denoted by ending
# in _pkg). The rest of the files should allowed in any order.
set SVERILOG_SOURCE_FILES [join "
  $SVERILOG_PACKAGE_FILES
  $hardfloat_dir/source/HardFloat_specialize.v
  $hardfloat_dir/source/fNToRecFN.v
  $hardfloat_dir/source/iNToRecFN.v
  $hardfloat_dir/source/recFNToIN.v
  $hardfloat_dir/source/recFNToFN.v
  $hardfloat_dir/source/isSigNaNRecFN.v
  $hardfloat_dir/source/addRecFN.v
  $hardfloat_dir/source/mulRecFN.v
  $hardfloat_dir/source/mulAddRecFN.v
  $hardfloat_dir/source/compareRecFN.v
  $bsg_designs_target_dir/v/hardfloat_top.v
"]

