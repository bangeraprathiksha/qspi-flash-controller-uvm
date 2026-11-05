module tb_top;

  bit pclk;
  bit hclk;
  bit resetn;

  initial pclk = 0;
  always #5 pclk = ~pclk;

  initial hclk = 0;
  always #7 hclk = ~hclk;

  initial begin
    resetn = 0;
    repeat (5) @(posedge pclk);
    resetn = 1;
  end

  apb_intf  apb_if(pclk, resetn);
  ahb_intf  ahb_if(hclk, resetn);
  qspi_intf qspi_if(resetn);

  initial begin

    uvm_config_db #(virtual apb_intf)::set( null, "uvm_test_top.env.apb_agt.*", "vif", apb_if);
    uvm_config_db #(virtual ahb_intf)::set( null, "uvm_test_top.env.ahb_agt.*", "vif", ahb_if);
    uvm_config_db #(virtual qspi_intf)::set( null, "uvm_test_top.env.qspi_agt.mon", "vif", qspi_if);
    uvm_config_db #(virtual qspi_intf)::set( null, "uvm_test_top.env.flash_model", "vif", qspi_if);
    run_test("qspi_test");

  end

endmodule
