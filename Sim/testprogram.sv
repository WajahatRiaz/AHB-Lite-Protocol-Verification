
`include "environment.sv"

program test(intf vif);
    Environment e;
      initial begin
        e = new(vif);
        e.run();
    end
endprogram
