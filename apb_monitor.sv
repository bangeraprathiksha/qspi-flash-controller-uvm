class apb_monitor extends uvm_monitor;

    `uvm_component_utils(apb_monitor)

    virtual apb_intf vif;

    uvm_analysis_port #(apb_seq_item) ap_apb;

    function new(string name = "apb_monitor",uvm_component parent);
        super.new(name, parent);
      	ap_apb = new("ap_apb", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual apb_intf)::get( this, "", "vif", vif))
            `uvm_fatal("APB_MONITOR", "APB virtual interface not found")
    endfunction

    task run_phase(uvm_phase phase);
        apb_seq_item tr;
        forever begin
            @(posedge vif.pclk);
          	if (vif.presetn && vif.psel && vif.penable && vif.pready) begin
                tr = apb_seq_item::type_id::create("tr", this);
                tr.paddr   = vif.paddr;
                tr.pwrite  = vif.pwrite;
                tr.pwdata  = vif.pwdata;
                tr.prdata  = vif.prdata;
                tr.pslverr = vif.pslverr;
                `uvm_info("APB_MONITOR",$sformatf("ADDR=%0h WRITE=%0b WDATA=%0h RDATA=%0h PSLVERR=%0b",tr.paddr,tr.pwrite,tr.pwdata,tr.prdata,tr.pslverr),UVM_MEDIUM)
                ap_apb.write(tr);
            end
        end
    endtask

endclass
