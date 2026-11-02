class qspi_monitor extends uvm_monitor;

    `uvm_component_utils(qspi_monitor)

    virtual qspi_intf vif;
    uvm_analysis_port #(qspi_seq_item) ap_qspi;

    function new(string name = "qspi_monitor",uvm_component parent);
        super.new(name, parent);
        ap_qspi = new("ap_qspi", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual qspi_intf)::get(this, "", "vif", vif))
            `uvm_fatal("QSPI_MONITOR","QSPI virtual interface not found")
    endfunction

    task run_phase(uvm_phase phase);
        qspi_seq_item tr;
        forever begin
            @(posedge vif.sclk);
            tr = qspi_seq_item::type_id::create("tr", this);
            tr.sclk  = vif.sclk;
            tr.cpol  = vif.cpol;
            tr.cpha  = vif.cpha;
            tr.csn   = vif.csn;
            tr.io_0  = vif.io_0;
            tr.io_1  = vif.io_1;
            tr.io_2  = vif.io_2;
            tr.io_3  = vif.io_3;
            `uvm_info("QSPI_MONITOR",$sformatf("SCLK=%0b CPOL=%0b CPHA=%0b CSN=%0b IO[3:0]=%b%b%b%b",tr.sclk, tr.cpol, tr.cpha, tr.csn,tr.io_3, tr.io_2, tr.io_1, tr.io_0),UVM_HIGH)
            ap_qspi.write(tr);
        end
    endtask

endclass
