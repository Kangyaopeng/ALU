/***********************************************
#
#      Filename:    tb.sv
#
#        Author:  Kang Yaopeng   -- 78490223@qq.com
#   Description:  ---
#        Create:  2019-03-12 15:15:23
# Last Modified:  2019-03-12 15:15:23
***********************************************/
`timescale 1ns/1ps
module tb;
  import UPF::*;
  wire out1;
  wire out2;
  TOP u_TOP(
              .out1(out1), 
              .out2(out2)
            );

  initial begin
    #10000;
    supply_on("VDD", 1.0);
    supply_on("VDDA", 1.0);
    #1000;
    supply_off("VDD");
    #10000;
    supply_on("VDD", 1.0);
    #1000;
    supply_off("VDDA");
    #10000;
    supply_on("VDDA", 1.0);
    #1000;
    $finish;
  end

  always begin
    #1000;
    $display("The timestamp is : @", $time);
  end

  initial begin
    $vcdpluson;
    $dumpvars;
  end

endmodule
