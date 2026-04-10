module sync_fifo #(parameter DEPTH = 32, DATA_WIDTH = 32) (
                  input        clk,
                  input        rst_n,
                  input        wr_en,
                  input        r_en,
                  input  [DATA_WIDTH-1:0] data_in,
                  output logic [DATA_WIDTH-1:0] data_out,
                  output logic full,
                  output logic empty);
  
  // FIFO memory
  logic [DATA_WIDTH-1:0] fifo [0:DEPTH-1]; 
  // Read and Write Pointers
  logic [$clog2(DEPTH)-1:0] w_ptr, r_ptr;

  always_ff @(posedge clk) begin
    if (!rst_n) begin
      data_out <= 0;
      w_ptr    <= 0;
      r_ptr    <= 0;
    end else begin
      // Write Operation
      if (wr_en && !full) begin
        fifo[w_ptr] <= data_in;
        w_ptr       <= (w_ptr + 1) % DEPTH; // Wrap-around logic
      end

      // Read Operation
      if (r_en && !empty) begin
        data_out <= fifo[r_ptr];
        r_ptr    <= (r_ptr + 1) % DEPTH; // Wrap-around logic
      end
    end
  end

  // Full condition: FIFO is full when the next write position == read pointer
  assign full  = ((w_ptr + 1) % DEPTH) == r_ptr;
  
  // Empty condition: FIFO is empty when write pointer == read pointer
  assign empty = (w_ptr == r_ptr);

endmodule: sync_fifo
