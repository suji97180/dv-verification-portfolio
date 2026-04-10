class fifo_driver extends uvm_driver #(fifo_sequence_item);
  `uvm_component_utils(fifo_driver)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual fifo_if vif;
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual fifo_if)::get(this, "", "vif", vif))
      `uvm_fatal("DRIVER","Driver failed to getthis interface handle")
  endfunction: build_phase
      
  task run_phase(uvm_phase phase);
    fifo_sequence_item seq;
    forever begin
//       wait (vif.rst_n);
//       `uvm_info("DRIVER", "Reset deasserted. Starting transactions.", UVM_MEDIUM)
      seq_item_port.get_next_item(seq);
// //       Ignore transactions if reset is asserted again
//       if (!vif.rst_n) begin
//         `uvm_info("DRIVER", "Reset asserted! Ignoring transaction.", UVM_MEDIUM)
//         wait (vif.rst_n);
//         `uvm_info("DRIVER", "Reset deasserted again. Resuming transactions.", UVM_MEDIUM)
//       end
      	drive(seq);
      seq_item_port.item_done();
    end
  endtask: run_phase
  
  virtual task drive(fifo_sequence_item seq);
    @(posedge vif.clk);
//     if(!vif.rst_n) begin
//       vif.data_in = 0;
//       vif.wr_en	  = 0;
//       vif.r_en	  = 0;
//       `uvm_info("DRIVER", "Reset is asserted, writing 0x0", UVM_MEDIUM);
//     end
//     else begin
    	vif.data_in = seq.data_in;
   	 	vif.wr_en	= seq.wr_en;
    	vif.r_en	= seq.r_en;
//       `uvm_info("DRIVER", $sformatf("Driving Write: wr_en=%0b, data_in=%0h at time=%0t",
//                                    vif.wr_en, vif.data_in, $time), UVM_MEDIUM);
//     end
//     @(posedge vif.clk);
//     vif.wr_en = 0;
//     vif.r_en = 0;
//     @(posedge vif.clk);
//     @(posedge vif.clk);
//     if i add more clock cycles, the data will stay same for more clock cycles, so u need to find a way to skip that many cycles. how?
    
  endtask: drive
    
  
endclass: fifo_driver