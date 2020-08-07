class simple_axi_master_driver extends uvm_driver #(simple_axi_seq_item);
    `uvm_component_utils(simple_axi_master_driver)
    virtual simple_axi_if vif;
    simple_axi_seq_item awchannel[$];
    simple_axi_seq_item wchannel[$];
    simple_axi_seq_item bchannel[$];
    simple_axi_seq_item archannel[$];
    simple_axi_seq_item rchannel[$];
    bit awchannel_busy=0;
    bit wchannel_busy=0;
    bit bchannel_busy=0;
    bit archannel_busy=0;
    bit rchannel_busy=0;
    function new (string name ="simple_axi_master_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual simple_axi_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
    endfunction: build_phase

    task run_phase(uvm_phase phase);
        simple_axi_seq_item trans_item;
        uvm_report_info("DRIVER", "Hi! I am sample_driver");
        @(posedge vif.arstn);// wait negate reset
        fork
            forever begin
                seq_item_port.get_next_item(trans_item);
                case(trans_item.access_type)
                    simple_axi_seq_item::WRITE: do_write_transaction(trans_item);
                    simple_axi_seq_item::READ:  do_read_transaction(trans_item);
                endcase
                seq_item_port.item_done();
            end
            run_awchannel();
            run_wchannel();
            run_bchannel();
            run_archannel();
            run_rchannel();
        join
    endtask

    function void check_phase(uvm_phase phase);
        if( awchannel.size() != 0 || wchannel.size() != 0 || bchannel.size() != 0 || archannel.size() != 0 || rchannel.size() != 0 ||
            awchannel_busy   != 0 || wchannel_busy   != 0 || bchannel_busy   != 0 || archannel_busy   != 0 || rchannel_busy   != 0) begin
            `uvm_warning("AXI-M-DRV-CHK",$sformatf("aw_size=%4d,w_size=%4d,b_size=%4d,ar_size=%4d,r_size=%4d",
                                                        awchannel.size(), wchannel.size(), bchannel.size(), archannel.size(), rchannel.size()));
            `uvm_warning("AXI-M-DRV-CHK",$sformatf("aw_busy=%1d,w_busy=%1d,b_busy=%1d,ar_busy=%1d,r_busy=%1d",
                                                        awchannel_busy, wchannel_busy, bchannel_busy, archannel_busy, rchannel_busy));
            `uvm_error("REMAINED DATA",{get_full_name(), "channel data is remained."});
        end
    endfunction

    task do_write_transaction(simple_axi_seq_item trans_item);
        awchannel.push_back(trans_item);
        wchannel.push_back(trans_item);
        bchannel.push_back(trans_item);
    endtask

    task do_read_transaction(simple_axi_seq_item trans_item);
        archannel.push_back(trans_item);
        rchannel.push_back(trans_item);
    endtask

    task run_awchannel();
        simple_axi_seq_item trans_item;
        int sequence_num = 0;
        awchannel_busy = 0;
        forever begin
            wait(awchannel.size() != 0);
            awchannel_busy = 1;
            trans_item = awchannel.pop_front();
            uvm_report_info("AXI-M-DRV-AW", $sformatf("seq=%04d,aw_addr=%08Xh,aw_len=%04Xh",sequence_num, trans_item.addr, trans_item.length));
            vif.axi_awaddr  <= trans_item.addr;
            vif.axi_awlen   <= trans_item.length;
            vif.axi_awvalid <= 1'b1;
            //wait for awready
            forever begin
                @(posedge vif.aclk) if(vif.axi_awready === 1) break;
            end
            vif.axi_awvalid <= 1'b0;
            uvm_report_info("AXI-M-DRV-AW", $sformatf("seq=%04d done",sequence_num));
            awchannel_busy = 0;
            ++sequence_num;
        end
    endtask

    task run_wchannel();
        simple_axi_seq_item trans_item;
        int sequence_num = 0;
        wchannel_busy = 0;
        forever begin
            wait(wchannel.size() != 0);
            wchannel_busy = 1;
            trans_item = wchannel.pop_front();
            for(int i = 0; i < trans_item.length + 1; ++i) begin
                uvm_report_info("AXI-M-DRV-W", $sformatf("seq=%04d,wdata[%3d]=%08Xh",sequence_num, i, trans_item.data[i]));
                vif.axi_wvalid <= 1'b1;
                vif.axi_wdata  <= trans_item.data[i];
                vif.axi_wstrb  <= 4'hf;
                if(i === trans_item.length) vif.axi_wlast <= 1'b1;
                else vif.axi_wlast <= 1'b0;
                //wait for wready
                forever begin
                    @(posedge vif.aclk) if(vif.axi_wready === 1) break;
                end
            end
            vif.axi_wvalid <= 1'b0;
            vif.axi_wlast  <= 1'b0;
            uvm_report_info("AXI-M-DRV-W", $sformatf("seq=%04d done",sequence_num));
            wchannel_busy = 0;
            ++sequence_num;
        end
    endtask

    task run_bchannel();
        simple_axi_seq_item trans_item;
        int sequence_num = 0;
        bchannel_busy = 0;
        uvm_report_info("AXI-M-DRV-B", "bchannel init done.");
        vif.axi_bready <= 1'b1;//always ready
        forever begin
            wait(bchannel.size() != 0);
            uvm_report_info("AXI-M-DRV-B", "bchannel accept.");
            bchannel_busy = 1;
            trans_item = bchannel.pop_front();
            forever begin
                @(posedge vif.aclk) if(vif.axi_bvalid === 1) break;
            end
            uvm_report_info("AXI-M-DRV-B", $sformatf("seq=%04d done",sequence_num));
            bchannel_busy = 0;
            ++sequence_num;
        end
    endtask

    task run_archannel();
        simple_axi_seq_item trans_item;
        int sequence_num = 0;
        archannel_busy = 0;
        forever begin
            wait(archannel.size() != 0);
            archannel_busy = 1;
            uvm_report_info("AXI-M-DRV-AR", $sformatf("seq=%04d,ar_addr=%08Xh,ar_len=%04Xh",sequence_num, trans_item.addr, trans_item.length));
            trans_item = archannel.pop_front();
            vif.axi_araddr  <= trans_item.addr;
            vif.axi_arlen   <= trans_item.length;
            vif.axi_arvalid <= 1'b1;
            //wait for awready
            forever begin
                @(posedge vif.aclk) if(vif.axi_arready === 1) break;
            end
            vif.axi_arvalid <= 1'b0;
            uvm_report_info("AXI-M-DRV-AR", $sformatf("seq=%04d done",sequence_num));
            archannel_busy = 0;
            ++sequence_num;
        end
    endtask

    task run_rchannel();
        simple_axi_seq_item trans_item;
        int sequence_num = 0;
        rchannel_busy = 0;
        vif.axi_rready <= 1'b1;//always ready.
        forever begin
            wait(rchannel.size() != 0);
            rchannel_busy = 1;
            trans_item = rchannel.pop_front();
            for(int i = 0; i < trans_item.length + 1; ++i) begin
                forever begin
                    @(posedge vif.aclk) if(vif.axi_rvalid === 1) break;
                end
            end
            uvm_report_info("AXI-M-DRV-R", $sformatf("seq=%04d done",sequence_num));
            rchannel_busy = 0;
            ++sequence_num;
        end
    endtask

    task wait_trans_done();
        wait(   (awchannel.size() == 0) &&
                (wchannel.size()  == 0) &&
                (bchannel.size()  == 0) &&
                (archannel.size() == 0) &&
                (rchannel.size()  == 0) &&
                (awchannel_busy   == 0) &&
                (wchannel_busy    == 0) &&
                (bchannel_busy    == 0) &&
                (archannel_busy   == 0) &&
                (rchannel_busy    == 0));
    endtask

endclass

