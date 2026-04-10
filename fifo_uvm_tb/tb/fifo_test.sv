class fifo_base_test extends uvm_test;
  `uvm_component_utils(fifo_base_test)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  fifo_env env;
  fifo_sequence seq;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = fifo_env::type_id::create("env", this);
  endfunction: build_phase
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = fifo_sequence::type_id::create("seq");
    seq.start(env.agt.sqr);
    phase.drop_objection(this);
  endtask: run_phase
  
endclass: fifo_base_test