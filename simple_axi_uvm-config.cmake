# - Config file for the simple_axi_uvm package
# It defines the following variables
#  simple_axi_uvm_INCLUDE_DIRS      - include directories for simple_axi_uvm package
#  simple_axi_uvm_SRC_FILES         - source files for implementation.
#  simple_axi_uvm_TESTBENCH_FILES   - testbench files for simulation.
#  simple_axi_uvm_DEFINITIONS_VLOG  - additional compile option for vlog.

# Compute paths
set(simple_axi_uvm_INCLUDE_DIRS "${CMAKE_CURRENT_LIST_DIR}/include")
set(simple_axi_uvm_SRC_FILES "") #empty. this package is simulation only.
set(simple_axi_uvm_TESTBENCH_FILES "${CMAKE_CURRENT_LIST_DIR}/src")
set(simple_axi_uvm_DEFINITIONS_VLOG "-i ${simple_axi_uvm_INCLUDE_DIRS}")

