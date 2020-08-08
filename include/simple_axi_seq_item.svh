// simple_axi_seq_item.svh
//      This file implements the sequence_item for simple_axi.
//      master driver accepts empty data read transaction.
//      The master monitor completes the data field of the transaction and
//      writes it to its own analysis port.
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

class simple_axi_seq_item extends uvm_sequence_item;
    typedef enum{READ, WRITE} simple_axi_access_type;
    typedef enum{OKAY, EXOKAY, SLVERR, DECERR} simple_axi_resp_code;
    
    rand logic[31:0]        addr;
    rand logic[31:0]        data[$];
    rand logic[7:0]         length;
    simple_axi_access_type  access_type;
    simple_axi_resp_code    resp_code;

    `uvm_object_utils_begin(simple_axi_seq_item)
        `uvm_field_int (addr, UVM_DEFAULT | UVM_HEX)
        `uvm_field_queue_int (data, UVM_DEFAULT | UVM_HEX)
        `uvm_field_int (length, UVM_DEFAULT | UVM_DEC)
        `uvm_field_enum (simple_axi_access_type, access_type, UVM_DEFAULT)
        `uvm_field_enum (simple_axi_resp_code, resp_code, UVM_DEFAULT)
    `uvm_object_utils_end
    function new (string name = "simple_axi_seq_item_inst", logic[31:0] addr = 0, logic[31:0] data[$] = {0}, logic[7:0] length = 0,
                    simple_axi_access_type access_type = READ, simple_axi_resp_code resp_code = SLVERR);
        super.new(name);
        this.addr = addr;
        this.data = data;
        this.length = length;
        this.access_type = access_type;
        this.resp_code = resp_code;
    endfunction : new
endclass

