
`uvm_analysis_imp_decl(_apb_scb)
`uvm_analysis_imp_decl(_ahb_scb)
`uvm_analysis_imp_decl(_qspi_scb)

class scoreboard extends uvm_scoreboard;

  `uvm_component_utils(scoreboard)

  uvm_analysis_imp_apb_scb  #(apb_seq_item, scoreboard)  ap_imp_apb;
  uvm_analysis_imp_ahb_scb  #(ahb_seq_item, scoreboard)   ap_imp_ahb;
  uvm_analysis_imp_qspi_scb #(qspi_seq_item, scoreboard)  ap_imp_qspi;

  int apb_count;
  int ahb_count;
  int qspi_count;

  function new(string name = "scoreboard", uvm_component parent);
    super.new(name, parent);

    ap_imp_apb  = new("ap_imp_apb", this);
    ap_imp_ahb  = new("ap_imp_ahb", this);
    ap_imp_qspi = new("ap_imp_qspi", this);
  endfunction

  // APB monitor transaction received
  function void write_apb_scb(apb_seq_item t);
    apb_count++;

    `uvm_info("SCB",
      $sformatf("Received APB item: Count=%0d Addr=%0h Write=%0b Wdata=%0h",
      apb_count, t.paddr, t.pwrite, t.pwdata),
      UVM_MEDIUM)
  endfunction

  // AHB monitor transaction received
  function void write_ahb_scb(ahb_seq_item t);
    ahb_count++;

    `uvm_info("SCB",
      $sformatf("Received AHB item: Count=%0d Addr=%0h Write=%0b",
      ahb_count, t.haddr, t.hwrite),
      UVM_MEDIUM)
  endfunction

  // QSPI monitor transaction received
  function void write_qspi_scb(qspi_seq_item t);
    qspi_count++;

    `uvm_info("SCB",
      $sformatf("Received QSPI item: Count=%0d CSn=%0b SCLK=%0b",
      qspi_count, t.csn, t.sclk),
      UVM_MEDIUM)
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);

    `uvm_info("SCB",
      $sformatf("APB items received  = %0d", apb_count), UVM_LOW)

    `uvm_info("SCB",
      $sformatf("AHB items received  = %0d", ahb_count), UVM_LOW)

    `uvm_info("SCB",
      $sformatf("QSPI items received = %0d", qspi_count), UVM_LOW)
  endfunction

endclass

