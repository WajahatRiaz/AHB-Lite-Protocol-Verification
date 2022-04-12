
class generator;
	
	bit [31:0]addr;
	bit [31:0]data;
	bit wr_signal;

	transaction tr;
	mailbox #(transaction) m1;
	
	//mailbox handler
	function new(mailbox #(transaction) m1);	
		this.m1=m1;	
	endfunction
	
	task INCR4(bit wr_data);		
		bit [2:0] add_size;
		tr=new; 
		this.tr.HADDR=addr;
		this.tr.HWDATA=data;
		this.tr.HBURST = 3'b011; //4 Beat Incrementing Burst
       	 	this.tr.HWRITE = wr_data; 
     		this.tr.HTRANS = 3'b010; // Non-Sequential 
		m1.put(tr);
		$display("Address:0x%0h sent to driver\n",tr.HADDR);
	 		
		repeat(3)	
      			begin
			tr=new;
       			this.tr.HWRITE = wr_data; 
       			this.tr.HBURST = 3'b011; //4 Beat Incrementing Burst
      			this.tr.HTRANS = 3'b011; // SEQ for the remaining beats
      			this.tr.HSIZE = 3'b010; // HSIZE=word (32-bits)
      			case(tr.HSIZE)
				3'b000 : add_size = 1;
              			3'b001 : add_size = 2;
          			3'b010 : add_size = 4;
        		endcase 
       			m1.put(tr);	
			addr=addr+add_size;
			this.tr.HADDR = addr;
			$display("Address:0x%0h sent to mailbox",tr.HADDR);
			end
	
		$display("All 4-beats in INCR4 burst sent to driver\n");
		endtask


	task INCR8(bit wr_data);		
		bit [2:0] add_size;
		tr=new; 
		this.tr.HADDR=addr;
		this.tr.HWDATA=data;
		this.tr.HBURST = 3'b101; //8 beat Incrementing Burst
       	 	this.tr.HWRITE = wr_data; 
     		this.tr.HTRANS = 3'b010; // Non-Sequential 
		m1.put(tr);
		$display("Address:0x%0h sent to driver\n",tr.HADDR);
	 		
		repeat(7)	
      			begin
			tr=new;
       			this.tr.HWRITE = wr_data; 
       			this.tr.HBURST = 3'b101; //8 beat Incrementing Burst
      			this.tr.HTRANS = 3'b011; // SEQ for the remaining beats
      			this.tr.HSIZE = 3'b010; // HSIZE=word (32-bits)
      			case(tr.HSIZE)
				3'b000 : add_size = 1;
              			3'b001 : add_size = 2;
          			3'b010 : add_size = 4;
        		endcase 
       			m1.put(tr);	
			addr=addr+add_size;
			this.tr.HADDR = addr;
			$display("Address:0x%0h sent to mailbox",tr.HADDR);
			end
	
		$display("All 8-beats in INCR8 burst sent to driver\n");
		endtask

	task INCR16(bit wr_data);		
		bit [2:0] add_size;
		tr=new; 
		this.tr.HADDR=addr;
		this.tr.HWDATA=data;
		this.tr.HBURST = 3'b111; //16 Beat Incrementing Burst
       	 	this.tr.HWRITE = wr_data; 
     		this.tr.HTRANS = 3'b010; // Non-Sequential 
		m1.put(tr);
		$display("Address:0x%0h sent to driver\n",tr.HADDR);
	 		
		repeat(15)	
      			begin
			tr=new;
       			this.tr.HWRITE = wr_data; 
       			this.tr.HBURST = 3'b111; //16 Beat Incrementing Burst
      			this.tr.HTRANS = 3'b011; // SEQ for the remaining beats
      			this.tr.HSIZE = 3'b010; // HSIZE=word (32-bits)
      			case(tr.HSIZE)
				3'b000 : add_size = 1;
              			3'b001 : add_size = 2;
          			3'b010 : add_size = 4;
        		endcase 
       			m1.put(tr);	
			addr=addr+add_size;
			this.tr.HADDR = addr;
			$display("Address:0x%0h sent to mailbox",tr.HADDR);
			end
	
		$display("All 16-beats in INCR16 burst sent to driver\n");
		endtask


	task SINGLE_BURST(bit wr_data, integer beats);
		bit [2:0] add_size;
		tr=new; 
		this.tr.HADDR=addr;
		this.tr.HWDATA=data;
		this.tr.HBURST = 3'b000; //Single Burst
       	 	this.tr.HWRITE = wr_data; 
     		this.tr.HTRANS = 3'b010; // Non-Sequential 
		m1.put(tr);
		$display("Address:0x%0h sent to driver\n",tr.HADDR);
	 	beats=beats-1; //because remainign are sequential
		repeat(beats)	
      			begin
			tr=new;
       			this.tr.HWRITE = wr_data; 
       			this.tr.HBURST = 3'b000; //Single Burst
      			this.tr.HTRANS = 3'b011; // SEQ for the remaining beats
      			this.tr.HSIZE = 3'b010; // HSIZE=word (32-bits)
      			case(tr.HSIZE)
				3'b000 : add_size = 1;
              			3'b001 : add_size = 2;
          			3'b010 : add_size = 4;
        		endcase 
       			m1.put(tr);	
			addr=addr+add_size;
			this.tr.HADDR = addr;
			$display("Address:0x%0h sent to mailbox",tr.HADDR);
			end
	
		$display("All beats in Single Burst sent to driver\n");
	endtask


endclass: generator
