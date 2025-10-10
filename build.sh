#!/bin/bash

BUILDDIR="/tmp/cbuild"
CPWD=$(pwd)
SOURCE_FOLDER=$CPWD/src
CONSTR_FOLDER=$CPWD/constr
PART_NUM="xc7a15tcsg325-1"
TOP_MODULE="main"

export XILINX_VIVADO=/home/raiku/Misc/Vivado/Vivado/2024.2
export XILINX_VITIS=/home/raiku/Misc/Vivado/Vitis/2024.2
export XILINX_HLS=/home/raiku/Misc/Vivado/Vitis/2024.2

export PATH=/home/raiku/Misc/Vivado/Vivado/2024.2/bin:$PATH
export PATH=/home/raiku/Misc/Vivado/DocNav:$PATH
export PATH=/home/raiku/Misc/Vivado/Model_Composer/2024.2/bin:$PATH
export PATH=/home/raiku/Misc/Vivado/Vitis/2024.2/bin:$PATH
export PATH=/home/raiku/Misc/Vivado/Vitis_HLS/2024.2/bin:$PATH

usage() {
  echo "Usage ./build.sh <synth|implement|upload>"
  exit 1
}

if [ "$#" != "1" ]; then
  usage
fi

case $1 in
  synth) ;; 
  readd) ;; 
  implement) ;; 
  upload) ;;
  *) usage ;; 
esac

rm -rf $BUILDDIR
mkdir $BUILDDIR
cd $BUILDDIR

echo "# I love 鳳凰院 凶真" > a.tcl

echo "open_project $CPWD/vivado/rv32i.xpr" >> a.tcl

readd() {
  echo "add_files [glob $SOURCE_FOLDER/*.sv]" >> a.tcl
  echo "add_files [glob $SOURCE_FOLDER/*.v]" >> a.tcl
  echo "add_files [glob $CONSTR_FOLDER/*.xdc]" >> a.tcl
  echo 'update_compile_order -fileset sources_1' >> a.tcl
}

synth() {
  echo 'reset_run synth_1' >> a.tcl
  echo 'launch_runs synth_1' >> a.tcl
  echo 'wait_on_run synth_1' >> a.tcl
}

implement() {
  echo 'reset_run impl_1' >> a.tcl
  echo 'launch_runs impl_1 -to_step write_bitstream -jobs 16' >> a.tcl
  echo 'wait_on_run impl_1' >> a.tcl
}

bitstream() {
  echo 'open_run impl_1' >> a.tcl
  echo 'write_bitstream -force ./vivado/rv32i.xpr' >> a.tcl
}

upload() {
  echo 'open_hw' >> a.tcl
  echo 'connect_hw_server' >> a.tcl
  echo 'open_hw_target' >> a.tcl
  echo 'set_property PROGRAM.FILE {./vivado/rv32i.bit} [current_hw_device]' >> a.tcl
  echo 'program_hw_devices [current_hw_device]' >> a.tcl
  echo 'close_hw' >> a.tcl
}

    # /Exiting Vivado at/ { system("killall -9 vivado"); next }
run() {
  stdbuf -o0 -e0 vivado -mode batch -source a.tcl 2>&1 | awk '
    function color(c,s) { printf("\033[%dm%s\033[0m\n",30+c,s) }
    /^ERROR:/   { color(1, $0); next }
    /^WARNING:/ { color(3, $0); next }
    /^INFO:/    { color(2, $0); next }
    { print; }
  '
}

case $1 in
  readd) readd ;; 
  synth) synth ;; 
  implement) synth && implement ;; 
  upload) synth && implement && bitstream && upload ;;
  *) echo "Error in second how the fuck?" ;; 
esac

run

# Read source files
# read_verilog -sv "main.sv"
# read_xdc "rv32i.xdc"

# Synthesis + Lint
# synth_design -top "top" -part "xc7a35ticsg324-1L" -lint
# write_checkpoint -force post_synth.dcp
# report_utilization -file post_synth_util.rpt

# Implementation
# opt_design
# place_design
# route_design
# write_bitstream -force design.bit

# Program FPGA
# open_hw_manager
# connect_hw_server
# open_hw_target [lindex [get_hw_targets -of_objects [get_hw_servers localhost*]] 0]
# set thefpga [lindex [get_hw_devices] 0]
# set_property PROGRAM.FILE "design.bit" $thefpga
# refresh_hw_device -update_hw_probes false $thefpga
# program_hw_devices $thefpga
