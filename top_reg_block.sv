//======================================================
// QSPI REGISTER BLOCK
//======================================================

class top_reg_block extends uvm_reg_block;

    `uvm_object_utils(top_reg_block)

    rand ENABLE         enable;
    rand OPCODE         opcode;
    rand ADDRESS_LENGTH address_length;
    rand ADDRESS        address;
    rand MODE           mode;
    rand DUMMY          dummy;
    rand DATA_LENGTH    data_length;
    rand LINE_WIDTH     line_width;
    rand DATA           data;
    rand START          start;
         STATUS         status;

    uvm_reg_map default_map;

    function new(string name = "top_reg_block");
        super.new(name, UVM_CVR_ALL);
    endfunction

    virtual function void build();

        enable         = ENABLE::type_id::create("enable");
        opcode         = OPCODE::type_id::create("opcode");
        address_length = ADDRESS_LENGTH::type_id::create("address_length");
        address        = ADDRESS::type_id::create("address");
        mode           = MODE::type_id::create("mode");
        dummy          = DUMMY::type_id::create("dummy");
        data_length    = DATA_LENGTH::type_id::create("data_length");
        line_width     = LINE_WIDTH::type_id::create("line_width");
        data           = DATA::type_id::create("data");
        start          = START::type_id::create("start");
        status         = STATUS::type_id::create("status");

        enable.configure(this);
        opcode.configure(this);
        address_length.configure(this);
        address.configure(this);
        mode.configure(this);
        dummy.configure(this);
        data_length.configure(this);
        line_width.configure(this);
        data.configure(this);
        start.configure(this);
        status.configure(this);

        enable.build();
        opcode.build();
        address_length.build();
        address.build();
        mode.build();
        dummy.build();
        data_length.build();
        line_width.build();
        data.build();
        start.build();
        status.build();

        default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);
      	default_map.add_reg(enable, 'h00, "WO");
      	default_map.add_reg(opcode, 'h04, "WO");
        default_map.add_reg(address_length, 'h0C, "WO");
        default_map.add_reg(address, 'h10, "WO");
      	default_map.add_reg(mode, 'h30, "WO");
      	default_map.add_reg(dummy, 'h38, "WO");
      	default_map.add_reg(data_length, 'h3D, "WO");
      	default_map.add_reg(line_width, 'h46, "WO");
      	default_map.add_reg(data, 'h4E, "RW");
        default_map.add_reg(start, 'h6E, "WO");
        default_map.add_reg(status, 'h6F, "RO");
        lock_model();

    endfunction

endclass


