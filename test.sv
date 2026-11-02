class qspi_test extends uvm_test;

  	`uvm_component_utils(qspi_test)

  	qspi_env env;

  	function new(string name = "qspi_test",uvm_component parent);
    	super.new(name, parent);
  	endfunction

 	function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
    	env = qspi_env::type_id::create("env", this);
  	endfunction

  	task run_phase(uvm_phase phase);
    	qspi_virtual_sequence v_seq;
    	phase.raise_objection(this);
    	v_seq = qspi_virtual_sequence::type_id::create("v_seq");
    	v_seq.start(env.v_seqr);
    	phase.drop_objection(this);
  	endtask

endclass
