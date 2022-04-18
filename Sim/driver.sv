
class driver;
	transaction tr;
	mailbox #(transaction) m1;
	
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

endclass: driver
