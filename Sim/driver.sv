

class driver;
	transaction tr;
	mailbox #(transaction) m1;
	virtual intf vif;

	//mailbox and virtual interface construct
	function new(mailbox #(transaction) m1);
		this.m1=m1;
	
	endfunction
	
	task run ();
		forever begin 
		tr=new();
		m1.get(tr);
		$display("Address:%0h Data:%0h",tr.HADDR,tr.HWDATA);
		end	
	endtask

	task reset(bit HRESTn);
		if(!HRESTn); //HRESTn is the only active low signal
  	  	vif.HADDR   <= 32'b0;
	       	vif.HWDATA  <= 32'b0;
		vif.HRDATA  <= 32'b0;
 	      	vif.HSIZE   <= 3'b010; // Word
       		vif.HBURST  <= 3'b000; // Single Burst
     		vif.HTRANS  <= 2'b00;  // IDLE
     		vif.HWRITE  <= 1'b0;
   	  	vif.HPROT   <= 4'b0;
     		vif.HSEL    <= 1'b0;
		vif.HRESP   <= 1'b0;
		vif.HREADY  <= 1'b1;
		vif.HREADYOUT <=1'b1;
     		$display("Bus System Reset\n");
       	 	
	endtask 



endclass: driver
