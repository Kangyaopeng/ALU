/***********************************************
#
#      Filename:    alu.v
#
#        Author:  Kang Yaopeng   -- 78490223@qq.com
#   Description:  ---
#        Create:  2019-10-30 18:34:44
# Last Modified:	2019-11-02 19:21:47
***********************************************/
module alu (
            input  wire       clk     ,
            input  wire       rst_n   ,
            input  wire       start   , 
            input  wire[3:0]  in1     , 
            input  wire[3:0]  in2     ,
            output wire[7:0]  out     ,
            output wire       err     ,  
            output wire       finish  ,  

            input  wire       pclk    , 
            input  wire       presetn , 
            input  wire       psel    , 
            input  wire       penable , 
            input  wire       pwrite  , 
            input  wire[31:0] paddr   , 
            input  wire[31:0] pwdata  , 
            output wire[31:0] prdata  , 
            output wire       pready
           );

  reg logic_en;
  reg arith_en;

  wire       arith_err;
  wire[7:0]  arith_out;
  wire[3:0]  logic_out;
  wire       arith_finish;
  wire       logic_finish;
  wire[31:0] alu_reg_ctrl_prdata;
  wire[31:0] logic_op_prdata;
  wire[31:0] arith_op_prdata;
  wire       alu_reg_ctrl_pready;
  wire       logic_op_pready;
  wire       arith_op_pready;
  reg        alu_reg_ctrl_pready_r;
  reg        logic_op_pready_r;
  reg        arith_op_pready_r;

  wire      err_iso           = arith_err;
  wire      arith_finish_iso  = arith_finish;
  wire[7:0] arith_out_iso     = arith_out;
  wire      logic_finish_iso  = logic_finish;
  wire[3:0] logic_out_iso     = logic_out;

  wire out_en = logic_en && arith_en;
  assign out = logic_en ? {4'h0, logic_out} : arith_en ? arith_out : 8'h0;
  assign err = arith_en ? arith_err : 1'b0;
  assign finish = logic_en ? logic_finish : arith_en ? arith_finish : 1'h0;

  assign prdata = alu_reg_ctrl_pready || alu_reg_ctrl_pready_r ? alu_reg_ctrl_prdata : 
                  logic_op_pready || logic_op_pready_r         ? logic_op_prdata     : 
                  arith_op_pready || arith_op_pready_r         ? arith_op_prdata     : 32'h0;
  assign pready = alu_reg_ctrl_pready || logic_op_pready || arith_op_pready;

  always @(posedge clk or negedge presetn) begin
    if(!presetn) begin
      alu_reg_ctrl_pready_r <= 1'b0;
      logic_op_pready_r     <= 1'b0;
      arith_op_pready_r     <= 1'b0;
    end
    else begin
      alu_reg_ctrl_pready_r <= alu_reg_ctrl_pready  ;
      logic_op_pready_r     <= logic_op_pready      ;
      arith_op_pready_r     <= arith_op_pready      ;
    end
  end

  alu_reg_ctrl u_alu_reg_ctrl(
                      .clk                    (pclk    ), 
                      .rst_n                  (presetn ), 
                      .i_psel                 (paddr[31:16]==16'h4000 ? psel : 1'b0), 
                      .i_penable              (penable ), 
                      .i_pwrite               (pwrite  ), 
                      .i_paddr                (paddr[31:16]==16'h4000 ? {16'h0, paddr[15:0]} : paddr), 
                      .i_pwdata               (pwdata  ), 
                      .o_prdata               (alu_reg_ctrl_prdata), 
                      .o_pready               (alu_reg_ctrl_pready), 
                      .o_reg_logic_op_work_en (logic_en), 
                      .o_reg_arith_op_work_en (arith_en), 
                      .o_reg_no_use           ( ), 
                      .i_no_use               ( ) 
                   );

  arith_op u_arith_op(
          .clk     (clk      ),
          .rst_n   (rst_n    ),
          .start   (arith_en? start : 1'b0), 
          .in1     (in1      ), 
          .in2     (in2      ),
          .err     (arith_err),  
          .out     (arith_out),
          .finish  (arith_finish),  

          .pclk    (pclk     ), 
          .presetn (presetn  ), 
          .psel    (paddr[31:16]==16'h4001 ? psel : 1'b0), 
          .penable (penable  ), 
          .pwrite  (pwrite   ), 
          .paddr   (paddr[31:16]==16'h4001 ? {16'h0, paddr[15:0]} : paddr), 
          .pwdata  (pwdata   ), 
          .prdata  (arith_op_prdata), 
          .pready  (arith_op_pready)
  );

  logic_op u_logic_op(
          .clk     (clk),
          .rst_n   (rst_n    ),
          .start   (logic_en? start : 1'b0), 
          .in1     (in1      ), 
          .in2     (in2      ),
          .out     (logic_out),
          .finish  (logic_finish),  

          .pclk    (pclk     ), 
          .presetn (presetn  ), 
          .psel    (paddr[31:16]==16'h4002 ? psel : 1'b0), 
          .penable (penable  ), 
          .pwrite  (pwrite   ), 
          .paddr   (paddr[31:16]==16'h4002 ? {16'h0, paddr[15:0]} : paddr), 
          .pwdata  (pwdata   ), 
          .prdata  (logic_op_prdata), 
          .pready  (logic_op_pready)
  );

endmodule
