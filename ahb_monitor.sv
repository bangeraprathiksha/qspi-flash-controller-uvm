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
          	if (vif.hsel && vif.htrans[1] && vif.hready) begin
                	tr = ahb_seq_item::type_id::create("tr", this);
                	tr.haddr  = vif.haddr;
                	tr.htrans = vif.htrans;
                	tr.hwrite = vif.hwrite;
                	tr.hrdata = vif.hrdata;
                	tr.hresp  = vif.hresp;
                	`uvm_info("AHB_MONITOR",$sformatf("ADDR=%0h TRANS=%0b WRITE=%0b ", tr.haddr,tr.htrans,tr.hwrite),UVM_MEDIUM)
                	ap_ahb.write(tr);
            	end
        end
    endtask

endclass


class apb_monitor extends uvm_monitor;

    `uvm_component_utils(apb_monitor)

    virtual apb_intf vif;

    uvm_analysis_port #(apb_seq_item)       ap_apb;
    uvm_analysis_port #(qspi_transaction_t) ap_qspi;

    // QSPI configuration registers
    bit [7:0]  opcode;
    bit [31:0] address;
    bit [2:0]  address_length;
    bit [7:0]  mode;
    bit [4:0]  dummy_cycles;
    bit [8:0]  data_length;
    bit [7:0]  line_width;
    bit [3:0]  enable;

    function new(string name = "apb_monitor", uvm_component parent);
        super.new(name, parent);

        ap_apb  = new("ap_apb", this);
        ap_qspi = new("ap_qspi", this);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db #(virtual apb_intf)::get(this, "", "vif", vif))
            `uvm_fatal("APB_MONITOR", "APB virtual interface not found")
    endfunction


    task run_phase(uvm_phase phase);

        apb_seq_item tr;
        qspi_transaction_t qspi_tr;

        // Initialize configuration
        opcode         = '0;
        address        = '0;
        address_length = '0;
        mode           = '0;
        dummy_cycles   = '0;
        data_length    = '0;
        line_width     = '0;
        enable         = '0;

        forever begin

            @(posedge vif.pclk);

            if (vif.psel && vif.penable && vif.pready) begin

                tr = apb_seq_item::type_id::create("tr", this);

                tr.paddr   = vif.paddr;
                tr.pwrite  = vif.pwrite;
                tr.pwdata  = vif.pwdata;
                tr.prdata  = vif.prdata;
                tr.pslverr = vif.pslverr;

                `uvm_info("APB_MONITOR", $sformatf("ADDR=%0h WRITE=%0b WDATA=%0h RDATA=%0h PSLVERR=%0b", tr.paddr, tr.pwrite, tr.pwdata, tr.prdata, tr.pslverr), UVM_MEDIUM)

                // Publish normal APB transaction
                ap_apb.write(tr);


                // Collect successful register writes
                if (tr.pwrite && !tr.pslverr) begin

                    case (tr.paddr)

                        `OPCODE_ADDR:
                            opcode = tr.pwdata[7:0];

                        `ADDRESS_ADDR:
                            address = tr.pwdata[31:0];

                        `ADDRESS_LENGTH_ADDR:
                            address_length = tr.pwdata[2:0];

                        `MODE_ADDR:
                            mode = tr.pwdata[7:0];

                        `DUMMY_ADDR:
                            dummy_cycles = tr.pwdata[4:0];

                        `DATA_LENGTH_ADDR:
                            data_length = tr.pwdata[8:0];

                        `LINE_WIDTH_ADDR:
                            line_width = tr.pwdata[7:0];

                        `ENABLE_ADDR:
                            enable = tr.pwdata[3:0];


                        // START register
                        `START_ADDR: begin

                            qspi_tr.is_indirect    = 1'b1;
                            qspi_tr.opcode         = opcode;
                            qspi_tr.address        = address;
                            qspi_tr.address_length = address_length;
                            qspi_tr.mode           = mode;
                            qspi_tr.dummy_cycles   = dummy_cycles;
                            qspi_tr.data_length    = data_length;
                            qspi_tr.line_width     = line_width;
                            qspi_tr.enable         = enable;

                            `uvm_info("APB_MONITOR", $sformatf("INDIRECT REQUEST: OPCODE=%02h ADDRESS=%08h ADDR_LEN=%0d MODE=%02h DUMMY=%0d DATA_LEN=%0d LINE_WIDTH=%02h ENABLE=%0h", qspi_tr.opcode, qspi_tr.address, qspi_tr.address_length, qspi_tr.mode, qspi_tr.dummy_cycles, qspi_tr.data_length, qspi_tr.line_width, qspi_tr.enable), UVM_MEDIUM)

                            ap_qspi.write(qspi_tr);

                        end

                        default: begin
                        end

                    endcase

                end

            end

        end

    endtask

endclass

