class ahb_sequence extends uvm_sequence #(ahb_seq_item);

  `uvm_object_utils(ahb_sequence)

  function new(string name = "ahb_sequence");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;

    req = ahb_seq_item::type_id::create("req");

    start_item(req);

    if (!req.randomize() with {
      htrans == 2'b10; // nonseq
      hwrite == 1'b0;  
      haddr  == 32'h00001000;
    })
    `uvm_error("AHB_SEQ", "Randomization failed")
      
    finish_item(req);

  endtask

endclass
