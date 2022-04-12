interface intf();
	
	
	logic   [31:0] HWDATA; 
 	logic   [31:0] HADDR; 	
	
	logic   [2:0]  HSIZE;	  
	logic   [2:0]  HBURST;  
	logic   [1:0]  HTRANS;  
    	logic   [3:0]  HPROT;  
	bit            HWRITE;  
	logic	[31:0] HRDATA;   
	logic 	       HRESP; 
	logic	       HREADY;

modport driver();


endinterface
