
`include "interface.sv"
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include  "scoreboard.sv"

class environment;
  

	generator  gen;
	driver  drv;
	monitor    mon;
	scoreboard scb;
  
mailbox#(transaction) gen2drv;
mailbox#(transaction) mon2scb;

	virtual interface intf vif;

	function new(virtual interface intf vif);

		this.vif = vif;
      		gen2drv=new(0);
      		gen=new(gen2drv);
      		drv=new(gen2drv,vif);
      		mon=new(mon2scb,vif);
		scb=new(mon2scb);
	endfunction


	task run();
 		 fork 
     		 	gen.INCR4(1);
     		 	drv.run(); 
			mon.run();
			scb.run();
  		join 
   
endtask


endclass: environment
