# - Config file for the simple_axi_uvm package
# It defines the following variables
#  simple_axi_uvm_INCLUDE_DIRS      - include directories for simple_axi_uvm package
#  simple_axi_uvm_SRC_FILES         - source files for implementation.
#  simple_axi_uvm_TESTBENCH_FILES   - testbench files for simulation.
#  simple_axi_uvm_DEFINITIONS_VLOG  - additional compile option for vlog.
#  simple_axi_uvm_DEPENDENCIES      - simple_axi_uvm components list. use for target depends.

# Compute paths
set(simple_axi_uvm_INCLUDE_DIRS "${CMAKE_CURRENT_LIST_DIR}/include")
set(simple_axi_uvm_SRC_FILES "") #empty. this package is for simulation only.
file(GLOB simple_axi_uvm_TESTBENCH_FILES ${CMAKE_CURRENT_LIST_DIR}/src/*.sv)
set(simple_axi_uvm_DEFINITIONS_VLOG "-i ${simple_axi_uvm_INCLUDE_DIRS}")
file(GLOB simple_axi_uvm_DEPENDENCIES   ${CMAKE_CURRENT_LIST_DIR}/include/*.svh
                                        ${CMAKE_CURRENT_LIST_DIR}/src/*.sv)
