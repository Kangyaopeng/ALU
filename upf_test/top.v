/***********************************************
#
#      Filename:    top.v
#
#        Author:  Kang Yaopeng   -- 78490223@qq.com
#   Description:  ---
#        Create:  2019-03-12 15:09:13
# Last Modified:  2019-03-12 15:09:13
***********************************************/
`timescale 1ns/1ps
module TOP(output out1, output out2);

  inst instA1(
                .out1(out1), 
                .out2(out2)
              );
endmodule
