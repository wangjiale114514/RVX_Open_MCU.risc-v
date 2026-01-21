`include "../../Units/RVX_Info.v"

module Decoder_Jump (
    input wire [6:0] opcode,
    input wire [2:0] funct3,

    output wire [5:0] jumpOp
);

wire opIsB;
wire opIsJ;
wire opIsIJ;
assign opIsB = (opcode == `OP_B);
assign opIsJ = (opcode == `OP_J);
assign opIsIJ = (opcode == `OP_IJ);

assign jumpOp = {funct3, opIsIJ, opIsJ, opIsB};

endmodule