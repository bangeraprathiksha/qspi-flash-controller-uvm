class virtual_sequencer extends uvm_sequencer;

  `uvm_component_utils(virtual_sequencer)

    apb_sequencer apb_seqr;
    ahb_sequencer ahb_seqr;

    function new(string name = "virtual_sequencer", uvm_component parent);
        super.new(name, parent);
    endfunction

endclass
