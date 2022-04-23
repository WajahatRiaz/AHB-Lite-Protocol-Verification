//`ifndef include_n
//`include "transaction.sv"
//`endif
class driver;
	transaction tr;
	mailbox #(transaction) m1;
	virtual interface intf.driver_port vif;
	
	//mailbox and virtual interface construct
	function new(mailbox #(transaction) m1,virtual interface intf.driver_port vif);
$display("Entering in driver block");
		this.m1=m1;
		this.vif=vif;
	endfunction
	


	task drive();
		//forever begin	
		tr=new;
		m1.get(tr);

		$display("Bus System Sending signals\n");	
		@(posedge vif.HCLK);		
		vif.HSEL 	<= this.tr.HSEL ;
		vif.HADDR	<= this.tr.HADDR;
		vif.HWDATA	<= this.tr.HWDATA;
		vif.HWRITE	<= this.tr.HWRITE;
		vif.HSIZE	<= this.tr.HSIZE;
		vif.HBURST 	<= this.tr.HBURST;
		vif.HPROT	<= this.tr.HPROT;
		vif.HTRANS	<= this.tr.HTRANS;
		vif.HREADY	<= this.tr.HREADY;

		//end
	endtask
     		


	task reset();	
			
		$display("Bus System Reset\n");			
		vif.HSEL 	<= 0;
		vif.HADDR	<= 0;
		vif.HWDATA	<= 0;
		vif.HWRITE	<= 0;
		vif.HSIZE	<= 0;
		vif.HBURST 	<= 0;
		vif.HPROT	<= 0;
		vif.HTRANS	<= 0;
		vif.HREADY	<= 0;
endtask
   	task run();
		forever begin 
		tr=new();
		m1.get(tr);
		$display("Address:%0h Data:%0h",tr.HADDR,tr.HWDATA);
		//drive();
		end
	endtask  		
     

endclass: driver
