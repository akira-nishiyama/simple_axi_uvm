class tb_simple_axi_uvm_env extends uvm_env;
    `uvm_component_utils(tb_simple_axi_uvm_env)
    `uvm_new_func
    simple_axi_master_agent agent;
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = simple_axi_master_agent::type_id::create("simple_axi_master_agent",this);
    endfunction
endclass

