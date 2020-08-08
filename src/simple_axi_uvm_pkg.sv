// simple_axi_uvm_pkg.sv
//      This file implements the simple_axi_uvm_pkg for simulation with uvm.
//      
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

package simple_axi_uvm_pkg;

    `include "uvm_macros.svh"
    import uvm_pkg::*;
    `include "simple_axi_seq_item.svh"
    `include "simple_axi_master_sequencer.svh"
    `include "simple_axi_master_driver.svh"
    `include "simple_axi_master_monitor.svh"
    `include "simple_axi_master_agent.svh"
    `include "simple_axi_master_base_sequence.svh"
endpackage

