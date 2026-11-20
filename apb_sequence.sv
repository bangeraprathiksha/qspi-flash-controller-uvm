/*class apb_sequence extends uvm_reg_sequence;

  	`uvm_object_utils(apb_sequence)

    top_reg_block reg_model;

  	function new(string name = "apb_sequence");
    	super.new(name);
    endfunction

    task body();

        uvm_status_e status;
        uvm_reg_data_t rdata;

        // enable register
        reg_model.enable_.write(status, 4'hF);

        // opcode register - Quad I/O Read
        reg_model.opcode.write(status, 8'hEB);

        // address length
        reg_model.address_length.write(status, 3'h3);

        // address register
        reg_model.address.write(status, 32'h00001000);

        // mode register
        reg_model.mode.write(status, 8'hFF);

        // dummy cycles
        reg_model.dummy.write(status, 5'h04);

        // data length
        reg_model.data_length.write(status, 9'd4);

        // line width
        reg_model.line_width.write(status, 8'h44);

        // start transaction
        reg_model.start.write(status, 1'h1);

        // read status register
        reg_model.status.read(status, rdata);
      
        `uvm_info("QSPI_RAL_SEQ", $sformatf("Status register = %0h", rdata), UVM_MEDIUM)

    endtask

endclass*/
class apb_sequence extends uvm_reg_sequence;

    `uvm_object_utils(apb_sequence)

    top_reg_block reg_model;

    function new(string name = "apb_sequence");
        super.new(name);
    endfunction

    task body();

        uvm_status_e status;
        uvm_reg_data_t rdata;

        // Get register model
        if (model == null)
            `uvm_fatal("RAL", "Register model is not assigned")

        reg_model = top_reg_block'(model);

        if (reg_model == null)
            `uvm_fatal("RAL", "Register model type mismatch")
        // Read status register
        reg_model.status.read(status, rdata);
        `uvm_info("QSPI_RAL_SEQ",
                  $sformatf("Status register = %0h", rdata),
                  UVM_MEDIUM)

        // Enable register
        reg_model.enable_.write(status, 4'hF);

        // Opcode register
        reg_model.opcode.write(status, 8'hEB);

        // Address length
        reg_model.address_length.write(status, 3'h3);

        // Address register
        reg_model.address.write(status, 32'h00001000);

        // Mode register
        reg_model.mode.write(status, 8'hFF);

        // Dummy cycles
        reg_model.dummy.write(status, 5'h04);

        // Data length
        reg_model.data_length.write(status, 9'd4);

        // Line width
        reg_model.line_width.write(status, 8'h44);

        // Start transaction
        reg_model.start.write(status, 1'h1);

        // Read status register
        reg_model.status.read(status, rdata);

        `uvm_info("QSPI_RAL_SEQ",
                  $sformatf("Status register = %0h", rdata),
                  UVM_MEDIUM)

    endtask

endclass
