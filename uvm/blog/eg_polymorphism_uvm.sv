// Author   : Admin (www.chipverify.com)
// Purpose  : To resolve the error
//-------------------------------------------------------

`include "uvm_macros.svh"
import uvm_pkg::*;

//--------------------------------------------------------------------
//                         Original Testbench
//--------------------------------------------------------------------

class base_env extends uvm_env;
   `uvm_component_utils (base_env)
   function new (string name = "base_env", uvm_component parent=null);
      super.new(name, parent);
   endfunction
endclass

// This test only instantiates the environment
class base_test extends uvm_test;
   `uvm_component_utils (base_test)
   function new (string name = "base_test", uvm_component parent=null);
      super.new (name, parent);
   endfunction

   base_env    m_base_env;

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
      m_base_env = base_env::type_id::create ("m_base_env", this); 
   endfunction
endclass

//-----------------------------------------------------------------
//                     New Testbench
//-----------------------------------------------------------------

// New component developed with display() function
class comp extends uvm_component;
   `uvm_component_utils (comp)
   function new (string name = "comp", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   function display ();
      `uvm_info ("COMP", "Hello there !", UVM_MEDIUM)
   endfunction
endclass


// The component defined above will be used in this environment which
// is a derivative of the older environment
class derived_env extends base_env;
   `uvm_component_utils (derived_env)
   function new (string name = "derived_env", uvm_component parent=null);
      super.new (name, parent);
   endfunction
   
   comp m_comp;

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
      m_comp = comp::type_id::create ("m_comp", this);
   endfunction
   
endclass


// The new derivative env is used in the new test and a hierarchical reference
// is made to the new component used in the new env. We'll be overriding the 
// older environment with the new one
class derived_test extends base_test;
   `uvm_component_utils (derived_test)
   function new (string name = "derived_test", uvm_component parent=null);
      super.new (name, parent);
   endfunction

`ifdef NOCMPERR
   derived_env    m_derived_env;
`endif

   virtual function void build_phase (uvm_phase phase);
      set_type_override_by_type (base_env::get_type(), derived_env::get_type());
      super.build_phase (phase);
   endfunction

   virtual function void end_of_elaboration_phase (uvm_phase phase);
      super.end_of_elaboration_phase (phase);
      uvm_top.print_topology();
   endfunction

   virtual task run_phase (uvm_phase phase);
`ifdef NOCMPERR
      $cast (m_derived_env, m_base_env);
      m_derived_env.m_comp.display();
`else
      m_base_env.m_comp.display (); 
`endif
   endtask
   
endclass


module top;
   import uvm_pkg::*;
   
   initial 
      run_test ("base_test");
endmodule



/* Simulation Log:  +define+NOCMPERR  +UVM_TESTNAME=derived_test
----------------------------------------------
UVM_INFO @ 0: reporter [RNTST] Running test derived_test...
UVM_INFO /playground_lib/uvm-1.2/src/base/uvm_root.svh(579) @ 0: reporter [UVMTOP] UVM testbench topology:
---------------------------------------
Name          Type          Size  Value
---------------------------------------
uvm_test_top  derived_test  -     @1841
  m_base_env  derived_env   -     @1913
    m_comp    comp          -     @1945
---------------------------------------

UVM_INFO testbench.sv(42) @ 0: uvm_test_top.m_base_env.m_comp [COMP] Hello there !
UVM_INFO /playground_lib/uvm-1.2/src/base/uvm_report_server.svh(847) @ 0: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :    4
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[COMP]     1
[RNTST]     1
[UVM/RELNOTES]     1
[UVMTOP]     1

Simulation complete via $finish(1) at time 0 FS + 231





Simulation Log   :  +UVM_TESTNAME=derived_test 
---------------------------------------------------------------
m_base_env.m_comp.display (); 
                      |
ncvlog: *E,NOTCLM (testbench.sv,93|22): m_comp is not a class item.
irun: *E,VLGERR: An error occurred during parsing.  Review the log file for errors with the code *E and fix those identified problems to proceed.  Exiting with code (status 1).


*/
