`include "../../Units/RVX_Info.v"

module Decoder_WD (
    input wire [6:0] opcode,
    input wire [4:0] rd,

    output wire [5:0] wdOp
);

wire workEn;
assign workEn = ((opcode != `OP_S) && (opcode != `OP_B));

assign wdOp = {rd, workEn};

endmodule