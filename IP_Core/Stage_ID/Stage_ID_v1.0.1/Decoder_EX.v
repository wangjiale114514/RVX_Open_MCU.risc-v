`include "../../Units/RVX_Info.v"

`define DECODER_EX_VERSION 100

module Decoder_EX (
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    input wire [6:0] funct7,

    output wire [7:0] exOp
);

wire workEn;
wire cptSelect;
wire srcASelect;
wire srcBSelect;
wire [3:0] aluOp;

wire [3:0] aluOp_R;
wire [3:0] aluOp_I;
wire funct7Is0x00;
wire funct7Is0x20;
wire funct3Islla;// funct3 is sll ,srl ,sra
assign funct7Is0x00 = (funct7 == 7'b000_0000);
assign funct7Is0x20 = (funct7 == 7'b010_0000);
assign funct3Islla = ((funct3 == 3'b001) || (funct3 == 3'b101));
assign aluOp_R = funct7Is0x00 ? {1'b0, funct3} :
                 funct7Is0x20 ? {1'b1, funct3} :
                 4'b0000;
assign aluOp_I = funct3Islla ? aluOp_R : {1'b0, funct3};

assign workEn = !(opcode == `OP_B);
assign cptSelect = (opcode == `OP_U);
assign srcASelect = ((opcode == `OP_IJ) || (opcode == `OP_J) || (opcode == `OP_UA));
assign srcBSelect = !((opcode == `OP_R));
assign aluOp = (opcode == `OP_R) ? aluOp_R :
               (opcode == `OP_I) ? aluOp_I :
               ((opcode == `OP_IJ) || (opcode == `OP_J)) ? 4'b1111 :
               4'b0000;

assign exOp = {aluOp, srcBSelect, srcASelect, cptSelect, workEn};

endmodule