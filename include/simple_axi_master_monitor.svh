class simple_axi_master_monitor extends uvm_monitor;
    `uvm_component_utils(simple_axi_master_monitor)
    virtual simple_axi_if vif;
    function new(string name="simple_axi_master_monitor", uvm_component parent);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual simple_axi_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set for:", get_full_name(), ".vif"});
    endfunction: build_phase
    task run_phase(uvm_phase phase);
        uvm_report_info("MONITOR","Hi! I am sample_monitor");
        fork
            //check_clock;
            //check_trans;
        join
    endtask
    task check_trans;
        forever begin
            @(posedge vif.axi_awvalid) uvm_report_info("AXI-MON", $sformatf("addr=%08Xh", vif.axi_awaddr));
        end
    endtask;
    task check_clock;
        forever begin
            wait(vif.aclk===1'b0);
            uvm_report_info("MON", "fall clock");
            wait(vif.aclk===1'b1);
            uvm_report_info("MON", "rise clock");
        end
    endtask
endclass

