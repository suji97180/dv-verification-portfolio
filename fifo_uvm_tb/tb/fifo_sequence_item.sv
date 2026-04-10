class fifo_sequence_item extends uvm_sequence_item;
//   `uvm_object_utils(fifo_sequence_item)
  
  function new(string name = "fifo_sequence_item");
    super.new(name);
  endfunction
  
  //Lets define the variables.
  //We are defining both inputs and outputs here
  //inputs
  rand logic [DATA_WIDTH-1:0] data_in;
  rand logic wr_en;
  rand logic r_en;
  //Outputs
  logic [DATA_WIDTH-1:0] data_out;
  logic full;
  logic empty;
  //constraints are currently for wr_en and r_en
  constraint value { 
    wr_en dist {0 := 50, 1:= 50};
    r_en  dist {1 := 50, 0:= 50};}
 
  //this is very important part for sequence_item
  `uvm_object_utils_begin(fifo_sequence_item)
  	`uvm_field_int(data_in,UVM_DEFAULT)
  	`uvm_field_int(wr_en,UVM_DEFAULT)
 	`uvm_field_int(r_en,UVM_DEFAULT)
  	`uvm_field_int(data_out,UVM_DEFAULT)
  	`uvm_field_int(full,UVM_DEFAULT)
  	`uvm_field_int(empty,UVM_DEFAULT)
   `uvm_object_utils_end
  
  virtual function string convert2string();
    return $sformatf("fifo_sequence_item: data_in=%0h, wr_en=%0b, r_en=%0b, data_out=%h, full=%0b, empty=%0b", data_in, wr_en, r_en, data_out, full, empty);
   endfunction
  
endclass: fifo_sequence_item