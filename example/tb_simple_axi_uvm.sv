// tb_simple_axi_uvm
//      This file implements the testbench for simple_axi_uvm_pkg.
//      
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

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
                forever #10 clk = ~clk;
            end
            begin
                rstz = 1'b0;
                #100;
                rstz = 1'b1;
            end
            begin
                repeat(50) @(posedge clk);
                sif.axi_bvalid <= 1;
                @(posedge clk);
                sif.axi_bvalid <= 0;
                repeat(50) @(posedge clk);
                sif.axi_bvalid <= 1;
                @(posedge clk);
                sif.axi_bvalid <= 0;
                repeat(10) @(posedge clk);
                sif.axi_rvalid <= 1;
                @(posedge clk);
                sif.axi_rlast <= 1;
                @(posedge clk);
                sif.axi_rlast <= 0;
                sif.axi_rvalid <= 0;
            end
        join
    end
    assign sif.axi_arready = 1;
    assign sif.axi_rready = 1;
    assign sif.axi_awready = 1;
    assign sif.axi_wready = 1;
    assign sif.axi_bresp = 0;
    assign sif.axi_rresp = 0;
    assign sif.axi_rdata = 0;
    initial begin
        set_global_timeout(10000ns);
        `uvm_info("info", "Hello World from initial block", UVM_LOW)
        uvm_config_db#(virtual simple_axi_if)::set(uvm_root::get(), "*", "vif", sif);
        uvm_config_db#(bit)::set(uvm_root::get(), "*", "axi_transaction_mode", 0);
        run_test("simple_axi_uvm_test_example");
    end

endmodule
