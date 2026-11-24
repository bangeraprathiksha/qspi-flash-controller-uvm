`define no_of_trans 5000

`define ADDR_WIDTH 32
`define DATA_WIDTH 32
bit [31:0] expected_data_queue[$];

typedef struct packed {
  bit is_indirect;//1-APB, 0-AHB
  bit [7:0]  opcode;
  bit [31:0] address;
  bit [2:0]  address_length;
  bit [7:0]  mode;
  bit [4:0]  dummy_cycles;
  bit [8:0]  data_length;
  bit [7:0]  line_width;
  bit [3:0]  enable;
} qspi_transaction_t;

qspi_transaction_t indirect_queue[$];
qspi_transaction_t xip_queue[$];
qspi_transaction_t current_transaction;

`define OPCODE_ADDR         32'h04
`define ADDRESS_LENGTH_ADDR 32'h0C
`define ADDRESS_ADDR        32'h10
`define MODE_ADDR           32'h30
`define DUMMY_ADDR          32'h38
`define DATA_LENGTH_ADDR    32'h3D
`define LINE_WIDTH_ADDR     32'h46
`define DATA_ADDR           32'h4E
`define START_ADDR          32'h6E
