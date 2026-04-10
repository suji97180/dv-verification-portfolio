module fifo_tb();
  //define parameter
  parameter DEPTH      = 32;
  parameter DATA_WIDTH = 32;
  // logic all variables
  logic clk, rst_n;
  logic wr_en, r_en;
  logic full, empty;
  logic [DATA_WIDTH-1:0] data_in, data_out;
  //instantiate module
  
  sync_fifo #(
        .DEPTH(DEPTH),
        .DATA_WIDTH(DATA_WIDTH)
  ) ff(.clk(clk), .rst_n(rst_n), .wr_en(wr_en), .r_en(r_en),.data_in(data_in), .data_out(data_out), .full(full), .empty(empty));
  
  initial clk = 0;
  always #5 clk = ~clk;
  initial begin
    //RESET condition
    rst_n = 0;
    wr_en = 0;
    r_en  = 0;
    data_in = 0;
    
    //Write check
    #10;
    rst_n = 1;
    #10;
    wr_en = 1;
    data_in = 32'hAABB;
    #10;
    wr_en = 0;
    //Read check;
    #10;
    r_en = 1;
    #10;
    r_en = 0;
    
    //Multiple read and write
    #10;
    wr_en = 1;
    data_in = 32'hCCDD;
    #10;
    data_in = 32'hEEFF;
    #10;
    wr_en = 0;
    #10;
    r_en  = 1;
    #10;
    r_en = 0;
    
    #150;
    $finish;
  end
  initial begin
        $monitor("Time: %0t | clk: %b | rst_n: %b | wr_en: %b | r_en: %b | data_in: %h | data_out: %h | full: %b | empty: %b",
                 $time, clk, rst_n, wr_en, r_en, data_in, data_out, full, empty);
    end
  
 
  initial begin
   $dumpfile("dump.vcd"); $dumpvars(0, fifo_tb);
  end
    
  
endmodule
