`include "../Units/RVX_Info.v"

module Stage_EX (
    input wire clk,
    input wire rst,
    //
    input wire [4:0] memOp_in,
    input wire [5:0] wdOp_in,
    //

    input wire [7:0] exOp_in,
    input wire [(`BUS_W-1):0] rs1Data_in,
    input wire [(`BUS_W-1):0] rs2Data_in,
    input wire [(`BUS_W-1):0] imm_in,
    input wire [(`BUS_W-1):0] pc_in,

    //
    output reg [4:0] memOp_out,
    output reg [5:0] wdOp_out,
    output reg [(`BUS_W-1):0] rs2Data_out,
    //

    output reg [(`BUS_W-1):0] exResult_out,
    output wire jumpEn_out,
    output wire [(`BUS_W-1):0] jumpAddr_out
);
// EXDECODE
wire workEn;
wire cptSelect;
wire aluSrcASelect;
wire aluSrcBSelect;
wire [3:0] cptOp;
assign workEn = exOp_in[0];
assign cptSelect = exOp_in[1];
assign aluSrcASelect = exOp_in[2];
assign aluSrcBSelect = exOp_in[3];
assign cptOp = exOp_in[7:4];

// ALU
wire [(`BUS_W-1):0] aluSrcA;
wire [(`BUS_W-1):0] aluSrcB;
assign aluSrcA = aluSrcASelect ? pc_in : rs1Data_in;
assign aluSrcB = aluSrcBSelect ? imm_in : rs2Data_in;
wire [(`BUS_W-1):0] aluResult;
RV_ALU alu_mod(
    .aluOp(cptOp),
    .srcA(aluSrcA),
    .srcB(aluSrcB),
    .aluResult(aluResult)
);

// BRANCH
wire [2:0] branchOp;
assign branchOp = cptOp[2:0];
wire branchTaken;
RV_Branch branch_mod(
    .branchOp(branchOp),
    .srcA(rs1Data_in),
    .srcB(rs2Data_in),
    .branchTaken(branchTaken)
);

// RESULT
wire [(`BUS_W-1):0] pcPlus;
wire [(`BUS_W-1):0] pcAddImm;
wire [(`BUS_W-1):0] rs1AddImm;
assign pcPlus = pc_in + 4;
assign pcAddImm = pc_in + imm_in;
assign rs1AddImm = rs1Data_in + imm_in;

wire [(`BUS_W-1):0] exResult;
assign exResult = (workEn ? (cptSelect ? pcPlus : aluResult) : imm_in);

// ASYN
assign jumpEn_out = (workEn & (cptSelect & (branchTaken | cptOp[3])));
assign jumpAddr_out = cptOp[3] ? rs1AddImm : pcAddImm;

// SYN
always @(posedge clk or negedge rst) begin
    if(!rst)begin
        memOp_out <= 5'b00000;
        wdOp_out <= 6'b000000;
        rs2Data_out <= {(`BUS_W){1'b0}};
        exResult_out <= {(`BUS_W){1'b0}};
    end else begin
        memOp_out <= memOp_in;
        wdOp_out <= wdOp_in;
        rs2Data_out <= rs2Data_in;
        exResult_out <= exResult;
    end
end

endmodule