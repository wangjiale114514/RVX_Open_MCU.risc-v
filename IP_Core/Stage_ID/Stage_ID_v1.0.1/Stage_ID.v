`include "../../Units/RVX_Info.v"

module Stage_ID (
    input wire clk,
    input wire rst,
    input wire flush,

    input wire [(`RVINST_W-1):0] inst_in,
    input wire [(`BUS_W-1):0] pc_in,

    output reg [4:0] rfAAddr_out,
    output reg [4:0] rfBAddr_out,
    input wire [(`BUS_W-1):0] rfAData_in,
    input wire [(`BUS_W-1):0] rfBData_in,

    output reg [5:0] jumpOp_out,
    output reg [(`BUS_W-1):0] jump_imm_out,

    output reg [(`RVINST_W-1):0] inst_out,
    output reg [(`BUS_W-1):0] rs1Data_out,
    output reg [(`BUS_W-1):0] rs2Data_out,
    output reg [(`BUS_W-1):0] pc_out,
    output reg [(`BUS_W-1):0] imm_out,
    output reg [7:0] exOp_out,
    output reg [4:0] memOp_out,
    output reg [5:0] wdOp_out
);

reg [6:0] opcode;
reg [2:0] funct3;
reg [6:0] funct7;
reg [4:0] rd;

always @(*) begin
    opcode <= inst_in[6:0];
    funct3 <= inst_in[14:12];
    funct7 <= inst_in[31:25];
    rd <= inst_in[11:7];
    rfAAddr_out <= inst_in[19:15];
    rfBAddr_out <= inst_in[24:20];
end

wire [5:0] jumpOp;
wire [7:0] exOp;
wire [4:0] memOp;
wire [5:0] wdOp;
wire [(`BUS_W-1):0] imm;

Decoder_Jump deJump_mod(
    .opcode(opcode),
    .funct3(funct3),
    .jumpOp(jumpOp)
);

Decoder_EX deEX_mod(
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .exOp(exOp)
);

Decoder_MEM deMEM_mod(
    .opcode(opcode),
    .funct3(funct3),
    .memOp(memOp)
);

Decoder_WD deWD_mod(
    .opcode(opcode),
    .rd(rd),
    .wdOp(wdOp)
);

Splicer_Imm si_mod(
    .inst_in(inst_in),
    .imm_out(imm)
);

always @(*)begin
    jumpOp_out <= jumpOp;
    jump_imm_out <= imm;
end

always @(posedge clk or negedge rst)begin
    if(!rst || flush)begin
        inst_out <= {`BUS_W{1'b0}};
        rs1Data_out <= {`BUS_W{1'b0}};
        rs2Data_out <= {`BUS_W{1'b0}};
        pc_out <= {`BUS_W{1'b0}};
        imm_out <= {`BUS_W{1'b0}};
        exOp_out <= 8'b00000000;
        memOp_out <= 5'b00000;
        wdOp_out <= 6'b000000;
    end else begin
        inst_out <= inst_in;
        rs1Data_out <= rfAData_in;
        rs2Data_out <= rfBData_in;
        pc_out <= pc_in;
        imm_out <= imm;
        exOp_out <= exOp;
        memOp_out <= memOp;
        wdOp_out <= wdOp;
    end
end

endmodule
