interface intf(input logic HCLK, HRESTn);
	
	
	logic   [31:0] HWDATA; 
 	logic   [31:0] HADDR;
	logic	[31:0] HRDATA;  
	logic   [2:0]  HSIZE;	  
	logic   [2:0]  HBURST;  
	logic   [3:0]  HPROT;  
	logic   [1:0]  HTRANS;  
	logic          HWRITE;   
	logic 	       HRESP; 
	logic	       HREADY;


endinterface
