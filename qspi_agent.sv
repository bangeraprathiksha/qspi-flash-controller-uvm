class qspi_agent extends uvm_agent;

  	`uvm_component_utils(qspi_agent)

  	qspi_monitor mon;

  	function new(string name = "qspi_agent", uvm_component parent);
    	super.new(name, parent);
  	endfunction

  	function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
    	mon = qspi_monitor::type_id::create("mon", this);
  	endfunction

endclass
