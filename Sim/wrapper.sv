interface wrap (input bit HCLK,HRESETn);
   logic [31:0] HADDR;
   logic [31:0] HRDATA;
   logic [31:0] HWDATA;
   logic [3:0] HPROT;
   logic [2:0] HSIZE;
   logic [2:0] HBURST;
   logic [1:0] HTRANS, HSEL;
   logic HREADY, HREADYOUT, HRESP, HWRITE;
endinterface : wrap

module wrapper (port_w, port_if);
    wrap port_w;
    ahb port_if;
    assign port_w.HADDR = port_if.HADDR;
    assign port_w.HRDATA = port_if.HRDATA;
    assign port_w.HWDATA = port_if.HWDATA;
    assign port_w.HPROT = port_if.HPROT;
    assign port_w.HSIZE = port_if.HSIZE;
    assign port_w.HBURST = port_if.HBURST;
    assign port_w.HTRANS = port_if.HTRANS;
    assign port_w.HSEL = port_if.HSEL;
    assign port_w.HREADY = port_if.HREADY;
    assign port_w.HREADYOUT = port_if.HREADYOUT;
    assign port_w.HRESP = port_if.HRESP;
    assign port_w.HWRITE = port_if.HWRITE;
    assign port_w.HCLK = port_if.HCLK;
    assign port_w.HRESETn = port_if.HRESETn;
endmodule: wrapper
