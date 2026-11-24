`uvm_analysis_imp_decl(_apb_scb)
`uvm_analysis_imp_decl(_ahb_scb)
`uvm_analysis_imp_decl(_qspi_scb)

class scoreboard extends uvm_scoreboard;

	`uvm_component_utils(scoreboard)

  	uvm_analysis_imp_apb_scb  #(apb_seq_item, scoreboard)  ap_imp_apb;
  	uvm_analysis_imp_ahb_scb  #(ahb_seq_item, scoreboard)  ap_imp_ahb;
  	uvm_analysis_imp_qspi_scb #(qspi_seq_item, scoreboard) ap_imp_qspi;

  	int apb_count;
  	int ahb_count;
  	int qspi_count;

  	// Expected flash data
  	bit [31:0] expected_data;

  	// QSPI data collection
  	bit [31:0] qspi_received_data;
  	int phase_count;
  	int nibble_count;
  	bit qspi_data_seen;

  	// APB DATA register readback
  	bit [31:0] apb_received_data;
  	bit apb_data_seen;

  	bit qspi_transaction_active;

  	// Register address
  	localparam DATA_ADDR = 8'h4E;

  	function new(string name = "scoreboard", uvm_component parent);
 		super.new(name, parent);
    		ap_imp_apb  = new("ap_imp_apb", this);
    		ap_imp_ahb  = new("ap_imp_ahb", this);
    		ap_imp_qspi = new("ap_imp_qspi", this);
  	endfunction

  	function void build_phase(uvm_phase phase);
  		super.build_phase(phase);
	endfunction

  	// -----------------------------------------
  	// APB monitor transaction received
  	// -----------------------------------------

  	function void write_apb_scb(apb_seq_item t);
    		apb_count++;

   	 	`uvm_info("SCB", $sformatf("Received APB item: Count=%0d Addr=%0h Write=%0b Wdata=%0h", apb_count, t.paddr, t.pwrite, t.pwdata), UVM_MEDIUM)

  	endfunction


  	// -----------------------------------------
  	// AHB monitor transaction received
  	// -----------------------------------------

  	function void write_ahb_scb(ahb_seq_item t);
    		ahb_count++;

    		`uvm_info("SCB",$sformatf("Received AHB item: Count=%0d Addr=%0h Write=%0b", ahb_count, t.haddr, t.hwrite), UVM_MEDIUM)
  	endfunction


  	// -----------------------------------------
  	// QSPI monitor transaction received
  	// -----------------------------------------

  	function void write_qspi_scb(qspi_seq_item t);

    		qspi_count++;

		`uvm_info("SCB",$sformatf("Received QSPI item: Count=%0d CSn=%0b SCLK=%0b IO[3:0]=%b", qspi_count, t.csn, t.sclk, {t.io_3, t.io_2, t.io_1, t.io_0}), UVM_MEDIUM)

    		// Start a new QSPI transaction
    		if (t.csn == 1'b0 && !qspi_transaction_active) begin

      			qspi_transaction_active = 1'b1;

      			phase_count = 0;
      			nibble_count = 0;
      			qspi_received_data = '0;

      			`uvm_info("SCB", "QSPI transaction started",  UVM_MEDIUM)
    		end

   	 	// Collect data only when CSn is active
    		if ((t.csn == 1'b0) && (t.sclk == 1'b1)) begin

      			// First 20 clocks:
      			// 8 opcode + 6 address + 2 mode + 4 dummy
      			if (phase_count >= 20 && phase_count < 28) begin
        			qspi_received_data = {qspi_received_data[27:0],  t.io_3, t.io_2, t.io_1, t.io_0};
        			nibble_count++;
				`uvm_info("SCB",  $sformatf("QSPI data nibble %0d = %h",nibble_count, {t.io_3, t.io_2, t.io_1, t.io_0}),  UVM_MEDIUM)

        			// Eight nibbles make 32-bit data
				if (nibble_count == 8) begin

  					if (expected_data_queue.size() > 0) begin
    						expected_data = expected_data_queue.pop_front();
    						qspi_data_seen = 1'b1;
    						if (qspi_received_data === expected_data)
      							`uvm_info("SCB", "QSPI data comparison PASSED", UVM_LOW)

    						else
      						`uvm_error("SCB",$sformatf("QSPI data mismatch! Expected=%08h Actual=%08h", expected_data, qspi_received_data))

  					end
  					else begin
    						`uvm_error("SCB", "Expected data queue is empty")
 					end

 	 				qspi_transaction_active = 1'b0;
				end

      			end	
      			phase_count++;

    		end

 	 endfunction


  	// -----------------------------------------
  	// Report phase
  	// -----------------------------------------
  	function void report_phase(uvm_phase phase);

    		super.report_phase(phase);

    		`uvm_info("SCB", $sformatf("APB items received  = %0d", apb_count),UVM_LOW)
    		`uvm_info("SCB", $sformatf("AHB items received  = %0d", ahb_count),UVM_LOW)
    		`uvm_info("SCB", $sformatf("QSPI items received = %0d", qspi_count), UVM_LOW)

   	 	if (!qspi_data_seen) begin
     	 		`uvm_error("SCB","QSPI data was not received completely")
    		end

    		if (!apb_data_seen) begin
      			`uvm_info("SCB","APB DATA register readback was not performed",UVM_LOW)
    		end
  	endfunction

endclass

