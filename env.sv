class qspi_env extends uvm_env;

  	`uvm_component_utils(qspi_env)

  	apb_agent  apb_agt;
  	ahb_agent  ahb_agt;
  	qspi_agent qspi_agt;

  	top_reg_block reg_model;
  	adapter apb_adapter;
  	predictor predictor_inst;

  	subscriber s;
 	scoreboard scb;

  	qspi_flash_model flash_model;

  	qspi_virtual_sequencer v_seqr;


  	function new(string name = "qspi_env", uvm_component parent );
    	super.new(name, parent);
  	endfunction

  	function void build_phase(uvm_phase phase);
    	super.build_phase(phase);	
    	apb_agt = apb_agent::type_id::create("apb_agt", this);
    	ahb_agt = ahb_agent::type_id::create("ahb_agt", this);
    	qspi_agt = qspi_agent::type_id::create("qspi_agt", this);
    	flash_model = qspi_flash_model::type_id::create("flash_model", this);
   	 	reg_model = top_reg_block::type_id::create("reg_model");
    	reg_model.build();
    	apb_adapter = adapter::type_id::create("apb_adapter");
    	predictor_inst = predictor::type_id::create("predictor_inst", this);
    	s = subscriber::type_id::create("s", this);
    	scb = scoreboard::type_id::create("scb", this);
    	v_seqr = qspi_virtual_sequencer::type_id::create("v_seqr", this);
  	endfunction


  	function void connect_phase(uvm_phase phase);
    	super.connect_phase(phase);

    	reg_model.default_map.set_sequencer(apb_agt.seqr, apb_adapter);
    	reg_model.default_map.set_base_addr(0);
    	predictor_inst.map = reg_model.default_map;
    	predictor_inst.adapter = apb_adapter;

        apb_agt.mon.ap_apb.connect(predictor_inst.bus_in);

    	v_seqr.apb_seqr = apb_agt.seqr;
    	v_seqr.ahb_seqr = ahb_agt.seqr;

    	apb_agt.mon.ap_apb.connect(s.sport_apb);
    	ahb_agt.mon.ap_ahb.connect(s.sport_ahb);
    	qspi_agt.mon.ap_qspi.connect(s.sport_qspi);

    	apb_agt.mon.ap_apb.connect(scb.ap_imp_apb);
    	ahb_agt.mon.ap_ahb.connect(scb.ap_imp_ahb);
    	qspi_agt.mon.ap_qspi.connect(scb.ap_imp_qspi);

    	reg_model.default_map.set_auto_predict(0);

  	endfunction

endclass
