class top_adapter extends uvm_reg_adapter;
        `uvm_object_utils(top_adapter)

        function new(string name = "top_adapter");
                super.new(name);
        endfunction

        function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
                reg_seq_item t;
                t = reg_seq_item::type_id::create("t");
                t.paddr = rw.addr;
                t.pwrite = (rw.kind == UVM_WRITE)? 1'b1:1'b0;
                if(t.pwrite == 1) t.pwdata = rw.data;
                return t;
        endfunction

 
	function void bus2reg(uvm_sequence_item bus_item,ref uvm_reg_bus_op rw);

  		reg_seq_item t;
  		if (!$cast(t, bus_item))
    			return;
  		rw.addr = t.paddr;

  		if (t.pwrite) begin
    			rw.kind = UVM_WRITE;
    			rw.data = t.pwdata;   
  		end
  		else begin
    			rw.kind = UVM_READ;
    			rw.data = t.prdata;
  		end
  		
  		rw.status = UVM_IS_OK;
	endfunction

endclass
