

module fifo_top_tb;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  `include "fifo_defines.svh"
  
  logic clk = 0;
  logic rst_n;
  
  fifo_if vif(.clk(clk), .rst_n(rst_n));
  sync_fifo #(
        .DEPTH(DEPTH),
        .DATA_WIDTH(DATA_WIDTH)
  ) ff(.clk(vif.clk), .rst_n(vif.rst_n), .wr_en(vif.wr_en), .r_en(vif.r_en),.data_in(vif.data_in), .data_out(vif.data_out), .full(vif.full), .empty(vif.empty));
  
  always #5 clk = ~clk;
  
  initial begin
    rst_n = 0;
    #10; 
    rst_n = 1;
//     #80;
//     rst_n = 0;
//     #120;
//     rst_n = 1;
  end
  initial begin
    uvm_config_db#(virtual fifo_if)::set(null, "*", "vif", vif);
    run_test("fifo_base_test");
  end
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end
  
endmodule: fifo_top_tb