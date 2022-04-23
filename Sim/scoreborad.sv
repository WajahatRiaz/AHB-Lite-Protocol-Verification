/*`ifndef include_n
`include "transaction.sv"
`endif*/
class scoreboard;
  
 	 bit[31:0]data;
	transaction tr;
 	 mailbox #(transaction) m2;
      
 	 function new(mailbox m2);
		$display("Entering in scoreboard");
      		this.m2 = m2;
       	 endfunction
  

	task run();
		tr=new;
		m2.get(tr);
		$display("Mail recieved from Monitor");
endtask

endclass: scoreboard
