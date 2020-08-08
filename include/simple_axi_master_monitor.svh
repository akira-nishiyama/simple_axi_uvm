// simple_axi_master_monitor.svh
//      This file implements the monitor for simple_axi_master.
//      Reset behavior is not supported.
//
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

class simple_axi_master_monitor extends uvm_monitor;
    `uvm_component_utils(simple_axi_master_monitor)
    virtual simple_axi_if vif;
    uvm_analysis_port #(simple_axi_seq_item) item_port;
    simple_axi_seq_item awchannel_item[$];
    simple_axi_seq_item wchannel_item[$];
    simple_axi_seq_item bchannel_item[$];
    simple_axi_seq_item archannel_item[$];
    simple_axi_seq_item rchannel_item[$];
    function new(string name="simple_axi_master_monitor", uvm_component parent);
        super.new(name, parent);
        item_port = new("item_port",this);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual simple_axi_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set for:", get_full_name(), ".vif"});
    endfunction: build_phase
    task run_phase(uvm_phase phase);
        @(posedge vif.arstn);//wait for negate reset.
        fork
            check_awchannel();
            check_wchannel();
            check_bchannel();
            check_archannel();
            check_rchannel();
            check_write_trans();
            check_read_trans();
        join
    endtask

    task check_awchannel();
        simple_axi_seq_item mon_item;
        forever begin
            @(posedge vif.aclk);
            if(vif.axi_awvalid === 1 && vif.axi_awready === 1) begin
                mon_item = new();
                mon_item.addr = vif.axi_awaddr;
                mon_item.length = vif.axi_awlen;
                awchannel_item.push_back(mon_item);
            end
        end
    endtask

    task check_wchannel();
        simple_axi_seq_item mon_item;
        int i = 0;
        mon_item = new();
        forever begin
            @(posedge vif.aclk);
            if(vif.axi_wvalid === 1 && vif.axi_wready === 1) begin
                mon_item.data[i] = vif.axi_wdata;
                ++i;
            end
            if(vif.axi_wlast === 1 && vif.axi_wvalid === 1 && vif.axi_wready === 1) begin
                wchannel_item.push_back(mon_item);
                mon_item = new();//prepare for next transaction
                i = 0;//prepare for next transaction
            end
        end
    endtask

    task check_bchannel();
        simple_axi_seq_item mon_item;
        forever begin
            @(posedge vif.aclk);
            if(vif.axi_bvalid === 1 && vif.axi_bready === 1) begin
                mon_item = new();
                case(vif.axi_bresp)
                    2'b00: mon_item.resp_code = simple_axi_seq_item::OKAY;
                    2'b01: mon_item.resp_code = simple_axi_seq_item::EXOKAY;
                    2'b10: mon_item.resp_code = simple_axi_seq_item::SLVERR;
                    2'b11: mon_item.resp_code = simple_axi_seq_item::DECERR;
                endcase
                bchannel_item.push_back(mon_item);
            end
        end
    endtask

    task check_archannel();
        simple_axi_seq_item mon_item;
        forever begin
            @(posedge vif.aclk);
            if(vif.axi_arvalid === 1 && vif.axi_arready === 1) begin
                mon_item = new();
                mon_item.addr = vif.axi_araddr;
                mon_item.length = vif.axi_arlen;
                archannel_item.push_back(mon_item);
            end
        end
    endtask

    task check_rchannel();
        simple_axi_seq_item mon_item;
        int i = 0;
        mon_item = new();
        forever begin
            @(posedge vif.aclk);
            if(vif.axi_rvalid === 1 && vif.axi_rready === 1) begin
                mon_item.data[i] = vif.axi_rdata;
                ++i;
            end
            if(vif.axi_rlast === 1 && vif.axi_rvalid === 1 && vif.axi_rready === 1) begin
                case(vif.axi_rresp)
                    2'b00: mon_item.resp_code = simple_axi_seq_item::OKAY;
                    2'b01: mon_item.resp_code = simple_axi_seq_item::EXOKAY;
                    2'b10: mon_item.resp_code = simple_axi_seq_item::SLVERR;
                    2'b11: mon_item.resp_code = simple_axi_seq_item::DECERR;
                endcase
                rchannel_item.push_back(mon_item);
                mon_item = new();//prepare for next transaction
                i = 0;//prepare for next transaction
            end
        end
    endtask

    task check_write_trans();
        simple_axi_seq_item mon_item;
        simple_axi_seq_item bch;
        simple_axi_seq_item wch;
        simple_axi_seq_item awch;
        forever begin
            mon_item = new();
            wait(bchannel_item.size() != 0);
            bch  = bchannel_item.pop_front();
            if(wchannel_item.size() == 0) `uvm_error("AXI-M-MON-WCHK","write channel transaction mismatch.");
            wch  = wchannel_item.pop_front();
            if(awchannel_item.size() == 0) `uvm_error("AXI-M-MON-WCHK","address write channel transaction mismatch.");
            awch = awchannel_item.pop_front();
            mon_item.addr        = awch.addr;
            mon_item.length      = awch.length;
            mon_item.data        = wch.data;
            mon_item.access_type = simple_axi_seq_item::WRITE;
            mon_item.resp_code   = bch.resp_code;
            if(mon_item.length + 1 != mon_item.data.size())
                `uvm_error("AXI-M-MON-WCHK", $sformatf("length %0d and amount of data %d mismatch.", mon_item.length, mon_item.data.size()));
            uvm_report_info("AXI-M-MON-WCHK",
                $sformatf("write_transaction: addr=%08xh, length=%0d, resp_code=%p",mon_item.addr,mon_item.length, mon_item.resp_code),
                UVM_LOW);
            foreach(mon_item.data[i]) uvm_report_info("AXI-M-MON-WCHK",$sformatf("data[%3d]=%08xh",i,mon_item.data[i]),UVM_LOW);
            item_port.write(mon_item);
        end
    endtask;

    task check_read_trans();
        simple_axi_seq_item mon_item;
        simple_axi_seq_item arch;
        simple_axi_seq_item rch;
        forever begin
            mon_item = new();
            wait(rchannel_item.size() != 0);
            rch = rchannel_item.pop_front();
            if(archannel_item.size() == 0) `uvm_error("AXI-M-MON-RCHK", "read channel transaction mismatch.");
            arch = archannel_item.pop_front();
            mon_item.addr           = arch.addr;
            mon_item.length         = arch.length;
            mon_item.data           = rch.data;
            mon_item.access_type    = simple_axi_seq_item::READ;
            mon_item.resp_code      = rch.resp_code;
            if(mon_item.length + 1 != mon_item.data.size())
                `uvm_error("AXI-M-MON-RCHK", $sformatf("length %0d and amount of data %d mismatch.", mon_item.length, mon_item.data.size()));
            uvm_report_info("AXI-M-MON-RCHK",
                $sformatf("write_transaction: addr=%08xh, length=%0d, resp_code=%p",mon_item.addr,mon_item.length, mon_item.resp_code),
                UVM_LOW);
            foreach(mon_item.data[i]) uvm_report_info("AXI-M-MON-RCHK",$sformatf("data[%3d]=%08xh",i,mon_item.data[i]),UVM_LOW);
            item_port.write(mon_item);
        end
    endtask
endclass

