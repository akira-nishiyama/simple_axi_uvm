module tb_simple_axi_uvm;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    //import simpla_axi_uvm_pkg::*;
    import tb_simple_axi_uvm_test_pkg::*;
    
    logic clk, rstz;
    simple_axi_if sif(.aclk(clk), .arstn(rstz));// interface
    initial begin
        fork
            begin
                clk = 1'b1;
                #100;
                forever #50 clk = ~clk;
            end
            begin
                rstz = 1'b0;
                #100;
                rstz = 1'b1;
            end
        join
    end
    initial begin
        `uvm_info("info", "Hello World from initial block", UVM_LOW)
        uvm_config_db#(virtual simple_axi_if)::set(uvm_root::get(), "*", "vif", sif);
        run_test("simple_axi_uvm_test_example");
    end


endmodule
