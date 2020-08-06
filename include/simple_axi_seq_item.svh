class simple_axi_seq_item extends uvm_sequence_item;
    typedef enum{READ, WRITE} simple_axi_access_type;
    
    rand logic[31:0]        addr;
    rand logic[31:0]        data[];
    rand logic[7:0]         length;
    simple_axi_access_type  access_type;

    `uvm_object_utils_begin(simple_axi_seq_item)
        `uvm_field_int (addr, UVM_DEFAULT | UVM_HEX)
        `uvm_field_array_int (data, UVM_DEFAULT | UVM_HEX)
        `uvm_field_int (length, UVM_DEFAULT | UVM_DEC)
        `uvm_field_enum (simple_axi_access_type, access_type, UVM_DEFAULT)
    `uvm_object_utils_end
    function new (string name = "simple_axi_seq_item_inst");
        super.new(name);
    endfunction : new
endclass

