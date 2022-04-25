//`ifndef include_n
//`include "transaction.sv"
//`endif
class scoreboard;
	transaction tr2;
	mailbox#(transaction) m2;
	
	int counter = 0;
	int error= 0;

	logic [31:0] mem[256]; // 32bit wide memory and 256 words
 
	function new (mailbox#(transaction) m2);
		this.m2 = m2;
	endfunction

	task run();
		forever begin
		m2.get(tr2);
		$display("-----------[SCOREBOARD] run task\n");
		$display("Address:%0h Data:%0h",tr2.HADDR,tr2.HWDATA);
		if(tr2.HRESP==0 && tr2.HREADY==0) $display("Transfer pending");
		else if(tr2.HRESP==0 && tr2.HREADY==1) $display("Transfer completed");
		else if (tr2.HRESP==1 && tr2.HREADY==0) $display("Error response first cycle");
		else if (tr2.HRESP==1 && tr2.HREADY==1) $display("Complete Error response");
		end
	endtask

endclass: scoreboard
