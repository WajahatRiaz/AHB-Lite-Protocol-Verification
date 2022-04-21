
class generator;
	
	bit [31:0]addr;
	bit [31:0]data;
	bit readwrite;

	transaction tr;
	mailbox #(transaction) m1;
	
	//mailbox constructor
	function new(mailbox #(transaction) m1);	
		this.m1=m1;	
	endfunction

	
	task automatic INCR4(bit readwrite);
		bit check;
		bit [2:0] index; //increment in addresses
		bit [2:0] size; //HSIZE
		tr=new; 
		
		this.tr.HWRITE.rand_mode(0);
		this.tr.HWRITE = readwrite; 

		this.tr.HBURST.rand_mode(0);
		this.tr.HBURST = 3'b011; //4 beat Incrementing Burst
		
		this.tr.HTRANS.rand_mode(0);
		this.tr.HTRANS= 2'b10; //NONSEQ
     		
		check=tr.randomize();	
		
		m1.put(tr);
		$display("Address:0x%0h sent to mailbox",tr.HADDR);
		size=this.tr.HSIZE;
		addr=this.tr.HADDR;
		

		repeat(3)	
      			begin
			tr=new;
			this.tr.HADDR.rand_mode(0);
			this.tr.HADDR=addr;	

			this.tr.HWRITE.rand_mode(0);
			this.tr.HWRITE = readwrite; 			

			this.tr.HBURST.rand_mode(0);
			this.tr.HBURST = 3'b011; //4 beat Incrementing Burst
      			
			this.tr.HSIZE.rand_mode(0);
			this.tr.HSIZE = size; 

			check=tr.randomize();
	
			case(tr.HSIZE)
				3'b000 : index = 1;
              			3'b001 : index = 2;
          			3'b010 : index = 4;
        		endcase 

			m1.put(tr);	
			addr=addr+index;
			this.tr.HADDR = addr;
			$display("Address:0x%0h HSIZE:%0d sent to mailbox",tr.HADDR, tr.HSIZE);
			end
	
		$display("All 4-beats in INCR4 burst sent to driver\n");
		endtask

	
	task automatic INCR8(bit readwrite);
		bit check;
		bit [2:0] index; //increment in addresses
		bit [2:0] size; //HSIZE
		tr=new; 
		
		this.tr.HWRITE.rand_mode(0);
		this.tr.HWRITE = readwrite; 

		this.tr.HBURST.rand_mode(0);
		this.tr.HBURST = 3'b101; //8 beat Incrementing Burst
		
		this.tr.HTRANS.rand_mode(0);
		this.tr.HTRANS= 2'b10; //NONSEQ
     		
		check=tr.randomize();	
		
		m1.put(tr);
		$display("Address:0x%0h sent to mailbox",tr.HADDR);
		size=this.tr.HSIZE;
		addr=this.tr.HADDR;
		

		repeat(7)	
      			begin
			tr=new;
			this.tr.HADDR.rand_mode(0);
			this.tr.HADDR=addr;	

			this.tr.HWRITE.rand_mode(0);
			this.tr.HWRITE = readwrite; 			

			this.tr.HBURST.rand_mode(0);
			this.tr.HBURST = 3'b101; //8 beat Incrementing Burst
      			
			this.tr.HSIZE.rand_mode(0);
			this.tr.HSIZE = size; 
			
			check=tr.randomize();

			case(tr.HSIZE)
				3'b000 : index = 1;
              			3'b001 : index = 2;
          			3'b010 : index = 4;
        		endcase 

			m1.put(tr);	
			addr=addr+index;
			this.tr.HADDR = addr;
			$display("Address:0x%0h HSIZE:%0d sent to mailbox",tr.HADDR, tr.HSIZE);
			end
	
		$display("All 8-beats in INCR4 burst sent to driver\n");
		endtask

	task automatic INCR16(bit  readwrite);		
		bit check;
		bit [2:0] index; //increment in addresses
		bit [2:0] size; //HSIZE
		tr=new;  
		
		this.tr.HWRITE.rand_mode(0);
		this.tr.HWRITE = readwrite; 

		this.tr.HBURST.rand_mode(0);
		this.tr.HBURST = 3'b111; //16 beat Incrementing Burst
		
		this.tr.HTRANS.rand_mode(0);
		this.tr.HTRANS= 2'b10; //NONSEQ
     		
		check=tr.randomize();	
		
		m1.put(tr);
		$display("Address:0x%0h sent to mailbox",tr.HADDR);
		size=this.tr.HSIZE;
		addr=this.tr.HADDR;

		repeat(15)	
      			begin
			tr=new;
			this.tr.HADDR.rand_mode(0);
			this.tr.HADDR=addr;	

			this.tr.HWRITE.rand_mode(0);
			this.tr.HWRITE = readwrite; 			

			this.tr.HBURST.rand_mode(0);
			this.tr.HBURST = 3'b111; //16 beat Incrementing Burst
      			
			this.tr.HSIZE.rand_mode(0);
			this.tr.HSIZE = size; 
			
			check=tr.randomize();

			case(tr.HSIZE)
				3'b000 : index = 1;
              			3'b001 : index = 2;
          			3'b010 : index = 4;
        		endcase 

			m1.put(tr);	
			addr=addr+index;
			this.tr.HADDR = addr;
			$display("Address:0x%0h HSIZE:%0d sent to mailbox",tr.HADDR, tr.HSIZE);
			end
	
		$display("All 16-beats in INCR16 burst sent to driver\n");
		endtask

	task automatic SINGLE_BURST(bit  readwrite);
		bit check;
		bit [2:0] index;
		tr=new; 
		
		this.tr.HWRITE.rand_mode(0);
		this.tr.HWRITE = readwrite; 

		this.tr.HBURST.rand_mode(0);
		this.tr.HBURST = 3'b000; //Single Burst
		
		this.tr.HTRANS.rand_mode(0);
		this.tr.HTRANS= 2'b10; //NONSEQ
     		
		check=tr.randomize();	
	       	 		
		m1.put(tr);

		$display("Address:0x%0h sent to mailbox\n",tr.HADDR);
		
		$display("Single Burst sent to driver\n");
		endtask
	

endclass: generator
