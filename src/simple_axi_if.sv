// simple_axi_if.sv
//      This file implements the axi interface for simple_axi.
//      
// Copyright (c) 2020 Akira Nishiyama.
// Released under the MIT license
// https://opensource.org/licenses/mit-license.php
//

interface simple_axi_if(input logic aclk, input logic arstn);
    parameter C_AXI_ADDR_WIDTH   = 32;
    parameter C_AXI_DATA_WIDTH   = 32;

    `define C_AXI_BURST_INCR 3
    `define C_AXI_LOCK_NORMAL 0
    `define C_AXI_CACHE_NORMAL_NON_CACHE_BUFFARABLE 3
    // write address channel
    logic  [(C_AXI_ADDR_WIDTH-1):0]            axi_awaddr;
    logic  [7:0]                               axi_awlen;
    logic  [2:0]                               axi_awsize;
    logic  [1:0]                               axi_awburst;
    logic  [1:0]                               axi_awlock;
    logic  [3:0]                               axi_awcache;
    logic  [2:0]                               axi_awprot;
    logic                                      axi_awvalid;
    logic                                      axi_awready;
    logic  [3:0]                               axi_awregion;
    logic  [3:0]                               axi_awqos;

    // write data channel
    logic                                      axi_wlast;
    logic  [(C_AXI_DATA_WIDTH-1):0]            axi_wdata;
    logic  [(C_AXI_DATA_WIDTH/8)-1:0]          axi_wstrb;
    logic                                      axi_wvalid;
    logic                                      axi_wready;

    // write response channel
    logic  [1:0]                               axi_bresp;
    logic                                      axi_bvalid;
    logic                                      axi_bready;

    // read address channel
    logic  [(C_AXI_ADDR_WIDTH-1):0]            axi_araddr;
    logic  [7:0]                               axi_arlen;
    logic  [2:0]                               axi_arsize;
    logic  [1:0]                               axi_arburst;
    logic  [1:0]                               axi_arlock;
    logic  [3:0]                               axi_arcache;
    logic  [2:0]                               axi_arprot;
    logic                                      axi_arvalid;
    logic                                      axi_arready;
    logic  [3:0]                               axi_arregion;
    logic  [3:0]                               axi_arqos;

    // read data  channel
    logic                                      axi_rlast;
    logic  [(C_AXI_DATA_WIDTH-1):0]            axi_rdata;
    logic  [1:0]                               axi_rresp;
    logic                                      axi_rvalid;
    logic                                      axi_rready;

    assign axi_awsize   = 2;//fixed to 4byte transfer.
    assign axi_awburst  = `C_AXI_BURST_INCR;//fixed to increment mode.
    assign axi_awlock   = `C_AXI_LOCK_NORMAL;//fixed to normal access mode.
    assign axi_awcache  = `C_AXI_CACHE_NORMAL_NON_CACHE_BUFFARABLE;//fixed to normal non-cachable buffarble.recommended in ug1037.
    assign axi_awprot   = 0;//fixed to 0. recommended in ug1037.
    assign axi_awregion = 0;//fixed to 9. not supported.
    assign axi_awqos    = 0;//fixed to 0. not supported.
    assign axi_arsize   = 2;//fixed to 4byte transfer.
    assign axi_arburst  = `C_AXI_BURST_INCR;//fixed to increment mode.
    assign axi_arlock   = `C_AXI_LOCK_NORMAL;//fixed to normal access mode.
    assign axi_arcache  = `C_AXI_CACHE_NORMAL_NON_CACHE_BUFFARABLE;//fixed to normal non-cachable buffarable.recommended in ug1037.
    assign axi_arprot   = 0;//fixed to 0. recommended in ug1037.
    assign axi_arregion = 0;//fixed to 0. not supported.
    assign axi_arqos    = 0;//fixed to 0. not supported.


endinterface
