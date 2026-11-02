# QSPI Flash Controller – UVM Verification

## Overview
This project focuses on verifying a QSPI Flash Controller using SystemVerilog and UVM.

The controller supports APB-based indirect register access and AHB-Lite based execute-in-place (XIP) read operations.

## Testbench Architecture
- APB Agent – Register read/write operations using UVM RAL.
- AHB Agent – XIP read transaction verification.
- QSPI Agent – Passive monitor for QSPI signal observation.
- Flash Model – External flash memory model.
- RAL Model – Register access and mirror prediction.
- Scoreboard – Expected and actual data comparison.

## Protocols
- APB4
- AHB-Lite
- QSPI

## Tools
- SystemVerilog
- UVM
- QuestaSim / VCS

## Verification Features
- APB register access testing.
- QSPI command and data phase monitoring.
- Single, dual and quad SPI operations.
- AHB-Lite XIP read verification.
- Functional coverage and assertions.

## Project Status
Under development.

qspi-flash-controller-uvm/
│
├── rtl/
├── tb/
│   ├── agents/
│   │   ├── apb_agent/
│   │   ├── ahb_agent/
│   │   └── qspi_agent/
│   │
│   ├── env/
│   ├── sequences/
│   ├── ral/
│   ├── flash_model/
│   ├── scoreboard/
│   └── tests/
│
├── sim/
├── docs/
└── README.md
