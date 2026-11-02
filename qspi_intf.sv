interface qspi_intf(input logic resetn);

  	//inputs to the DUT
  	logic cpol; 
  	logic cpha;  

  	// output from the DUT
  	logic sclk; 
  	logic csn;   

  	// bidirectional QSPI data lines
  	tri io_0;
  	tri io_1;
  	tri io_2;
  	tri io_3;

  	// these signals used by the Flash model only
    logic flash_oe;  // 1: Flash drives IO( here dut recieves data) , 0: Flash releases IO
  	logic [3:0] flash_io;  // 4-bit data driven by the Flash model


  	assign io_0 = flash_oe ? flash_io[0] : 1'bz;
  	assign io_1 = flash_oe ? flash_io[1] : 1'bz;
  	assign io_2 = flash_oe ? flash_io[2] : 1'bz;
  	assign io_3 = flash_oe ? flash_io[3] : 1'bz;

//   	clocking drv_cb_qspi @(posedge sclk);
//    		default input #1ns;
//     	input csn;
//     	input io_0, io_1, io_2, io_3;
//   	endclocking

  	clocking mon_cb_qspi @(posedge sclk);
    	default input #1ns;
//     	input cpol, cpha, csn;
    	input csn, io_0, io_1, io_2, io_3;
  	endclocking

//  	modport DRV_QSPI(clocking drv_cb_qspi);
  	modport MON_QSPI(clocking mon_cb_qspi);

endinterface

