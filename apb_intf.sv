interface apb_intf(input logic pclk, input logic resetn);

    logic psel;
    logic penable;
    logic pwrite;
    logic [`ADDR_WIDTH-1:0] paddr;
    logic [`DATA_WIDTH-1:0] pwdata;

    logic pslverr;
    logic [`DATA_WIDTH-1:0] prdata;
    logic pready;

    clocking drv_cb_apb @(posedge pclk);
        default input #1ns output #1ns;
        output psel, penable, pwrite, paddr, pwdata;
        input pready, prdata, pslverr;
    endclocking

    clocking mon_cb_apb @(posedge pclk);
        default input #1ns;
        input psel, penable, pwrite, paddr, pwdata;
        input pready, prdata, pslverr;
    endclocking

    modport DRV_APB(clocking drv_cb_apb);
    modport MON_APB(clocking mon_cb_apb);

endinterface

