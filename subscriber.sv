`uvm_analysis_imp_decl(_apb)
`uvm_analysis_imp_decl(_ahb)
`uvm_analysis_imp_decl(_qspi)

class subscriber extends uvm_component;

  	`uvm_component_utils(subscriber)

  	uvm_analysis_imp_apb  #(apb_seq_item, subscriber) sport_apb;
  	uvm_analysis_imp_ahb  #(ahb_seq_item, subscriber) sport_ahb;
  	uvm_analysis_imp_qspi #(qspi_seq_item, subscriber) sport_qspi;

  	apb_seq_item  apb_cov_item;
  	ahb_seq_item  ahb_cov_item;
  	qspi_seq_item qspi_cov_item;

  	real apb_cov;
  	real ahb_cov;
  	real qspi_cov;


  	// APB coverage
  	covergroup apb_cg;
    	option.per_instance = 1;
    	pwrite_cp : coverpoint apb_cov_item.pwrite {
      		bins write_bin = {1};
      		bins read_bin  = {0};
    	}
    	psel_cp : coverpoint apb_cov_item.psel {
      		bins selected = {1};
    	}
    	penable_cp : coverpoint apb_cov_item.penable {
      		bins setup   = {0};
      		bins access  = {1};
   	 	}
    	paddr_cp : coverpoint apb_cov_item.paddr {
      		bins addr_bin[] = {[0:255]};
    	}
    	pwdata_cp : coverpoint apb_cov_item.pwdata {
      		bins zero = {0};
      		bins non_zero = {[1:$]};
    	}
    	prdata_cp : coverpoint apb_cov_item.prdata {
      		bins zero = {0};
      		bins non_zero = {[1:$]};
    	}
  	endgroup


  	// AHB coverage
  	covergroup ahb_cg;
    	option.per_instance = 1;
    	htrans_cp : coverpoint ahb_cov_item.htrans {
      		bins idle   = {2'b00};
      		bins busy   = {2'b01};
      		bins nonseq = {2'b10};
      		bins seq    = {2'b11};
    	}
    	hwrite_cp : coverpoint ahb_cov_item.hwrite {
      		bins read_bin  = {0};
      		bins write_bin = {1};
    	}
    	haddr_cp : coverpoint ahb_cov_item.haddr {
      		bins addr_bin[] = {[0:255]};
    	}
    	hresp_cp : coverpoint ahb_cov_item.hresp {
      		bins okay  = {0};
      		bins error = {1};
    	}
    	hrdata_cp : coverpoint ahb_cov_item.hrdata {
      		bins zero = {0};
      		bins non_zero = {[1:$]};
    	}
  	endgroup


  	// QSPI coverage
  	covergroup qspi_cg;
    	option.per_instance = 1;
    	csn_cp : coverpoint qspi_cov_item.csn {
      		bins active   = {0};
      		bins inactive = {1};
    	}
    	sclk_cp : coverpoint qspi_cov_item.sclk {
      		bins low  = {0};
      		bins high = {1};
    	}
    	io0_cp : coverpoint qspi_cov_item.io_0 {
      		bins zero = {0};
      		bins one  = {1};
    	}
    	io1_cp : coverpoint qspi_cov_item.io_1 {
      		bins zero = {0};
      		bins one  = {1};
    	}
    	io2_cp : coverpoint qspi_cov_item.io_2 {
      		bins zero = {0};
      		bins one  = {1};
    	}
    	io3_cp : coverpoint qspi_cov_item.io_3 {
      		bins zero = {0};
      		bins one  = {1};
    	}
  	endgroup

  	function new(string name = "subscriber", uvm_component parent);
    	super.new(name, parent);
    	sport_apb  = new("sport_apb", this);
    	sport_ahb  = new("sport_ahb", this);
    	sport_qspi = new("sport_qspi", this);
    	apb_cg  = new();
    	ahb_cg  = new();
    	qspi_cg = new();
  	endfunction

  	function void write_apb(apb_seq_item t);
    	apb_cov_item = t;
    	apb_cg.sample();
  	endfunction

  	function void write_ahb(ahb_seq_item t);
    	ahb_cov_item = t;
    	ahb_cg.sample();
  	endfunction

  	function void write_qspi(qspi_seq_item t);
    	qspi_cov_item = t;
    	qspi_cg.sample();
 	endfunction


  	function void extract_phase(uvm_phase phase);
    	super.extract_phase(phase);
    	apb_cov  = apb_cg.get_coverage();
    	ahb_cov  = ahb_cg.get_coverage();
    	qspi_cov = qspi_cg.get_coverage();
  	endfunction


  	function void report_phase(uvm_phase phase);
    	super.report_phase(phase);
    	`uvm_info("COVERAGE",$sformatf("APB Coverage  = %0.2f%%", apb_cov), UVM_MEDIUM)
    	`uvm_info("COVERAGE",$sformatf("AHB Coverage  = %0.2f%%", ahb_cov), UVM_MEDIUM)
    	`uvm_info("COVERAGE",$sformatf("QSPI Coverage = %0.2f%%", qspi_cov), UVM_MEDIUM)
  endfunction

endclass
