class apb_agent extends uvm_agent;

  	`uvm_component_utils(apb_agent)

  	apb_driver    drv;
  	apb_monitor   mon;
  	apb_sequencer seqr;

  	function new(string name = "apb_agent", uvm_component parent);
    	super.new(name, parent);
  	endfunction

  	function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
    	mon = apb_monitor::type_id::create("mon", this);
      	drv  = apb_driver::type_id::create("drv", this);
      	seqr = apb_sequencer::type_id::create("seqr", this);
  	endfunction

  	function void connect_phase(uvm_phase phase);
    	super.connect_phase(phase);
      	drv.seq_item_port.connect(seqr.seq_item_export);
  	endfunction

endclass
