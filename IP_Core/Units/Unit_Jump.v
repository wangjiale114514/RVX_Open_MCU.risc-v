`include "RVX_Info.v"

module Unit_Jump (
    input wire [5:0] jumpOp_in,
    input wire [(`BUS_W-1):0] srcA_in,
    input wire [(`BUS_W-1):0] srcB_in,
    input wire [(`BUS_W-1):0] imm_in,
    input wire [(`BUS_W-1):0] pc_in,

    output wire jumpEn_out,
    output wire [(`BUS_W-1):0] jumpAddr_out
);

wire opIsB;
wire opIsJ;
wire opIsIJ;
assign opIsB = jumpOp_in[0];
assign opIsJ = jumpOp_in[1];
assign opIsIJ = jumpOp_in[2];

wire [(`BUS_W-1):0] pc_inAddImm_in;
wire [(`BUS_W-1):0] rs1AddImm_in;
assign pc_inAddImm_in = pc_in + imm_in;
assign rs1AddImm_in = srcA_in + imm_in;

wire branchTaken;
RV_Branch branch_mod(
    .branchOp(jumpOp_in[4:2]),
    .srcA(srcA_in),
    .srcB(srcB_in),
    .branchTaken(branchTaken)
);

assign jumpEn_out = (opIsB & branchTaken) | opIsJ | opIsIJ;
assign jumpAddr_out = opIsIJ ? rs1AddImm_in : pc_inAddImm_in;

endmodule