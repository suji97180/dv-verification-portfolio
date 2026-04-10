class fifo_env extends uvm_env;
  `uvm_component_utils(fifo_env)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  fifo_agent 	  agt;
  fifo_scoreboard scb;
//   virtual mac_if vif;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = fifo_agent::type_id::create("agt", this);
    scb = fifo_scoreboard::type_id::create("scb", this);
//     if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
//       `uvm_fatal("ENV","Environment failed to get this interface handle")
//     agt.vif = vif;
  endfunction: build_phase
  
  function void connect_phase(uvm_phase phase);
    agt.mon_wr_ap.connect(scb.pred_ap);
    agt.mon_rd_ap.connect(scb.eval_ap);
  endfunction: connect_phase
  
endclass: fifo_env