`include "interface.sv"
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"

class environment;


    mailbox #(transaction) mbx1,mbx2;
    intf f1(clock,HRESTn);
    virtual intf vif;
    generator gen;
    driver dr;
    monitor mon;
    scoreboard scb;
    bit read=0;
    bit write=1;


    mbx1=new(); //generator - driver mailbox
    mbx2=new(); //monitor - scoreboard mailbox
 
    gen=new(mbx1);
    

    dr=new(mbx1,vif);
    mon=new(mbx2,vif);
    scb=new(mbx2);

  task run ();
    fork
       gen.WRAP4(read);
       gen.INCR8(write);
       gen.INCR16(read);
       dr.run();
    join
    
    end
  
endclass: environment


