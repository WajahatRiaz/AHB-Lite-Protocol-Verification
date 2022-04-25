
`include "test.sv"
`include "interface.sv"
`include "wrapper.sv"
module top;

	bit clock = 0;
	logic reset = 1;


	always begin 
	    clock = ~clock;
	 #2;
	end


intf f1(clk,reset);		
wrapper wrap(f1);		
test t1(f1);	


endmodule