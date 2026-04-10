class fifo_sequence extends uvm_sequence #(fifo_sequence_item);
  `uvm_object_utils(fifo_sequence)
  function new(string name = "fifo_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    fifo_sequence_item seq;
//     repeat(15) begin
//       seq = fifo_sequence_item::type_id::create("seq");
//       start_item(seq);
//       if(!seq.randomize()) begin
//         `uvm_error("SEQUENCE_ERROR", "randomization failed");
//       end
//       `uvm_info("SEQUENCE_INFO", seq.convert2string(), UVM_LOW);
//       finish_item(seq);
//     end
  	// First, perform writes before reads
    repeat (10) begin
      req = fifo_sequence_item::type_id::create("req");
      start_item(req);
      req.data_in = $urandom();
      req.wr_en = 1;
      req.r_en = 0;  // Don't read yet
      finish_item(req);
    end

    // Now perform reads
    repeat (12) begin
      req = fifo_sequence_item::type_id::create("req");
      start_item(req);
      req.wr_en = 0;
      req.r_en = 1;
      finish_item(req);
    end   
  endtask
endclass: fifo_sequence