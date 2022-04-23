interface intf(input logic HCLK, HRESETn);
	
	logic   [31:0] HWDATA; 
 	logic   [31:0] HADDR;
	logic	[31:0] HRDATA;  
	logic   [2:0]  HSIZE;	  
	logic   [2:0]  HBURST;  
	logic   [3:0]  HPROT;  
	logic   [1:0]  HTRANS;  
	logic          HWRITE; 
	logic 	       HSEL;  
	logic 	       HRESP; 
	logic	       HREADY;
	logic 	       HREADYOUT;

 modport driver_port(
      	input 		HCLK,
      	input  		HRESETn,
      	output 		HSEL,HADDR,HWDATA,HWRITE,HRDATA,HSIZE,HBURST,HPROT,HTRANS,HREADY,
	input 		HREADYOUT,HRESP
  );

clocking driver_cb @(posedge HCLK);

	default input #1 output #1; //input and output skews
	output 		HSEL,HADDR,HWDATA,HWRITE,HSIZE,HBURST,HPROT,HTRANS,HREADY;
	input 		HREADYOUT,HRESP;

endclocking 

 modport monitor_port(
	input 		HCLK,
      	input  		HRESETn,
      	input   	HSEL,
  	input    	HADDR,
 	input    	HWDATA,
  	input           HWRITE,
  	input        	HSIZE,
  	input        	HBURST,
  	input        	HPROT,
  	input        	HTRANS,
  	input           HREADY,
	output 		HREADYOUT,
	output          HRESP,
	output 		HRDATA
  );

modport dut(
      	input  		HRESETn,
      	input  		HCLK,
      	input   	HSEL,
  	input   	HADDR,
 	input   	HWDATA,
  	output 		HRDATA,
  	input           HWRITE,
  	input       	HSIZE,
  	input       	HBURST,
  	input       	HPROT,
  	input       	HTRANS,
  	output 		HREADYOUT,
  	input           HREADY,
  	output          HRESP
  );

endinterface
