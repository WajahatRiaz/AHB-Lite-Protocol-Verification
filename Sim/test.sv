`include "environment.sv"

program test(intf vif);
  bit read;

	bit write;
 	 environment env;
 	task test1();
	env.gen.INCR4(write);
	endtask
	
//task test2();
	//env.gen.INCR4(read);
//endtask

initial begin
   read=0;
write=1;
  	 env = new(vif);
	env.run();
	//$stop;

	//readburst();
//writeburst();

end

endprogram
