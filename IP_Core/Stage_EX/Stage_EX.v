`include "../Units/RVX_Info.v"

module Stage_EX (
    input wire clk,
    input wire rst,

    input wire [(`BUS_W-1):0] rs1Data_in,
    input wire [(`BUS_W-1):0] rs2Data_in,
    input wire [(`BUS_W-1):0] imm_in,
    input wire [(`BUS_W-1):0] pc_in,

    input wire [7:0] exOp_in,
    input wire [4:0] memOp_in,
    input wire [5:0] wdOp_in,

    output reg [(`BUS_W-1):0] rs2Data_out,
    output reg [(`BUS_W-1):0] exResult_out,
    output reg [4:0] memOp_out,
    output reg [5:0] wdOp_out
);

wire workEn;
wire cptSelect;
wire srcASelect;
wire srcBSelect;
wire [3:0] aluOp;
assign workEn = exOp_in[0];
assign cptSelect = exOp_in[1];
assign srcASelect = exOp_in[2];
assign srcBSelect = exOp_in[3];
assign aluOp = exOp_in[7:4];

wire [(`BUS_W-1):0] srcA;
wire [(`BUS_W-1):0] srcB;
assign srcA = srcASelect ? pc_in : rs1Data_in;
assign srcB = srcBSelect ? imm_in : rs2Data_in;

wire [(`BUS_W-1):0] aluResult;
RV_ALU alu_mod(
    .aluOp(aluOp),
    .srcA(srcA),
    .srcB(srcB),
    .aluOut(aluResult)
);

wire [(`BUS_W-1):0] exResult;
assign exResult = workEn ? (cptSelect ? imm_in : aluResult) : {(`BUS_W){1'b0}};

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        rs2Data_out <= {(`BUS_W){1'b0}};
        exResult_out <= {(`BUS_W){1'b0}};
        memOp_out <= 5'b00000;
        wdOp_out <= 6'b000000;
    end else begin
        rs2Data_out <= rs2Data_in;
        exResult_out <= exResult;
        memOp_out <= memOp_in;
        wdOp_out <= wdOp_in;
    end
end

endmodule