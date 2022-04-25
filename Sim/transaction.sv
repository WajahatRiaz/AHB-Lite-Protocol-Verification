
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
	bit		  HREADYOUT;

 	constraint constraints_c1 {
   
	 HSIZE  inside {3'b001, 3'b010 , 3'b000}; //HSIZE must be less than or equal to width of data bus
	 HTRANS dist   {2'b00:=25,2'b01:=25,2'b10:=10,2'b11:=40}; //IDLE ,BUSY, NONSEQ, SEQ
         HBURST dist   {0:=1, 1:=1, 2:=1, 3:=1, 4:=1, 5:=1, 6:=1, 7:=1}; 
	 HPROT  inside {4'b0011}; // protections signal for data and privileged fetch only
	 HWRITE dist   {1'b1:=1,1'b0:=1};
	 HSEL   inside {1'b1};	 // Because we have one slave
 	 HADDR  inside {[32'h0:32'h255]}; // since slave memory range is 0x0-0x255
	 }

endclass: transaction