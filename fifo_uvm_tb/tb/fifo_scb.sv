//Create specially named analysis ports for communicating to the evaluator
//format is `uvm_analysis_imp_decl(_xx); xx can be any name
`include "fifo_defines.svh"
`uvm_analysis_imp_decl(_predictor)
`uvm_analysis_imp_decl(_evaluator)

class fifo_scoreboard extends uvm_scoreboard;
  //register the class with the factory
  `uvm_component_utils(fifo_scoreboard)
  //create the new constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  //Create analysis import export handle
  uvm_analysis_imp_predictor #(fifo_sequence_item, fifo_scoreboard) pred_ap;
  uvm_analysis_imp_evaluator #(fifo_sequence_item, fifo_scoreboard) eval_ap;
  
  //lets use queue as a model for fifo.
  logic [DATA_WIDTH-1:0] ref_fifo [$]; //DATA_WIDTH & DEPTH are defined in defines file.
  logic [DATA_WIDTH-1:0] read_delay_fifo[$]; // Delay queue to match FIFO latency
  int count;
//   int num_passed, num_failed; //Pass and fail scorecards
  //lets add an interface to get the reset signal
  virtual fifo_if vif;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    pred_ap = new("pred_ap", this);
    eval_ap = new("eval_ap", this);
    if(!uvm_config_db #(virtual fifo_if)::get(this, "", "vif", vif))
      `uvm_fatal("DRIVER","Driver failed to getthis interface handle")
  endfunction: build_phase
  
  virtual function void write_predictor(fifo_sequence_item seq);
    if(vif.rst_n) begin
	if(seq.wr_en) 
      begin
      if(count < DEPTH) 
        begin
         `uvm_info("SCOREBOARD", $sformatf("Predictor Received Transaction: wr_en=%0b, data_in=0x%0h at time=%0t", seq.wr_en, seq.data_in, $time), UVM_DEBUG)
         ref_fifo.push_back(seq.data_in);
         count++;
         `uvm_info("SCOREBOARD", $sformatf("Stored Write in Reference Model: 0x%0h at time=%0t. FIFO Size=%0d count = %0d",seq.data_in, $time, ref_fifo.size(),count), UVM_MEDIUM)
        end
      else 
        begin
        `uvm_info("SCOREBOARD", $sformatf("Cannot write because FIFO is full. Read before writing"), UVM_MEDIUM)
        end
      end
    else  
      begin
      	`uvm_info("SCOREBOARD", $sformatf("Cannot write because WR_EN signal is low"), UVM_MEDIUM)
      end
    end
    else begin
      ref_fifo.delete();  // Clear reference FIFO on reset
      count = 0;
      ref_fifo.push_back(0);
      `uvm_info("SCOREBORAD","RESET ASSERTED: Reference FIFO cleared and initialized with zero", UVM_MEDIUM)
    end
  endfunction: write_predictor
  
  virtual function void write_evaluator(fifo_sequence_item seq);
//     if(vif.rst_n) begin
    if(seq.r_en) 
      begin
      if(count > 0 && !seq.empty) 
        begin
        	logic [DATA_WIDTH-1:0] expected = ref_fifo.pop_front();
        	`uvm_info("SCOREBOARD", $sformatf("Reference FIFO After Read: Size=%0d, Contents=%p", ref_fifo.size(), ref_fifo), UVM_MEDIUM)
        	count = count -1;
         if(expected != seq.data_out) 
           begin
      		`uvm_error("SCOREBOARD", $sformatf("MISMATCH expected = 0x%0h, received = 0x%0h at time = %0t,", expected, seq.data_out, $time))
           end 
         else 
           begin
             `uvm_info("SCOREBOARD", $sformatf("Correct read 0x%0h at time = %0t", seq.data_out, $time), UVM_MEDIUM)
           end
		end
      else if(count == 0) 
        begin
        	`uvm_warning("SCOREBOARD", $sformatf("FIFO UNDERFLOW! Read attempt with empty FIFO at time=%0t. Count=%0d", $time, count))
      	end
      else 
        begin
        	`uvm_info("SCOREBOARD", "Ignoring transaction as r_en is low", UVM_DEBUG)
      	end
    end 
//     end
//     else begin
//       `uvm_info("SCOREBORAD","RESET is enabled and system is reset", UVM_MEDIUM)
// //       logic [DATA_WIDTH-1:0] expected = 0;
//     end


  endfunction: write_evaluator


endclass: fifo_scoreboard

