`include "environment.sv"

program test(intf vif);
  
  environment env;
 

initial begin
   
  	 env = new(vif);
	env.run();
	$stop;
	

end

endprogram
