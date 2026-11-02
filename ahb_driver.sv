class ahb_driver extends uvm_driver #(ahb_seq_item);

  `uvm_component_utils(ahb_driver)

  virtual ahb_intf vif;

  function new(string name = "ahb_driver",uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(virtual ahb_intf)::get(this, "", "vif", vif))
      `uvm_fatal("AHB_DRV", "AHB interface not found")
  endfunction

  task run_phase(uvm_phase phase);
    ahb_seq_item tr;

    // Initialize AHB master signals
    vif.drv_cb_ahb.hsel   <= 1'b0;
    vif.drv_cb_ahb.htrans <= 2'b00; // IDLE
    vif.drv_cb_ahb.hwrite <= 1'b0;
    vif.drv_cb_ahb.haddr  <= '0;
    vif.drv_cb_ahb.hready <= 1'b1;  // Input to DUT

    wait (vif.resetn === 1'b1);

    forever begin
      seq_item_port.get_next_item(tr);
      drive_transfer(tr);
      seq_item_port.item_done();
    end
  endtask

  task drive_transfer(ahb_seq_item tr);

    // Drive one NONSEQ transfer
    @(vif.drv_cb_ahb);

    vif.drv_cb_ahb.hsel   <= 1'b1;
    vif.drv_cb_ahb.htrans <= 2'b10; // NONSEQ
    vif.drv_cb_ahb.hwrite <= tr.hwrite;
    vif.drv_cb_ahb.haddr  <= tr.haddr;
    vif.drv_cb_ahb.hready <= 1'b1;

    // Wait for the DUT to complete the XIP operation
    do begin
      @(vif.drv_cb_ahb);
    end while (vif.drv_cb_ahb.hreadyout !== 1'b1);

    // Capture response
    tr.hrdata = vif.drv_cb_ahb.hrdata;
    tr.hresp  = vif.drv_cb_ahb.hresp;

    // Deassert the request
    vif.drv_cb_ahb.hsel   <= 1'b0;
    vif.drv_cb_ahb.htrans <= 2'b00; // IDLE
    vif.drv_cb_ahb.hwrite <= 1'b0;
    vif.drv_cb_ahb.haddr  <= '0;

    if (tr.hresp === 1'b1)
      `uvm_info("AHB_DRV", "AHB error response received", UVM_MEDIUM)
    else
      `uvm_info("AHB_DRV",$sformatf("Read completed: addr=%h data=%h",tr.haddr, tr.hrdata), UVM_MEDIUM)

  endtask

endclass
