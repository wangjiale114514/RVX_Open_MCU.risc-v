`include "../../Units/RVX_Info.v"

module Decoder_MEM (
    input wire [6:0] opcode,
    input wire [2:0] funct3,

    output wire [4:0] memOp
);

wire workEn;
wire dmWR;
wire [2:0] cptOp;

wire opIsS;
assign opIsS = (opcode == `OP_S);

assign workEn = ((opcode == `OP_IL) || opIsS);
assign dmWR = opIsS;
assign cptOp = funct3;

assign memOp = {cptOp, dmWR, workEn};

endmodule