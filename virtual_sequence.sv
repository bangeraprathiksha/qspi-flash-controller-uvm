class qspi_virtual_sequence extends uvm_sequence;

    `uvm_object_utils(qspi_virtual_sequence)
    `uvm_declare_p_sequencer(qspi_virtual_sequencer)

    apb_sequence apb_seq;
    ahb_sequence ahb_seq;

    function new(string name = "qspi_virtual_sequence");
        super.new(name);
    endfunction

    virtual task body();

        `uvm_info("VSEQ", "Starting QSPI virtual sequence", UVM_MEDIUM)
      
        apb_seq = apb_sequence::type_id::create("apb_seq");
        ahb_seq = ahb_sequence::type_id::create("ahb_seq");

        apb_seq.start(p_sequencer.apb_seqr);
        ahb_seq.start(p_sequencer.ahb_seqr);

        `uvm_info("VSEQ", "QSPI virtual sequence completed", UVM_MEDIUM)

    endtask

endclass
