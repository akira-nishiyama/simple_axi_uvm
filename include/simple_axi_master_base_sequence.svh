// simple_axi_master_base_sequence.svh
//      This file implements the base sequence for simple_axi_master.
//      Base sequence raise_objection in pre_body() and drop_objection in post_body().
//      
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

virtual class simple_axi_master_base_sequence extends uvm_sequence #(simple_axi_seq_item);
    function new(string name="simple_axi_mster_base_sequence");
        super.new(name);
    endfunction
    virtual task pre_body();
        if(starting_phase != null) begin
            `uvm_info(get_type_name(),
                      $sformatf("%s pre_body() raising %s objection",
                      get_sequence_path(),
                      starting_phase.get_name()), UVM_MEDIUM);
            starting_phase.raise_objection(this);
        end
    endtask
    // Drop the objection in the post_body so the objection is removed when
    // the root sequence is complete.
    virtual task post_body();
        if(starting_phase != null) begin
            `uvm_info(get_type_name(),
                      $sformatf("%s post_body() dropping %s objection",
                                get_sequence_path(),
                                starting_phase.get_name()), UVM_MEDIUM);
        starting_phase.drop_objection(this);
        end
    endtask
endclass


