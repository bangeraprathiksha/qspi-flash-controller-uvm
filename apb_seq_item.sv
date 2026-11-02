class apb_seq_item extends uvm_sequence_item;

    `uvm_object_utils(apb_seq_item)

    rand bit psel;
    rand bit penable;
    rand bit pwrite;
    rand bit [`ADDR_WIDTH-1:0] paddr;
    rand bit [`DATA_WIDTH-1:0] pwdata;

    logic pready;
    logic pslverr;
    logic [`DATA_WIDTH-1:0] rdata;

    function new(string name = "apb_seq_item");
        super.new(name);
    endfunction

endclass

