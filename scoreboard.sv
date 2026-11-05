`uvm_analysis_imp_decl(_apb)
`uvm_analysis_imp_decl(_ahb)
`uvm_analysis_imp_decl(_qspi)

class scoreboard extends uvm_scoreboard;

  `uvm_component_utils(scoreboard)

  uvm_analysis_imp_apb  #(apb_seq_item, scoreboard)  ap_imp_apb;
  uvm_analysis_imp_ahb  #(ahb_seq_item, scoreboard)  ap_imp_ahb;
  uvm_analysis_imp_qspi #(qspi_seq_item, scoreboard) ap_imp_qspi;

  apb_seq_item  apb_q[$];
  ahb_seq_item  ahb_q[$];
  qspi_seq_item qspi_q[$];

  int pass_count;
  int fail_count;

  function new(string name = "scoreboard",uvm_component parent);
    super.new(name, parent);
    ap_imp_apb  = new("ap_imp_apb", this);
    ap_imp_ahb  = new("ap_imp_ahb", this);
    ap_imp_qspi = new("ap_imp_qspi", this);
  endfunction

  function void write_apb(apb_seq_item t);
    apb_q.push_back(t);
    `uvm_info("SCB",$sformatf("APB: addr=%0h write=%0b data=%0h",t.paddr, t.pwrite, t.pwdata), UVM_MEDIUM)
  endfunction

  function void write_ahb(ahb_seq_item t);
    if (t.htrans inside {2'b10, 2'b11} && t.hwrite == 1'b0) begin
    	ahb_q.push_back(t);
      	`uvm_info("SCB",$sformatf("AHB: addr=%0h write=%0b data=%0h",t.haddr, t.hwrite, t.hwdata), UVM_MEDIUM)
    end
  endfunction

  function void write_qspi(qspi_seq_item t);
    qspi_q.push_back(t);
  endfunction

  task run_phase(uvm_phase phase);
    ahb_seq_item ahb_txn;
    apb_seq_item apb_txn;
    bit [31:0] expected_data;

    forever begin
      fork
        wait(ahb_q.size() > 0);
        wait(apb_q.size() > 0);
        wait(qspi_q.size() > 0);
      join_none
    end

  endtask


  function void report_phase(uvm_phase phase);
    `uvm_info("SCB",$sformatf("Total PASS = %0d, FAIL = %0d",pass_count, fail_count),UVM_LOW)
  endfunction

endclass
