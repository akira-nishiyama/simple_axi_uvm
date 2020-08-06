class simple_axi_master_sequencer extends uvm_sequencer #(simple_axi_seq_item);
    `uvm_component_utils(simple_axi_master_sequencer)
    `uvm_new_func
    task run_phase(uvm_phase phase);
        uvm_report_info("SEQR","Hi I am Sequencer");
    endtask
endclass

