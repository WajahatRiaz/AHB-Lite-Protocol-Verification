
class scoreboard;
  
 	 input bit[31:0]data;
 	 mailbox #(transaction) m2;
      
 	 function new(mailbox m2);
      		this.m2 = m2;
       	 endfunction
  
 	 task score(data);
   		 m2.get(tr);
   		 if(tr.HWRITE == 1)
	  	 	saved_data = tr.HWDATA;
       if(tr.HWRITE == 0) begin
         if (tr.HRDATA == data)
				$display("Receipt is okay");
			else 
				$error("Receipt is Not okay"); 
        	 end
      	end
	endtask

   	 task run();
    		  score(32'b0); 
    	endtask

endclass: scoreboard
