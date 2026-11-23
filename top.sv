/*module tb_top;

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
*/


`include "uvm_macros.svh"
import uvm_pkg::*;

`include "defines.svh"

`include "apb_intf.sv"
`include "ahb_intf.sv"
`include "qspi_intf.sv"

`include "qspi_pkg.sv"
import qspi_pkg::*;

`include "QSPI_top.v"

module tb_top;

  bit pclk;
  bit hclk;
  bit resetn;

  // Clock generation
  initial pclk = 0;
  always #5 pclk = ~pclk;

  initial hclk = 0;
  always #7 hclk = ~hclk;

  // Common reset
  initial begin
    resetn = 0;
    repeat (5) @(posedge pclk);
    resetn = 1;
  end

  // Interfaces
  apb_intf  apb_if(pclk, resetn);
  ahb_intf  ahb_if(hclk, resetn);
  qspi_intf qspi_if(resetn);

  // CPOL and CPHA configuration
  initial begin
    qspi_if.cpol = 0;
    qspi_if.cpha = 0;
  end

  // DUT instantiation
  QSPI_top #(
    .DATA_WIDTH (32),
    .ADDR_WIDTH (32),
    .DIVIDER    (4),
    .LINE_SIZE  (4)
  ) dut (

    // Clock and reset
    .PCLK   (apb_if.pclk),
    .HCLK   (ahb_if.hclk),
    .RESETn (resetn),

    // QSPI configuration
    .CPOL (qspi_if.cpol),
    .CPHA (qspi_if.cpha),

    // APB inputs
    .PSEL   (apb_if.psel),
    .PENABLE(apb_if.penable),
    .PWRITE (apb_if.pwrite),
    .PADDR  (apb_if.paddr),
    .PWDATA (apb_if.pwdata),

    // APB outputs
    .PRDATA (apb_if.prdata),
    .PREADY (apb_if.pready),
    .PSLVERR(apb_if.pslverr),

    // AHB inputs
    .HTRANS (ahb_if.htrans),
    .HSEL   (ahb_if.hsel),
    .HWRITE (ahb_if.hwrite),
    .HREADY (ahb_if.hready),
    .HADDR  (ahb_if.haddr),

    // AHB outputs
    .HRDATA   (ahb_if.hrdata),
    .HREADYOUT(ahb_if.hreadyout),
    .HRESP    (ahb_if.hresp),

    // QSPI outputs and bidirectional IO
    .CSn  (qspi_if.csn),
    .SCLK (qspi_if.sclk),

    .io_0 (qspi_if.io_0),
    .io_1 (qspi_if.io_1),
    .io_2 (qspi_if.io_2),
    .io_3 (qspi_if.io_3)
  );

  // UVM configuration
  initial begin
    uvm_config_db #(virtual apb_intf)::set(null, "uvm_test_top.env.apb_agt.*", "vif", apb_if);
    uvm_config_db #(virtual ahb_intf)::set(null, "uvm_test_top.env.ahb_agt.*", "vif", ahb_if);
    uvm_config_db #(virtual qspi_intf)::set(null, "uvm_test_top.env.qspi_agt.mon", "vif", qspi_if);
    uvm_config_db #(virtual qspi_intf)::set(null, "uvm_test_top.env.flash_model", "vif", qspi_if);
    run_test("qspi_test");
  end

always @(qspi_if.sclk) begin
  $display("[%0t] TB: qspi_if.sclk = %b, csn = %b",
           $time, qspi_if.sclk, qspi_if.csn);
end

endmodule

