class transaction;

	//input signals to DUT
	rand bit   [31:0] HWDATA; 
 	rand bit   [31:0] HADDR; 	
	rand bit   [2:0]  HSIZE;	  
	rand bit   [2:0]  HBURST;  
	rand logic [1:0]  HTRANS;  
    	rand logic [3:0]  HPROT;  
	rand bit          HWRITE;  
   
	//Output signals from DUT
	logic	   [31:0] HRDATA;   
	bit 	   	  HRESP; 
	bit	          HREADY;
endclass: transaction
