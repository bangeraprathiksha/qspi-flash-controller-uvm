class ahb_seq_item extends uvm_sequence_item;

    `uvm_object_utils(ahb_seq_item)

    rand bit [1:0] htrans;
    rand bit hsel;
    rand bit hready;
    rand bit hwrite;
    rand bit [`ADDR_WIDTH-1:0] haddr;

    logic hreadyout;
    logic hresp;
    logic [`DATA_WIDTH-1:0] hrdata;

    function new(string name = "ahb_seq_item");
        super.new(name);
    endfunction

endclass

