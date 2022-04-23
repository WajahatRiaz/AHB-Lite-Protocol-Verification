
module wrapper (intf.dut_port dut_intf);


ahb3lite_sram1rw #( .MEM_SIZE(4), .MEM_DEPTH(256), .HADDR_SIZE(8), .HDATA_SIZE(32),
		   .TECHNOLOGY("GENERIC"),.REGISTERED_OUTPUT("NO"), .INIT_FILE("") ) 

		ahb_master(.HRESETn (dut_intf.HRESETn),
			.HCLK	(dut_intf.HCLK),
			.HSEL	(dut_intf.HSEL),
			.HADDR	(dut_intf.HADDR),
			.HWDATA	(dut_intf.HWDATA),
			.HRDATA	(dut_intf.HRDATA),
			.HWRITE	(dut_intf.HWRITE),
			.HSIZE	(dut_intf.HSIZE),
			.HBURST	(dut_intf.HBURST),
			.HPROT	(dut_intf.HPROT),
			.HTRANS	(dut_intf.HTRANS),
			.HREADYOUT(dut_intf.HREADYOUT),
			.HREADY	(dut_intf.HREADY),
			.HRESP	(dut_intf.HRESP)
);


endmodule
