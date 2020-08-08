// simple_axi_master_sequencer.svh
//      This file implements the sequencer for simple_axi_master.
//      
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

class simple_axi_master_sequencer extends uvm_sequencer #(simple_axi_seq_item);
    `uvm_component_utils(simple_axi_master_sequencer)
    `uvm_new_func
    task run_phase(uvm_phase phase);
        uvm_report_info("SEQR","Hi I am Sequencer");
    endtask
endclass

