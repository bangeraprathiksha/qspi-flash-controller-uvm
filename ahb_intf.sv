interface ahb_intf(input logic hclk, input logic resetn);

    logic [1:0] htrans;
    logic hsel;
    logic hready;
    logic hwrite;
    logic [`ADDR_WIDTH-1:0] haddr;

    logic hreadyout;
    logic hresp;
    logic [`DATA_WIDTH-1:0] hrdata;

    clocking drv_cb_ahb @(posedge hclk);
        default input #1ns output #1ns;
        output htrans, hsel, hready, hwrite, haddr;
        input hreadyout, hresp, hrdata;
    endclocking

    clocking mon_cb_ahb @(posedge hclk);
        default input #1ns;
        input htrans, hsel, hready, hwrite, haddr;
        input hreadyout, hresp, hrdata;
    endclocking

    modport DRV_AHB(clocking drv_cb_ahb);
    modport MON_AHB(clocking mon_cb_ahb);

endinterface

