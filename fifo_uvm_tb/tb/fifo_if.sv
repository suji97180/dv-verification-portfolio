`include "fifo_defines.svh"
interface fifo_if(input logic clk, input logic rst_n);
  logic [DATA_WIDTH-1:0] data_in;
  logic wr_en, r_en;
  logic [DATA_WIDTH-1:0] data_out;
  logic full, empty;
endinterface: fifo_if