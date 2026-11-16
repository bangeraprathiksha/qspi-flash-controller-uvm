
class apb_driver extends uvm_driver #(apb_seq_item);

    `uvm_component_utils(apb_driver)

    virtual apb_intf vif;

    function new(string name = "apb_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db #(virtual apb_intf)::get( this, "", "vif", vif)) begin
            `uvm_fatal("APB_DRV", "APB interface not found")
        end
    endfunction

    task run_phase(uvm_phase phase);
        apb_seq_item tr;

        // Wait for reset release
        wait (vif.resetn === 1'b1);

        // initializing
        vif.drv_cb_apb.psel    <= 1'b0;
        vif.drv_cb_apb.penable <= 1'b0;
        vif.drv_cb_apb.pwrite  <= 1'b0;
        vif.drv_cb_apb.paddr   <= '0;
        vif.drv_cb_apb.pwdata  <= '0;

        forever begin
		$display("started driver");
            seq_item_port.get_next_item(tr);
            drive_transfer(tr);
            seq_item_port.item_done();
        end
    endtask

    task drive_transfer(apb_seq_item tr);

        // setup phase
        @(vif.drv_cb_apb);

        vif.drv_cb_apb.psel    <= 1'b1;
        vif.drv_cb_apb.penable <= 1'b0;
        vif.drv_cb_apb.pwrite  <= tr.pwrite;
        vif.drv_cb_apb.paddr   <= tr.paddr;
        vif.drv_cb_apb.pwdata  <= tr.pwdata;

	`uvm_info("DRV",$sformatf("Driving APB: pwrite=%0d, paddr=%0h, pwdata=%0h",tr.pwrite, tr.paddr,tr.pwdata), UVM_LOW)
		
	// access phase
        @(vif.drv_cb_apb);
        vif.drv_cb_apb.penable <= 1'b1;

	`uvm_info("DRV",$sformatf("Driving APB: pwrite=%0d, paddr=%0h, pwdata=%0h",tr.pwrite,tr.paddr,tr.pwdata),UVM_LOW)

        // Wait until the transfer completes
        do begin
            @(vif.drv_cb_apb);
        end while (vif.drv_cb_apb.pready !== 1'b1);

	`uvm_info("DRV",$sformatf(" received pready = %0d", vif.drv_cb_apb.pready),UVM_LOW)

        // capturing response
      	if(!tr.pwrite)begin
        	tr.prdata  = vif.drv_cb_apb.prdata;
        	tr.pslverr = vif.drv_cb_apb.pslverr;
        end

        if (tr.pslverr === 1'b1) begin
            `uvm_info("APB_DRV",$sformatf("APB error at address %h", tr.paddr),UVM_MEDIUM)
        end
	
	`uvm_info("DRV","no pslverr",UVM_LOW)

        // returning to idle
        @(vif.drv_cb_apb);

        vif.drv_cb_apb.psel    <= 1'b0;
        vif.drv_cb_apb.penable <= 1'b0;
        vif.drv_cb_apb.pwrite  <= 1'b0;
        vif.drv_cb_apb.paddr   <= '0;
        vif.drv_cb_apb.pwdata  <= '0;

	`uvm_info("DRV",$sformatf("Driving APB: pwrite=%0d, paddr=%0h, pwdata=%0h",tr.pwrite,tr.paddr,tr.pwdata),UVM_LOW)
    endtask

endclass

