/*`ifndef include_n
`include "transaction.sv"
`endif*/
class generator;
	
	bit [31:0]addr;
	bit [31:0]data;
	rand bit [3:0] burst;
	transaction tr;
	mailbox #(transaction) m1;
	
	//mailbox constructor
	function new(mailbox #(transaction) m1);	
$display("Entering Generator block");
		this.m1=m1;	
	endfunction

	
	task INCR4(bit readwrite);
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
			$display("Address:0x%0h HSIZE:%0d HBURST:0%d sent to mailbox",tr.HADDR, tr.HSIZE, tr.HBURST);
			end
	
		$display("All 4-beats in INCR4 burst sent to driver\n");
		endtask

	
	task INCR8(bit readwrite);
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
			$display("Address:0x%0h HSIZE:%0d HBURST:0%d sent to mailbox",tr.HADDR, tr.HSIZE, tr.HBURST);
			end
	
		$display("All 8-beats in INCR4 burst sent to driver\n");
		endtask

	task  INCR16(bit  readwrite);		
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
			$display("Address:0x%0h HSIZE:%0d HBURST:0%d sent to mailbox",tr.HADDR, tr.HSIZE, tr.HBURST);
			end
	
		$display("All 16-beats in INCR16 burst sent to driver\n");
		endtask

	task  SINGLE_BURST(bit  readwrite);
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

		$display("Address:0x%0h sent to mailbox",tr.HADDR);
		
		$display("Single Burst sent to driver\n");
		endtask
	
	task INCR(bit readwrite,int beats);
		bit check;
		bit [2:0] index; //increment in addresses
		bit [2:0] size; //HSIZE
		tr=new; 
		
		this.tr.HWRITE.rand_mode(0);
		this.tr.HWRITE = readwrite; 

		this.tr.HBURST.rand_mode(0);
		this.tr.HBURST = 3'b001; //undefined length burst
		
		this.tr.HTRANS.rand_mode(0);
		this.tr.HTRANS= 2'b10; //NONSEQ
     		
		check=tr.randomize();	
		
		m1.put(tr);
		$display("Address:0x%0h sent to mailbox",tr.HADDR);
		size=this.tr.HSIZE;
		addr=this.tr.HADDR;
		

		repeat(beats)	
      			begin
			tr=new;
			this.tr.HADDR.rand_mode(0);
			this.tr.HADDR=addr;	

			this.tr.HWRITE.rand_mode(0);
			this.tr.HWRITE = readwrite; 			

			this.tr.HBURST.rand_mode(0);
			this.tr.HBURST = 3'b001; //Undefined length burst
      			
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
			$display("Address:0x%0h HSIZE:%0d HBURST:0%d sent to mailbox",tr.HADDR, tr.HSIZE, tr.HBURST);
			end
	
		$display("All beats in undefined length burst send to driver\n");
		endtask


	task  WRAP4(bit readwrite);
			bit check;
			bit [2:0] index; //increment in addresses
			bit [2:0] size; //HSIZE
			int n_bits;
			int count=0;
			tr=new; 
		
			this.tr.HWRITE.rand_mode(0);
			this.tr.HWRITE = readwrite; 

			this.tr.HBURST.rand_mode(0);
			this.tr.HBURST = 3'b010; //4 beat Wrapping Burst
		
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
				count++;
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

				if (tr.HADDR[3:0]==4'hf && count > 1)begin
					
				n_bits=$clog2(index*4);
  				wrapx(n_bits,index,addr);
				m1.put(tr);
				$display("Address:0x%0h HSIZE:%0d HBURST:0%d sent to mailbox",tr.HADDR, tr.HSIZE, tr.HBURST);
				end
				else begin
					m1.put(tr);	
					addr=addr+index;
					this.tr.HADDR = addr;
					$display("Address:0x%0h HSIZE:%0d sent to mailbox",tr.HADDR, tr.HSIZE);
					m1.put(tr);
				end
	
				end
		$display("All 4-beats in WRAP4 burst sent to driver\n");
		endtask
	
	task  WRAP8(bit readwrite);
			bit check;
			bit [2:0] index; //increment in addresses
			bit [2:0] size; //HSIZE
			int n_bits;
			int count=0;
			tr=new; 
		
			this.tr.HWRITE.rand_mode(0);
			this.tr.HWRITE = readwrite; 

			this.tr.HBURST.rand_mode(0);
			this.tr.HBURST = 3'b100; //8 beat Wrapping Burst
		
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
				count++;
				this.tr.HADDR.rand_mode(0);
				this.tr.HADDR=addr;	

				this.tr.HWRITE.rand_mode(0);
				this.tr.HWRITE = readwrite; 			

				this.tr.HBURST.rand_mode(0);
				this.tr.HBURST = 3'b100; //8 beat Wrapping Burst
      			
				this.tr.HSIZE.rand_mode(0);
				this.tr.HSIZE = size; 

				check=tr.randomize();
	
				case(tr.HSIZE)
				3'b000 : index = 1;
              			3'b001 : index = 2;
          			3'b010 : index = 4;
        			endcase 

				if (tr.HADDR[3:0]==4'hf && count>3)begin
					
				n_bits=$clog2(index*4);
  				wrapx(n_bits,index,addr);
				m1.put(tr);
				$display("Address:0x%0h HSIZE:%0d sent to mailbox",tr.HADDR, tr.HSIZE);
				end

				else begin
					m1.put(tr);	
					addr=addr+index;
					this.tr.HADDR = addr;
					$display("Address:0x%0h HSIZE:%0d HBURST:0%d sent to mailbox",tr.HADDR, tr.HSIZE, tr.HBURST);
					m1.put(tr);
				end
	
				end
		$display("All 8-beats in WRAP8 burst sent to driver\n");
		endtask
	
	task  WRAP16(bit readwrite);
			bit check;
			bit [2:0] index; //increment in addresses
			bit [2:0] size; //HSIZE
			int n_bits;
			int count=0;
			tr=new; 
		
			this.tr.HWRITE.rand_mode(0);
			this.tr.HWRITE = readwrite; 

			this.tr.HBURST.rand_mode(0);
			this.tr.HBURST = 3'b110; //16 beat Wrapping Burst
		
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
				count++;
				
				this.tr.HADDR.rand_mode(0);
				this.tr.HADDR=addr;	

				this.tr.HWRITE.rand_mode(0);
				this.tr.HWRITE = readwrite; 			

				this.tr.HBURST.rand_mode(0);
				this.tr.HBURST = 3'b110; //16 beat Wrapping Burst
      			
				this.tr.HSIZE.rand_mode(0);
				this.tr.HSIZE = size; 

				check=tr.randomize();
	
				case(tr.HSIZE)
				3'b000 : index = 1;
              			3'b001 : index = 2;
          			3'b010 : index = 4;
        			endcase 

				if (tr.HADDR[3:0]==4'hf && count>6)begin
					
				n_bits=$clog2(index*4);
  				wrapx(n_bits,index,addr);
				m1.put(tr);
				$display("Address:0x%0h HSIZE:%0d sent to mailbox",tr.HADDR, tr.HSIZE);
				end
				else begin
					m1.put(tr);	
					addr=addr+index;
					this.tr.HADDR = addr;
					$display("Address:0x%0h HSIZE:%0d HBURST:0%d sent to mailbox",tr.HADDR, tr.HSIZE, tr.HBURST);
					m1.put(tr);
				end
	
				end
		$display("All 16-beats in WRAP8 burst sent to driver\n");
		endtask

	task wrapx(input int n_bits,add_size,addr);
   		int temp;
		tr=new;
    		case(n_bits)
    		  2 : begin 
     			  temp[1:0] = addr[1:0];
    		          temp[1:0] = temp+add_size;
       			  tr.HADDR = {addr[31:2],temp[1:0]}; end
     		 3 : begin 
     		   temp[2:0] = addr[2:0];
       			 temp[2:0] = temp+add_size;
      			  tr.HADDR = {addr[31:3],temp[2:0]}; end
     		 4 : begin 
       			 temp[3:0] = addr[3:0];
      		  	 temp[3:0] = temp+add_size;
       		 	 tr.HADDR = {addr[31:4],temp[3:0]}; end
      
		5 : begin 
       			 temp[4:0] = addr[4:0];
       			 temp[4:0] = temp+add_size;
       			 tr.HADDR = {addr[31:5],temp[4:0]}; end
    endcase
  endtask

 	
	task run (bit readwrite,integer count);
	 	
		bit check;
		tr=new;
		check=tr.randomize();	
	repeat(count)begin 
		case(tr.HBURST)
				0: SINGLE_BURST(readwrite);
  				1:  INCR(readwrite,10);
 				2:  WRAP4(readwrite);
   				3:  INCR4(readwrite);
   				4:  WRAP8(readwrite);
   				5:  INCR8(readwrite);
  				6:  WRAP16(readwrite);
  				7:  INCR16(readwrite);
		endcase
	end
		
	endtask
endclass: generator
