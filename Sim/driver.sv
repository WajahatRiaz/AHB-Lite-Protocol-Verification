class driver;
	transaction tr;
	mailbox #(transaction) m1;

	//mailbox handler
	function new(mailbox #(transaction) m1);
		this.m1=m1;	
	endfunction
	
	task get_INCR4();
		for (int i=0;i<4;i++) begin
		tr=new;
		m1.get(tr);
		$display("Address:0x%0h recieved",tr.HADDR);
		end	
	endtask
	
	task get_INCR8();
		for (int i=0;i<8;i++) begin
		tr=new;
		m1.get(tr);
		$display("Address:0x%0h recieved",tr.HADDR);
		end	
	endtask

	task get_INCR16();
		for (int i=0;i<16;i++) begin
		tr=new;
		m1.get(tr);
		$display("Address:0x%0h recieved",tr.HADDR);
		end	
	endtask

endclass: driver
