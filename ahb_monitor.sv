class ahb_monitor extends uvm_monitor;

    `uvm_component_utils(ahb_monitor)

    virtual ahb_intf vif;

    uvm_analysis_port #(ahb_seq_item) ap_ahb;

    function new(string name = "ahb_monitor",uvm_component parent = null);
        super.new(name, parent);
      	ap_ahb = new("ap_ahb", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual ahb_intf)::get(this, "", "vif", vif))
            `uvm_fatal("AHB_MONITOR","AHB virtual interface not found")
    endfunction

    task run_phase(uvm_phase phase);
        ahb_seq_item tr;
        forever begin
            @(posedge vif.hclk);
            if (!vif.hresetn)
                continue;
          	if (vif.hsel && vif.htrans[1] && vif.hready) begin
                tr = ahb_seq_item::type_id::create("tr", this);
                tr.haddr  = vif.haddr;
                tr.htrans = vif.htrans;
                tr.hwrite = vif.hwrite;
                tr.hsize  = vif.hsize;
                tr.hburst = vif.hburst;
                tr.hwdata = vif.hwdata;
                tr.hrdata = vif.hrdata;
                tr.hresp  = vif.hresp;
                `uvm_info("AHB_MONITOR",$sformatf("ADDR=%0h TRANS=%0b WRITE=%0b SIZE=%0b BURST=%0b", tr.haddr,tr.htrans,tr.hwrite,tr.hsize, tr.hburst),UVM_MEDIUM)

                ap_ahb.write(tr);
            end
        end
    endtask

endclass
