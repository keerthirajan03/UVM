//-----------------------------------------------------------------------------
// Author         :  Admin 
// E-Mail         :  contact@chipverify.com
// Description    :  Package of verification components
//-----------------------------------------------------------------------------

`include "uvm_macros.svh"
import uvm_pkg::*;

class virtual_sequencer extends uvm_sequencer;
   `uvm_component_utils (virtual_sequencer)
   function new (string name = "virtual_sequencer", uvm_component parent);
      super.new (name, parent);
   endfunction

   uvm_sequencer  m_apb_seqr;
   uvm_sequencer  m_wb_seqr;
   uvm_sequencer  m_spi_seqr;
endclass

class top_env extends uvm_env;
   `uvm_component_utils (top_env)
   function new (string name="top_env", uvm_component parent);
      super.new (name, parent);
   endfunction

   apb_agent   m_apb_agent;
   wb_agent    m_wb_agent;
   spi_agent   m_spi_agent;

   virtual_sequencer    m_virt_seqr;
   
   function void build_phase (uvm_phase phase);
      super.build_phase (phase);
      m_apb_agent = apb_agent::type_id::create ("m_apb_agent", this);
      m_wb_agent = wb_agent::type_id::create ("m_wb_agent", this);
      m_spi_agent = spi_agent::type_id::create ("m_spi_agent", this);

      m_virt_seqr = virtual_sequencer::type_id::create ("m_virt_seq", this);
   endfunction

   function void connect_phase (uvm_phase phase);
      super.connect_phase (phase);
      m_virt_seqr.m_apb_seqr = m_apb_agent.m_apb_seqr;
      m_virt_seqr.m_wb_seqr = m_wb_agent.m_wb_seqr;
      m_virt_seqr.m_spi_seqr = m_spi_agent.m_spi_seqr;   
   endfunction
endclass


class virt_seq extends uvm_sequence;
   `uvm_object_utils (virt_seq)
   `uvm_declare_p_sequencer (virtual_sequencer)

   apb_rw_seq     m_apb_rw_seq;
   wb_reset_seq   m_wb_reset_seq;
   spi_tx_seq     m_spi_tx_seq;

   function new (string name = "virt_seq");
      super.new (name);
   endfunction

   virtual task body ();
      m_apb_rw_seq = apb_rw_seq::type_id::create ("m_apb_rw_seq");
      m_wb_reset_seq = wb_reset_seq::type_id::create ("m_wb_reset_seq");
      m_spi_tx_seq = spi_tx_seq::type_id::create ("m_spi_tx_seq");

      `uvm_info ("VSEQ", "Start of virtual sequence", UVM_MEDIUM)
      fork
         m_wb_reset_seq.start (p_sequencer.m_wb_seqr);
         #20 m_apb_rw_seq.start (p_sequencer.m_apb_seqr);
      join
      #10;
      m_spi_tx_seq.start (p_sequencer.m_spi_seqr);
      `uvm_info ("VSEQ", "End of virtual sequence", UVM_MEDIUM)
   endtask
endclass

class base_test extends uvm_test;
   `uvm_component_utils (base_test)

   top_env     m_top_env;
   virt_seq    m_virt_seq;
   
   function new (string name, uvm_component parent = null);
      super.new (name, parent);
   endfunction : new
   
   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
      m_top_env  = top_env::type_id::create ("m_top_env", this);
      m_virt_seq = virt_seq::type_id::create ("m_virt_seq");
   endfunction 

   virtual function void end_of_elaboration_phase (uvm_phase phase);
      uvm_top.print_topology ();
   endfunction

   virtual task main_phase (uvm_phase phase);
      super.main_phase (phase);
      phase.raise_objection (this);
      m_virt_seq.start (m_top_env.m_virt_seqr);
      phase.drop_objection (this);
   endtask

   virtual task shutdown_phase (uvm_phase phase);
      super.shutdown_phase (phase);
      `uvm_info ("SHUT", "Shutting down test ...", UVM_MEDIUM)
   endtask
endclass 

