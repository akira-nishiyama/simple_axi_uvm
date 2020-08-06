class simple_axi_master_driver extends uvm_driver #(simple_axi_seq_item);
    `uvm_component_utils(simple_axi_master_driver)
    virtual simple_axi_if vif;
    function new (string name ="simple_axi_master_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual simple_axi_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
    endfunction: build_phase

    task run_phase(uvm_phase phase);
        simple_axi_seq_item trans_item;
        uvm_report_info("DRIVER", "Hi! I am sample_driver");
        @(posedge vif.arstn);// wait negate reset
        forever begin
            seq_item_port.get_next_item(trans_item);
            // get several value from trans_item and drive
            // signals, receive signals via virtual interface
            seq_item_port.item_done();
        end
    endtask
endclass

