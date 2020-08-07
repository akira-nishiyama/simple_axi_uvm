class issue_one_trans_seq extends simple_axi_master_base_sequence;
    `uvm_object_utils(issue_one_trans_seq)
    function new(string name="issue_one_trans_seq");
        super.new(name);
    endfunction
  virtual task body();
    simple_axi_seq_item trans_item;
    $display("I am issue_one_trans_seq");
    `uvm_create(trans_item)
    trans_item.addr = 32'h12345678;
    trans_item.data = {32'h01020304,32'h05060708};
    trans_item.length = 1;
    trans_item.access_type = simple_axi_seq_item::WRITE;
    `uvm_send(trans_item)
    #1000;
  endtask
endclass

