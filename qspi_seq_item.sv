class qspi_seq_item extends uvm_sequence_item;

    `uvm_object_utils(qspi_seq_item)

    bit sclk;
    bit cpol;
    bit cpha;
    bit csn;

    logic io_0;
    logic io_1;
    logic io_2;
    logic io_3;

    function new(string name = "qspi_seq_item");
        super.new(name);
    endfunction

endclass
