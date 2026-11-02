
//---------------- ENABLE REGISTER (0x00) ----------------//
class ENABLE extends uvm_reg;

    `uvm_object_utils(ENABLE)

    uvm_reg_field address;
    uvm_reg_field mode;
    uvm_reg_field data_tx;
    uvm_reg_field data_rx;

    covergroup enable_cov;
        option.per_instance = 1;
        coverpoint address.get() {
            bins disabled = {0};
            bins enabled  = {1};
        }
        coverpoint mode.get() {
            bins disabled = {0};
            bins enabled  = {1};
        }
        coverpoint data_tx.get() {
            bins disabled = {0};
            bins enabled  = {1};
        }
        coverpoint data_rx.get() {
            bins disabled = {0};
            bins enabled  = {1};
        }
    endgroup

    function new(string name = "ENABLE");
        super.new(name, 4, UVM_CVR_ALL);
        enable_cov = new();
    endfunction

    function void build();
        address = uvm_reg_field::type_id::create("address");
        mode    = uvm_reg_field::type_id::create("mode");
        data_tx = uvm_reg_field::type_id::create("data_tx");
        data_rx = uvm_reg_field::type_id::create("data_rx");
        address_en.configure(this, 1, 3, "WO", 0, 0, 1, 0, 1);
        mode_en.configure(this, 1, 2, "WO", 0, 0, 1, 0, 1);
        data_tx_en.configure(this, 1, 1, "WO", 0, 0, 1, 0, 1);
        data_rx_en.configure(this, 1, 0, "WO", 0, 0, 1, 0, 1);
    endfunction

    virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
        enable_cov.sample();
    endfunction

    virtual function void sample_values();
        super.sample_values();
        enable_cov.sample();
    endfunction

endclass


//---------------- OPCODE REGISTER (0x04) ----------------//

class OPCODE extends uvm_reg;

    `uvm_object_utils(OPCODE)

    uvm_reg_field opcode;

    covergroup opcode_cov;
        option.per_instance = 1;

        coverpoint opcode.get() {
            bins read        = {8'h03};
            bins fast_read   = {8'h0B};
            bins quad_read   = {8'hEB};
            bins other       = default;
        }
    endgroup

    function new(string name = "OPCODE");
        super.new(name, 8, UVM_CVR_ALL);
        opcode_cov = new();
    endfunction

    function void build();

        opcode = uvm_reg_field::type_id::create("opcode");
        opcode.configure(this, 8, 0, "WO", 0, 0, 1, 0, 1);

    endfunction

    virtual function void sample(uvm_reg_data_t data,uvm_reg_data_t byte_en, bit is_read,uvm_reg_map map);
        opcode_cov.sample();
    endfunction

    virtual function void sample_values();
        super.sample_values();
        opcode_cov.sample();
    endfunction

endclass


//---------------- ADDRESS LENGTH REGISTER (0x0C) ----------------//

class ADDRESS_LENGTH extends uvm_reg;
  
    `uvm_object_utils(ADDRESS_LENGTH)
  
    uvm_reg_field address_length;

    covergroup address_length_cov;
        option.per_instance = 1;

        coverpoint address_length.get() {
            bins zero       = {0};
            bins short_addr = {[1:2]};
            bins full_addr  = {3};
            bins reserved   = {[4:7]};
        }
    endgroup

    function new(string name = "ADDRESS_LENGTH");
        super.new(name, 3, UVM_CVR_ALL);
        address_length_cov = new();
    endfunction

    function void build();

        address_length = uvm_reg_field::type_id::create("address_length");
        address_length.configure(this, 3, 0, "WO", 0, 0, 1, 0, 1);

    endfunction

    virtual function void sample(uvm_reg_data_t data,uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
        address_length_cov.sample();
    endfunction

    virtual function void sample_values();
        super.sample_values();
        address_length_cov.sample();
    endfunction

endclass


//---------------- ADDRESS REGISTER (0x10) ----------------//

class ADDRESS extends uvm_reg;

    `uvm_object_utils(ADDRESS)

    uvm_reg_field address;

    covergroup address_cov;
        option.per_instance = 1;

        coverpoint address.get() {
            bins lower = {[32'h00000000:32'h0000FFFF]};
            bins mid   = {[32'h00010000:32'h7FFFFFFF]};
            bins high  = {[32'h80000000:32'hFFFFFFFF]};
        }
    endgroup

    function new(string name = "ADDRESS");
        super.new(name, `DATA_WIDTH, UVM_CVR_ALL);
        address_cov = new();
    endfunction

    function void build();

        address = uvm_reg_field::type_id::create("address");
        address.configure(this, `DATA_WIDTH, 0, "WO", 0, 0, 1, 0, 1);

    endfunction

    virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
        address_cov.sample();
    endfunction

    virtual function void sample_values();
        super.sample_values();
        address_cov.sample();
    endfunction

endclass


//---------------- MODE REGISTER (0x30) ----------------//

class MODE extends uvm_reg;

    `uvm_object_utils(MODE)

    uvm_reg_field mode;

    covergroup mode_cov;
        option.per_instance = 1;

        coverpoint mode.get() {
            bins zero       = {8'h00};
            bins ones       = {8'hFF};
            bins other      = {[8'h01:8'hFF]};
        }
    endgroup

    function new(string name = "MODE");
        super.new(name, 8, UVM_CVR_ALL);
        mode_cov = new();
    endfunction

    function void build();

        mode = uvm_reg_field::type_id::create("mode");
        mode.configure(this, 8, 0, "WO", 0, 0, 1, 0, 1);

    endfunction

    virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
        mode_cov.sample();
    endfunction

    virtual function void sample_values();
        super.sample_values();
        mode_cov.sample();
    endfunction

endclass


//---------------- DUMMY REGISTER (0x38) ----------------//

class DUMMY extends uvm_reg;

    `uvm_object_utils(DUMMY)

    uvm_reg_field dummy;

    covergroup dummy_cov;
        option.per_instance = 1;

        coverpoint dummy.get() {
            bins zero       = {0};
            bins low        = {[1:7]};
            bins medium     = {[8:15]};
            bins high       = {[16:31]};
        }
    endgroup

    function new(string name = "DUMMY");
        super.new(name, 5, UVM_CVR_ALL);
        dummy_cov = new();
    endfunction

    function void build();

        dummy = uvm_reg_field::type_id::create("dummy");
        dummy.configure(this, 5, 0, "WO", 0, 0, 1, 0, 1);

    endfunction

    virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
        dummy_cov.sample();
    endfunction

    virtual function void sample_values();
        super.sample_values();
        dummy_cov.sample();
    endfunction

endclass


//---------------- DATA LENGTH REGISTER (0x3D) ----------------//

class DATA_LENGTH extends uvm_reg;

    `uvm_object_utils(DATA_LENGTH)

    uvm_reg_field data_length;

    covergroup data_length_cov;
        option.per_instance = 1;

        coverpoint data_length.get() {
            bins zero       = {0};
            bins small      = {[1:63]};
            bins medium     = {[64:127]};
            bins large      = {[128:255]};
            bins max_value  = {256};
            bins reserved   = {[257:511]};
        }
    endgroup

    function new(string name = "DATA_LENGTH");
        super.new(name, 9, UVM_CVR_ALL);
        data_length_cov = new();
    endfunction

    function void build();

        data_length = uvm_reg_field::type_id::create("data_length");
        data_length.configure(this, 9, 0, "WO", 0, 0, 1, 0, 1);

    endfunction

    virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
        data_length_cov.sample();
    endfunction

    virtual function void sample_values();
        super.sample_values();
        data_length_cov.sample();
    endfunction

endclass


//---------------- LINE WIDTH REGISTER (0x46) ----------------//

class LINE_WIDTH extends uvm_reg;

    `uvm_object_utils(LINE_WIDTH)

    uvm_reg_field line_width;

    covergroup line_width_cov;
        option.per_instance = 1;

        coverpoint line_width.get() {
            bins single_line = {1};
            bins dual_line   = {2};
            bins quad_line   = {4};
            bins invalid     = default;
        }
    endgroup

    function new(string name = "LINE_WIDTH");
        super.new(name, 8, UVM_CVR_ALL);
        line_width_cov = new();
    endfunction

    function void build();

        line_width = uvm_reg_field::type_id::create("line_width");
        line_width.configure(this, 8, 0, "WO", 0, 0, 1, 0, 1);

    endfunction

    virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
        line_width_cov.sample();
    endfunction

    virtual function void sample_values();
        super.sample_values();
        line_width_cov.sample();
    endfunction

endclass


//---------------- DATA REGISTER (0x4E) ----------------//

class DATA extends uvm_reg;

    `uvm_object_utils(DATA)

    uvm_reg_field data;

    covergroup data_cov;
        option.per_instance = 1;

        coverpoint data.get() {
            bins zero       = {32'h00000000};
            bins all_ones   = {32'hFFFFFFFF};
            bins lower      = {[32'h00000001:32'h3FFFFFFF]};
            bins middle     = {[32'h40000000:32'hBFFFFFFF]};
            bins upper      = {[32'hC0000000:32'hFFFFFFFF]};
        }
    endgroup

    function new(string name = "DATA");
        super.new(name, `DATA_WIDTH, UVM_CVR_ALL);
        data_cov = new();
    endfunction

    function void build();

        data = uvm_reg_field::type_id::create("data");
        data.configure(this, `DATA_WIDTH, 0, "RW", 0, 0, 1, 0, 1);

    endfunction

    virtual function void sample(uvm_reg_data_t data_value, uvm_reg_data_t byte_en, bit is_read,  uvm_reg_map map);
        data_cov.sample();
    endfunction

    virtual function void sample_values();
        super.sample_values();
        data_cov.sample();
    endfunction

endclass


//---------------- START REGISTER (0x6E) ----------------//

class START extends uvm_reg;

    `uvm_object_utils(START)

    uvm_reg_field start;

    covergroup start_cov;
        option.per_instance = 1;

        coverpoint start.get() {
            bins not_started = {0};
            bins started     = {1};
        }
    endgroup

    function new(string name = "START");
        super.new(name, 1, UVM_CVR_ALL);
        start_cov = new();
    endfunction

    function void build();

        start = uvm_reg_field::type_id::create("start");
        start.configure(this, 1, 0, "WO", 0, 0, 1, 0, 1);

    endfunction

    virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
        start_cov.sample();
    endfunction

    virtual function void sample_values();
        super.sample_values();
        start_cov.sample();
    endfunction

endclass


//---------------- STATUS REGISTER (0x6F) ----------------//

class STATUS extends uvm_reg;

    `uvm_object_utils(STATUS)

    uvm_reg_field error;
    uvm_reg_field busy;
    uvm_reg_field tx_fifo_full;
    uvm_reg_field rx_fifo_empty;

    covergroup status_cov;
        option.per_instance = 1;
        coverpoint error.get() {
            bins no_error = {0};
            bins error    = {1};
        }
        coverpoint busy.get() {
            bins idle     = {0};
            bins busy     = {1};
        }
        coverpoint tx_fifo_full.get() {
            bins not_full = {0};
            bins full     = {1};
        }
        coverpoint rx_fifo_empty.get() {
            bins not_empty = {0};
            bins empty     = {1};
        }
    endgroup

    function new(string name = "STATUS");
        super.new(name, 4, UVM_CVR_ALL);
        status_cov = new();
    endfunction

    function void build();

        error         = uvm_reg_field::type_id::create("error");
        busy          = uvm_reg_field::type_id::create("busy");
        tx_fifo_full  = uvm_reg_field::type_id::create("tx_fifo_full");
        rx_fifo_empty = uvm_reg_field::type_id::create("rx_fifo_empty");

      	error.configure(this, 1, 3, "RO", 0, 0, 1, 0, 1);
      	busy.configure(this, 1, 2, "RO", 0, 0, 1, 0, 1);
      	tx_fifo_full.configure(this, 1, 1, "RO", 0, 0, 1, 0, 1);
      	rx_fifo_empty.configure(this, 1, 0, "RO", 0, 0, 1, 0, 1);

    endfunction

    virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
        status_cov.sample();
    endfunction

    virtual function void sample_values();
        super.sample_values();
        status_cov.sample();
    endfunction

endclass
