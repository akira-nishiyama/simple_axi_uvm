# simple_axi_uvm
Simple axi verification ip. Main target is vivado simulator.

# Dependency
Vivado 2019.2  
CMake 3.1 or later  
Ninja(Make also works)  
vivado_cmake_helper  

# Setup
- get source
```bash
git clone https://github.com/akira-nishiyama/simple_axi_uvm
```
To use this ip in your FPGA project with Cmake,
You should call find_package(simple_axi_uvm) and below variable is defined.

+ simple_axi_uvm_INCLUDE_DIRS      - include directories for simple_axi_uvm package
+ simple_axi_uvm_SRC_FILES         - source files for implementation.(source file list is empty because simple_axi_uvm is used only simulation)
+ simple_axi_uvm_TESTBENCH_FILES   - testbench files for simulation.(simple_axi_uvm_pkg.sv and simple_axi_if.sv are compile required.)
+ simple_axi_uvm_DEFINITIONS_VLOG  - additional compile option for xvlog. include options are defined.

simple_axi_uvm_env and simple_axi_uvm_test are not provided.

# Usage
Create instance of the simple_axi_master_agent in you test and environment.
axi_transaction_mode is change the behavior of axi_master_driver.
0 for single transaction mode, wait for each transaction end.
1 for burst transaction mode, try to do all transaction sequentially.
see below for single transaction config.

```
uvm_config_db#(bit)::set(uvm_root::get(), "\*", "axi_transaction_mode", 0);
```

Extends simple_axi_baster_base_sequence for you sequence.
The task transfer_item will help you.(defined in simple_axi_base_sequence.svh)
+ transfer_item  
  + simple_axi_seq_item trans_item:  
    the simple_axi_seq_item instance that is created by \`uvm_create  
    (I don't understand \`uvm_create meaning, perhaps wrong way to use.)
  + logic[C_AXI_ADDR_WIDTH - 1 : 0] addr:  
    address for AXI transaction.
  + logic[C_AXI_DATA_WIDTH - 1 : 0] data[$]:  
    data for AXI Write transaction.
    if you do AXI Read transaction, this field shoul be empty.
  + logic[7:0] length  
    length for AXI transaction.
  + simple_axi_seq_item::simple_axi_access_type access_type:  
    Read access for simple_axi_seq_item::READ,  
    Write access for simple_axi_seq_item::WRITE

# Example Setup
- Install Vivado.

- Install CMake and NInja
```bash
apt install cmake ninja-build
```

- Clone vivado_cmake_helper. The path can be anywhere.
```bash
git clone https://github.com/akira-nishiyama/vivado_cmake_helper ~
```

# Example build
```bash
source <vivado_installation_path>/settings64.sh
source ~/vivado_cmake_helper/setup.sh
mkdir build
cd build
cmake .. -GNinja
ninja open_wdb_tb_simple_axi_uvm
```

# License
This software is released under the MIT License, see LICENSE.
