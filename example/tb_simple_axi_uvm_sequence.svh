// tb_simple_axi_uvm_sequence
//      This file implements the sequence for simple_axi_uvm_pkg.
//      
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

class issue_one_trans_seq extends simple_axi_master_base_sequence;
    `uvm_object_utils(issue_one_trans_seq)
    function new(string name="issue_one_trans_seq");
        super.new(name);
    endfunction
  virtual task body();
    simple_axi_seq_item trans_item;
    `uvm_create(trans_item)
    trans_item.addr = 32'h12345678;
    trans_item.data = {32'h01020304,32'h05060708};
    trans_item.length = 1;
    trans_item.access_type = simple_axi_seq_item::WRITE;
    `uvm_send(trans_item)
    #1000;
  endtask
endclass

class issue_read_write_trans_seq extends simple_axi_master_base_sequence;
    `uvm_object_utils(issue_read_write_trans_seq)
    function new(string name="issue_read_write_trans_seq");
        super.new(name);
    endfunction
    virtual task body();
        simple_axi_seq_item trans_item;
        `uvm_create(trans_item);
        transfer_item(.trans_item(trans_item), .addr(32'h12345678), .data({32'h01020304, 32'h05060708}), .length(1), .access_type(simple_axi_seq_item::WRITE));
        transfer_item(.trans_item(trans_item), .addr(32'h11223344), .data({32'h55667788, 32'haabbccdd}), .length(1), .access_type(simple_axi_seq_item::WRITE));
        transfer_item(.trans_item(trans_item), .addr(32'h12345678), .data(), .length(1), .access_type(simple_axi_seq_item::READ));
    endtask
endclass

