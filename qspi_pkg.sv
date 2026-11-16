
package qspi_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  `include "defines.svh"

  // Register model
  `include "register.sv"
  `include "top_reg_block.sv"

  // Sequence items
  `include "apb_seq_item.sv"
  `include "ahb_seq_item.sv"
  `include "qspi_seq_item.sv"

  // Sequencers
  `include "apb_sequencer.sv"
  `include "ahb_sequencer.sv"
  `include "virtual_sequencer.sv"

  // Sequences
  `include "apb_sequence.sv"
  `include "ahb_sequence.sv"
  `include "virtual_sequence.sv"

  // Drivers
  `include "apb_driver.sv"
  `include "ahb_driver.sv"

  // Monitors
  `include "apb_monitor.sv"
  `include "ahb_monitor.sv"
  `include "qspi_monitor.sv"

  // Agents
  `include "apb_agent.sv"
  `include "ahb_agent.sv"
  `include "qspi_agent.sv"

  // RAL
  `include "adapter.sv"
  `include "predictor.sv"

  // Flash model
  `include "qspi_flash_model.sv"

  // Subscriber and scoreboard
  `include "subscriber.sv"
  `include "scoreboard.sv"

  // Environment and test
  `include "env.sv"
  `include "test.sv"

endpackage

