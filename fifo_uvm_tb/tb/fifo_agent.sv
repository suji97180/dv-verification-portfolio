class fifo_agent extends uvm_agent;
  `uvm_component_utils(fifo_agent)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  fifo_driver    drv;
  fifo_sequencer sqr;
  fifo_monitor   mon;
  
  virtual fifo_if vif;
  
  uvm_analysis_port #(fifo_sequence_item) mon_wr_ap;
  uvm_analysis_port #(fifo_sequence_item) mon_rd_ap;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    sqr = fifo_sequencer::type_id::create("sqr", this);
    drv = fifo_driver::type_id::create("drv", this);
    mon = fifo_monitor::type_id::create("mon", this);
    
    if(!uvm_config_db #(virtual fifo_if)::get(this, "", "vif", vif))
        `uvm_fatal("DRIVER","agent failed to get this interface handle")
    
    drv.vif = vif;
    mon.vif = vif;  
    
    mon_wr_ap = new("mon_wr_ap", this); //created analysis port
    mon_rd_ap = new("mon_rd_ap", this);
  endfunction: build_phase
  
  virtual function void connect_phase(uvm_phase phase);
    drv.seq_item_port.connect(sqr.seq_item_export); 
    mon.wr_port.connect(mon_wr_ap);
    mon.rd_port.connect(mon_rd_ap);
  endfunction: connect_phase
endclass