class fifo_monitor extends uvm_monitor;
  `uvm_component_utils(fifo_monitor)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual fifo_if vif; //defined a virtual interface to collect the DUT signals
  
  //We need two analysis ports here since we have 2 different outputs
  //read and write operations are independent
  uvm_analysis_port #(fifo_sequence_item) wr_port;
  uvm_analysis_port #(fifo_sequence_item) rd_port;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wr_port = new("wr_port", this);
    rd_port = new("rd_port", this);
    
    if(!uvm_config_db #(virtual fifo_if)::get(this, "", "vif", vif)) begin
       `uvm_fatal("MONITOR", "No virtual interface found")
    end else begin
      `uvm_info("MONITOR", "Virtual interface successfully retrieved!", UVM_MEDIUM)
    end
  endfunction: build_phase
  
  task run_phase(uvm_phase phase);
  	fifo_sequence_item seq_rd;
    fifo_sequence_item seq_wr;
    fork
      forever begin  //this part is for reading the values
        seq_rd = fifo_sequence_item::type_id::create("seq_rd");
        rd_data(seq_rd); 
       
      end
      forever begin  //this part is for writing the values
        seq_wr = fifo_sequence_item::type_id::create("seq_wr");
        wr_data(seq_wr);
        
      end
    join
  endtask: run_phase
  task rd_data(fifo_sequence_item seq_rd);
    @(posedge vif.clk)
//     if(vif.r_en && vif.rst_n) begin
    if(vif.r_en ) begin
//       @(posedge vif.clk);
      seq_rd.data_out = vif.data_out;
      seq_rd.r_en     = vif.r_en;
      seq_rd.full     = vif.full;   // Added
      seq_rd.empty    = vif.empty;
      `uvm_info("MONITOR_RD", $sformatf("Captured Read: data_out=%0h, r_en=%0b, full=%0b, empty=%0b, time = %0t", 
            seq_rd.data_out, seq_rd.r_en, seq_rd.full, seq_rd.empty, $time), UVM_MEDIUM)
       rd_port.write(seq_rd);
    end
  endtask: rd_data
    
  task wr_data(fifo_sequence_item seq_wr);
    @(posedge vif.clk)
//     if(vif.wr_en  && vif.rst_n) begin
    if(vif.wr_en) begin
      seq_wr.data_in = vif.data_in;
      seq_wr.wr_en   = vif.wr_en;
      seq_wr.full    = vif.full;   // Added
      seq_wr.empty   = vif.empty;  // Added
       
      `uvm_info("MONITOR_WR", $sformatf("Captured Write: data_in=%0h, wr_en=%0b, full=%0b, empty=%0b, time =%0t", 
            seq_wr.data_in, seq_wr.wr_en, seq_wr.full, seq_wr.empty, $time), UVM_MEDIUM)
        wr_port.write(seq_wr);
    end
  endtask: wr_data  
      
endclass: fifo_monitor