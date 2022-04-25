//`ifndef include_n
//`include "transaction.sv"
//`endif

class monitor;
	transaction tr2;
	mailbox #(transaction) m2;
	virtual interface intf.monitor_port vif;
	
	//mailbox and virtual interface construct
	function new(mailbox #(transaction) m2,virtual interface intf.monitor_port vif);
		$display("Entering in monitor block");
		this.m2=m2;
		this.vif=vif;
	endfunction


	function void get_signals(transaction tr2);
			tr2.HADDR	<= vif.HADDR ;
			tr2.HSIZE	<=vif.HSIZE;
			tr2.HBURST	<= vif.HBURST;
			tr2.HPROT	<= vif.HPROT;
			tr2.HTRANS	<= vif.HTRANS;
			tr2.HWDATA	<=vif.HWDATA;
			tr2.HSEL	<=vif.HSEL;
	endfunction
		
		task run();
		forever begin
			tr2 = new;
			@(posedge vif.HCLK);
			get_signals(tr2);
			@(posedge vif.HCLK);
			tr2.HRESP	<= vif.HRESP;
			tr2.HREADY	<=vif.HREADY;
			tr2.HREADYOUT	<=vif.HREADYOUT;
			        m2.put(tr2);
		$display("Address:%0h Data:%0h",vif.HADDR,vif.HWDATA);
			end
			
		$display("\n\n----------packet receive from memory---------\n\n");
		endtask

endclass: monitor
