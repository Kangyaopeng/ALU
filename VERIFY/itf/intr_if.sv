/*********************************************************
This UVM Generator is Created By Kang Yaopeng
Mail: 78490223@qq.com
*********************************************************/
`ifndef INTR_IF__SV
`define INTR_IF__SV
interface intr_if(input clk, input rst_n);
  logic IRQ;

  task wait_for_interrupt();
    @(posedge IRQ);
  endtask: wait_for_interrupt

  function bit is_interrupt_cleared();
    if(IRQ == 0)
      return 1;
    else
      return 0;
  endfunction: is_interrupt_cleared

  task wait_n_cycle(int n);
    @(posedge clk);
    assert(n>0);
    repeat(n-1) @(posedge clk);
  endtask: wait_n_cycle
endinterface: intr_if
`endif
