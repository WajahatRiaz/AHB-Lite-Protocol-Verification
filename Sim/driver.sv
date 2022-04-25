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

	task run();
		$display("Driver sending singals to bus system\n");	
		forever begin
		tr=new;
		m1.get(tr);
			vif.HREADYOUT=1;
			vif.HRESP=0;
		if(vif.HREADYOUT && !vif.HRESP)begin		
		vif.HSEL 	<= tr.HSEL ;
		vif.HADDR	<= tr.HADDR;
		vif.HWDATA	<= tr.HWDATA;
		vif.HWRITE	<= tr.HWRITE;
		vif.HSIZE	<= tr.HSIZE;
		vif.HBURST 	<= tr.HBURST;
		vif.HPROT	<= tr.HPROT;
		vif.HTRANS	<= tr.HTRANS;
		vif.HREADY	<= tr.HREADY;
		$display("Address: %0h Data: %0h",vif.HADDR,vif.HWDATA);
		end
		
		end
	endtask
     		


	task reset();	
			
		$display("Bus System Reset\n");			
		vif.HSEL 	<= 1;
		vif.HADDR	<= 0;
		vif.HWDATA	<= 0;
		vif.HWRITE	<= 0;
		vif.HSIZE	<= 0;
		vif.HBURST 	<= 0;
		vif.HPROT	<= 3;
		vif.HTRANS	<= 0;
		vif.HREADY	<= 1;
endtask
   	

endclass: driver