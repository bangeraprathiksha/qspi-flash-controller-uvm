class predictor extends uvm_reg_predictor #(reg_seq_item);
  	`uvm_component_utils(predictor)
  	function new(string name = "predictor", uvm_component parent);
    	super.new(name,parent);
  	endfunction
endclass
