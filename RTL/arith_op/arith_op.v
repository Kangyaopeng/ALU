/***********************************************
#
#      Filename:    arith_op.v
#
#        Author:  Kang Yaopeng   -- 78490223@qq.com
#   Description:  ---
#        Create:  2019-11-06 19:44:23
# Last Modified:  2019-11-06 19:44:23
***********************************************/
module arith_op (
            input  wire       clk     ,
            input  wire       rst_n   ,
            input  wire       start   , 
            input  wire[3:0]  in1     , 
            input  wire[3:0]  in2     ,
            output reg [7:0]  out     ,
            output reg        err     ,  
            output reg        finish  ,  

            input  wire       pclk    , 
            input  wire       presetn , 
            input  wire       psel    , 
            input  wire       penable , 
            input  wire       pwrite  , 
            input  wire[31:0] paddr   , 
            input  wire[31:0] pwdata  , 
            output reg [31:0] prdata  , 
            output reg        pready
           );

  reg[1:0] arith_sel;

  arith_op_reg_ctrl u_arith_op_reg_ctrl(
                      .clk            (pclk     ), 
                      .rst_n          (presetn  ), 
                      .i_psel         (psel     ), 
                      .i_penable      (penable  ), 
                      .i_pwrite       (pwrite   ), 
                      .i_paddr        (paddr    ), 
                      .i_pwdata       (pwdata   ), 
                      .o_prdata       (prdata   ), 
                      .o_pready       (pready   ), 
                      .o_reg_test     ( ), 
                      .o_reg_arith_sel(arith_sel), 
                      .o_reg_finish   ( ), 
                      .i_finish       (finish   ) 
                   );

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      out     <= 8'h0;
      err     <= 1'b0;
      finish  <= 1'b0;
    end
    else if(start) begin
      if(arith_sel==2'h0) begin
        out    <= in1 + in2;
        err    <= 1'b0;
        finish <= 1'b1;
      end
      else if(arith_sel==2'h1) begin
        if(in1 >= in2) begin
          out    <= in1 - in2;
          err    <= 1'b0;
          finish <= 1'b1;
        end
        else begin
          out <= 8'hff;
          err <= 1'b1;
          finish <= 1'b1;
        end
      end
      else if(arith_sel==2'h2) begin
        out    <= in1 * in2;
        finish <= 1'b1;
      end
      else begin
        if(in2 == 4'h0) begin
          out    <= 8'hff;
          err    <= 1'b1;
          finish <= 1'b1;
        end
        else begin
          out     <= in1 / in2;
          finish  <= 1'b1;
        end
      end
    end
    else begin
      out    <= 8'h0;
      err    <= 1'b0;
      finish <= 1'b0;
    end      
  end

endmodule

