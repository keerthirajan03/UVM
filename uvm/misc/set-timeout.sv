// Author   : Admin (www.chipverify.com)
// Purpose  : To illustrate how to set timeout in UVM
//---------------------------------------------------------------


`timescale 1ns/1ns

`include "uvm_macros.svh"
import uvm_pkg::*;

// Let's create an environment which has an infinite loop that
// consumes time - simulation can then be stopped by setting 
// the timeout parameter
class my_env extends uvm_env ;

   `uvm_component_utils (my_env)

   function new (string name, uvm_component parent);
      super.new (name, parent);
   endfunction : new

   task run_phase (uvm_phase phase);
      phase.raise_objection (this);
      `uvm_info (get_name(), "Hello, I am going to hang...", UVM_MEDIUM)
      while (1) begin
         #10;
         `uvm_info (get_name(), "oops", UVM_MEDIUM)
      end
      phase.drop_objection (this);
   endtask : run_phase

endclass 


// A simple test to set timeout for this simulation
class base_test extends uvm_test;
   `uvm_component_utils (base_test)

   my_env   m_top_env;
   
   function new (string name, uvm_component parent = null);
      super.new (name, parent);
   endfunction : new
   
   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
      m_top_env  = my_env::type_id::create ("m_top_env", this);
   endfunction : build_phase

   virtual function void end_of_elaboration_phase (uvm_phase phase);
      super.end_of_elaboration_phase (phase);
      
`ifndef USE_GLOBAL_TIMEOUT
      uvm_top.set_timeout (100ns);
`endif

   endfunction 
endclass 

// You can also set timeout using this global function in the top
// level module
module top;

   initial begin
`ifdef USE_GLOBAL_TIMEOUT
      set_global_timeout (100);
`endif
      run_test ("base_test");
   end
endmodule


/* Simulation Log:
------------------

UVM_INFO @ 0: reporter [RNTST] Running test base_test...
UVM_INFO ./tb/my_pkg.sv(26) @ 0: uvm_test_top.m_top_env [m_top_env] Hello, I am going to hang...
UVM_INFO ./tb/my_pkg.sv(29) @ 10: uvm_test_top.m_top_env [m_top_env] oops
UVM_INFO ./tb/my_pkg.sv(29) @ 20: uvm_test_top.m_top_env [m_top_env] oops
UVM_INFO ./tb/my_pkg.sv(29) @ 30: uvm_test_top.m_top_env [m_top_env] oops
UVM_INFO ./tb/my_pkg.sv(29) @ 40: uvm_test_top.m_top_env [m_top_env] oops
UVM_INFO ./tb/my_pkg.sv(29) @ 50: uvm_test_top.m_top_env [m_top_env] oops
UVM_INFO ./tb/my_pkg.sv(29) @ 60: uvm_test_top.m_top_env [m_top_env] oops
UVM_INFO ./tb/my_pkg.sv(29) @ 70: uvm_test_top.m_top_env [m_top_env] oops
UVM_INFO ./tb/my_pkg.sv(29) @ 80: uvm_test_top.m_top_env [m_top_env] oops
UVM_INFO ./tb/my_pkg.sv(29) @ 90: uvm_test_top.m_top_env [m_top_env] oops
UVM_FATAL /uvm-home/src/base/uvm_phase.svh(1282) @ 100: reporter [PH_TIMEOUT] Explicit timeout of 100 hit, indicating a probable testbench issue

--- UVM Report catcher Summary ---


Number of demoted UVM_FATAL reports  :    0
Number of demoted UVM_ERROR reports  :    0
Number of demoted UVM_WARNING reports:    0
Number of caught UVM_FATAL reports   :    0
Number of caught UVM_ERROR reports   :    0
Number of caught UVM_WARNING reports :    0

--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :   11
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    1
** Report counts by id
[PH_TIMEOUT]     1
[RNTST]     1
[m_top_env]    10
Simulation complete via $finish(1) at time 100 NS + 0

*/
