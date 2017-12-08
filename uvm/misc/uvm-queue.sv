//-----------------------------------------------------------------------------
// Author   :  Admin    (www.chipverify.com)
// Purpose  :  Example of how to create and use some basic functions of UVM Q
//-----------------------------------------------------------------------------

`timescale 1ns/1ns

`include "uvm_macros.svh"
import uvm_pkg::*;

class my_data extends uvm_sequence_item;
   rand bit [31:0]   addr;
   rand bit [31:0]   data;

   `uvm_object_utils_begin (my_data)
      `uvm_field_int (addr, UVM_ALL_ON)
      `uvm_field_int (data, UVM_ALL_ON)
   `uvm_object_utils_end

   function new (string name="my_data");
      super.new (name);
   endfunction

endclass

class base_test extends uvm_test;

   `uvm_component_utils (base_test)

   uvm_queue #(my_data)    my_q;

   function new (string name, uvm_component parent = null);
      super.new (name, parent);
   endfunction : new

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
      my_q = new ("my_q");
   endfunction
   
   virtual task main_phase (uvm_phase phase);
      super.main_phase (phase);

      for (int i = 0; i < 5; i++) begin
         my_data tmp = my_data::type_id::create ("tmp");
         tmp.randomize ();
         tmp.print();
         my_q.push_back (tmp);
      end
      
      for (int i = 0; i < my_q.size(); i++) begin
         my_data obj = my_q.get(i);
         `uvm_info ("QUEUE", $sformatf ("Element[%0d] addr=0x%0h data=0x%0h", i, obj.addr, obj.data), UVM_MEDIUM)
      end
         
   endtask
endclass 


module top;
   import uvm_pkg::*;
   
   initial 
      run_test ("base_test");
endmodule


/* Simulation Log
-----------------

UVM_INFO @ 0: reporter [RNTST] Running test base_test...
----------------------------------
Name    Type      Size  Value
----------------------------------
tmp     my_data   -     @2656
  addr  integral  32    'h4e3698e8
  data  integral  32    'h57f6ba30
----------------------------------
----------------------------------
Name    Type      Size  Value
----------------------------------
tmp     my_data   -     @2689
  addr  integral  32    'h2035c229
  data  integral  32    'h43957b3d
----------------------------------
----------------------------------
Name    Type      Size  Value
----------------------------------
tmp     my_data   -     @2697
  addr  integral  32    'hc1c69371
  data  integral  32    'hf5ec14fe
----------------------------------
----------------------------------
Name    Type      Size  Value
----------------------------------
tmp     my_data   -     @2706
  addr  integral  32    'heb9def5a
  data  integral  32    'h1a3f24cb
----------------------------------
----------------------------------
Name    Type      Size  Value
----------------------------------
tmp     my_data   -     @2715
  addr  integral  32    'hdb42363a
  data  integral  32    'h2111b453
----------------------------------
UVM_INFO ./tb/tb_top.sv(54) @ 0: uvm_test_top [QUEUE] Element[0] addr=0x4e3698e8 data=0x57f6ba30
UVM_INFO ./tb/tb_top.sv(54) @ 0: uvm_test_top [QUEUE] Element[1] addr=0x2035c229 data=0x43957b3d
UVM_INFO ./tb/tb_top.sv(54) @ 0: uvm_test_top [QUEUE] Element[2] addr=0xc1c69371 data=0xf5ec14fe
UVM_INFO ./tb/tb_top.sv(54) @ 0: uvm_test_top [QUEUE] Element[3] addr=0xeb9def5a data=0x1a3f24cb
UVM_INFO ./tb/tb_top.sv(54) @ 0: uvm_test_top [QUEUE] Element[4] addr=0xdb42363a data=0x2111b453

--- UVM Report catcher Summary ---


Number of demoted UVM_FATAL reports  :    0
Number of demoted UVM_ERROR reports  :    0
Number of demoted UVM_WARNING reports:    0
Number of caught UVM_FATAL reports   :    0
Number of caught UVM_ERROR reports   :    0
Number of caught UVM_WARNING reports :    0

--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :    6
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[QUEUE]     5
[RNTST]     1
Simulation complete via $finish(1) at time 0 FS + 179                  

*/
