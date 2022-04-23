/*`ifndef include_n
`include"transaction.sv"
`endif*/
class monitor;
	transaction tr;
	mailbox #(transaction) m2;
	virtual interface intf.monitor_port vif;

	//mailbox and virtual interface construct
	function new(mailbox #(transaction) m2,virtual interface intf.monitor_port vif);
	$display("Entering in monitor");
		this.m2=m2;
		this.vif=vif;
	endfunction

        task run();
 
       		forever begin
      		tr = new();
		@(posedge vif.HCLK)begin 
      			 this.tr.HADDR      <=  vif.HADDR;
     			 this.tr.HWRITE    <=   vif.HWRITE;
     			 this.tr.HSIZE      <=   vif.HSIZE;
     			 this.tr.HTRANS     <=   vif.HTRANS;
    			 this.tr.HPROT     <=   vif.HPROT;
    			 this.tr.HSEL       <=   vif.HSEL;
     		 	 this.tr.HBURST    <=   vif.HBURST;
     		 	 this.tr.HWDATA    <=   vif.HWDATA;
    		 	 this.tr.HRDATA    <=  vif.HRDATA;
     		 	 this.tr.HRESP      <=   vif.HRESP;
     			 this.tr.HREADY     <=   vif.HREADY;
			 this.tr.HREADYOUT  <=  vif.HREADYOUT;
      		 	 m2.put(tr);
  			 end
		$display("Received from DUT and sent to scoreboard");
	         end
  	endtask 

endclass: monitor
