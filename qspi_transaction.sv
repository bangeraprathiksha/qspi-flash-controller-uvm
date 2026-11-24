
class qspi_transaction extends uvm_sequence_item;

    bit [7:0] opcode;

    bit [3:0] enable;

    bit [2:0] address_length;
    bit [31:0] address;

    bit [7:0] mode;

    bit [4:0] dummy_cycles;

    bit [8:0] data_length;

    bit [7:0] line_width;

    // Maximum 256 bytes = 2048 bits
    bit [2047:0] data;

    `uvm_object_utils_begin(qspi_transaction)
        `uvm_field_int(opcode, UVM_ALL_ON)
        `uvm_field_int(enable, UVM_ALL_ON)
        `uvm_field_int(address_length, UVM_ALL_ON)
        `uvm_field_int(address, UVM_ALL_ON)
        `uvm_field_int(mode, UVM_ALL_ON)
        `uvm_field_int(dummy_cycles, UVM_ALL_ON)
        `uvm_field_int(data_length, UVM_ALL_ON)
        `uvm_field_int(line_width, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "qspi_transaction");
        super.new(name);
    endfunction

endclass

