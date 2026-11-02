class qspi_flash_model extends uvm_component;

  	`uvm_component_utils(qspi_flash_model)

  	virtual qspi_intf vif;

  	bit [7:0]  opcode;
  	bit [31:0] read_data;

  	function new(string name = "qspi_flash_model",uvm_component parent = null);
    	super.new(name, parent);
  	endfunction
  
  	function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
    	if (!uvm_config_db #(virtual qspi_intf)::get(this, "", "vif", vif))
      	`uvm_fatal("QSPI_FLASH","QSPI virtual interface not found")
  	endfunction

	task run_phase(uvm_phase phase);

    	vif.flash_oe = 1'b0;
    	vif.flash_io = 4'b0000;

    	forever begin

        	opcode = 8'h00;
        	wait (vif.csn === 1'b0);
        	repeat (8) begin
            	@(posedge vif.sclk);
            	if (vif.csn !== 1'b0)
                	break;
            	opcode = {opcode[6:0], vif.io_0};
        	end
            `uvm_info("QSPI_FLASH",$sformatf("opcode = 0x%0h", opcode),UVM_MEDIUM)

        	case (opcode)
            	// xip read
            	8'hEB: begin

                  	// address - default (24)
                	repeat (6) @(posedge vif.sclk);

                  	// mode - FF (8 bits)
                	repeat (2) @(posedge vif.sclk);

                	// Wait for 4 dummy clock cycles
                	repeat (4) @(posedge vif.sclk);

                	if (vif.csn === 1'b0) begin
                    	read_data = $urandom;
                    	`uvm_info("QSPI_FLASH",$sformatf("Read data = 0x%0h",read_data),UVM_MEDIUM)
                    	vif.flash_oe = 1'b1;
                    	for (int i = 7; i >= 0; i--) begin	
                          @(posedge vif.sclk);
                        	if (vif.csn !== 1'b0)
                            	break;
                        	vif.flash_io = read_data[i*4 +: 4];
                    	end

                    	vif.flash_oe = 1'b0;
                    	vif.flash_io = 4'b0000;
                	end
            	end
                //other read - Fast Read, Read Status Reg 1 (RDSR1), Read JEDEC ID (RDID)

            	default: begin
                  	`uvm_error("QSPI_FLASH",$sformatf("unsupported opcode = 0x%02h",opcode))
            	end

        	endcase

        	vif.flash_oe = 1'b0;
        	vif.flash_io = 4'b0000;
        	wait (vif.csn === 1'b1);
		end
	endtask
endclass
