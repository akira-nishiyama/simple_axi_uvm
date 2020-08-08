// simple_axi_master_agent.svh
//      This file implements the simple_axi_master_agent.
//      simple_axi_master is consists of driver, sequencer and monitor.
//      
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//
class simple_axi_master_agent extends uvm_agent;
    `uvm_component_utils(simple_axi_master_agent)
    `uvm_new_func
    simple_axi_master_driver       driver;
    simple_axi_master_sequencer    sequencer;
    simple_axi_master_monitor      monitor;
    function void build_phase(uvm_phase phase);
        driver = simple_axi_master_driver::type_id::create("simple_axi_driver",this);
        sequencer = simple_axi_master_sequencer::type_id::create("simple_axi_sequencer",this);
        monitor = simple_axi_master_monitor::type_id::create("simple_axi_monitor",this);
    endfunction
    function void connect_phase(uvm_phase phase);
        if(get_is_active() == UVM_ACTIVE) begin
            uvm_report_info("AGENT", "connect simple_axi_master_driver to simple_axi_master_sequencer");
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction
    task run_phase(uvm_phase phase);
    endtask
endclass

