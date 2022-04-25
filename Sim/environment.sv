`ifndef include_n
`include "interface.sv"
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include  "scoreboard.sv"
`endif
class environment;
  

	generator  gen;
	driver  drv;
	monitor    mon;
	scoreboard scb;
  
	mailbox#(transaction) m1;
	mailbox#(transaction) m2;

	virtual interface intf vif;

	function new(virtual interface intf vif);

		this.vif = vif;
      		m1=new();
		m2=new();
      		gen=new(m1);
      		drv=new(m1,vif);
      		mon=new(m2,vif);
		scb=new(m2);
	endfunction


	task main();
	//drv.reset();
	#100
	$display("Waiting ... ");
 	fork
     		 	gen.run(1,5);
     		 	drv.run(); 
			mon.run();
			scb.run();
	join
endtask


	task run();
	main();
	$stop;
endtask

endclass: environment