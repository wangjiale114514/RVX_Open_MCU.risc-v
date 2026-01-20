`ifndef _RVX_INFO_V__
`define _RVX_INFO_V_

`define BUS_W 32

`define RVINST_W 32

//RV32I
`define OP_R 7'b0110011 // R-type
`define OP_I 7'b0010011 // I-type
`define OP_IL 7'b0000011 // Load
`define OP_IJ 7'b1100111 // JALR
`define OP_IE 7'b1110011 // System
`define OP_S 7'b0100011 // S-type
`define OP_B 7'b1100011 // B-type
`define OP_U 7'b0110111 // U-type
`define OP_UA 7'b0010111 // UJ-type
`define OP_J 7'b1101111 // J-type

`define NOP 32'h0000_0013 // nop

`endif // _RVX_INFO_V_