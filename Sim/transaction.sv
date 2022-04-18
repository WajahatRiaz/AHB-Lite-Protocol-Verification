
class transaction;

	//input signals to DUT
	rand bit   [31:0] HWDATA; 
 	rand bit   [31:0] HADDR; 	
	rand bit   [2:0]  HSIZE;	  
	rand bit   [2:0]  HBURST;  
	rand bit   [1:0]  HTRANS;  
    	rand bit   [3:0]  HPROT;  
	rand bit          HWRITE; 
	rand bit 	  HSEL; 
   
	//Output signals from DUT
	bit	   [31:0] HRDATA;   
	bit 	   	  HRESP; 
	bit	          HREADY;

 	constraint constraints_c1 {
   
	 HSIZE  inside {3'b001, 3'b010 , 3'b000}; //HSIZE must be less than or equal to data bus
	 HTRANS dist   {2'b00:=25,2'b01:=25,2'b10:=10,2'b11:=40}; //IDLE ,BUSY, NONSEQ, SEQ
	 HPROT  inside {3'b001}; // protections signal for data fetch only
	 HWRITE dist   {1'b1:=1,1'b0:=1};
	 HSEL   inside {1'b1};	 // Because we have one slave
 	 }

endclass: transaction
