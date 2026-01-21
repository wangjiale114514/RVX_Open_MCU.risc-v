`include "../Units/RVX_Info.v"

module RV_ALU (
    input wire [3:0] aluOp,
    input wire [(`BUS_W-1):0] srcA,
    input wire [(`BUS_W-1):0] srcB,
    output reg [(`BUS_W-1):0] aluOut
);
// funct7 , funct3
parameter ADD = 4'b0000;
parameter SUB = 4'b1000;
parameter XOR = 4'b0100;
parameter OR  = 4'b0110;
parameter AND = 4'b0111;
parameter SLL = 4'b0001;
parameter SRL = 4'b0101;
parameter SRA = 4'b1101;
parameter SLT = 4'b0010;
parameter SLTU= 4'b0011;
parameter PCPLUS= 4'b1111;

always @(*) begin
    case (aluOp)
    ADD: aluOut = srcA + srcB;
    SUB: aluOut = srcA - srcB;
    XOR: aluOut = srcA ^ srcB;
    OR : aluOut = srcA | srcB;
    AND: aluOut = srcA & srcB;
    SLL: aluOut = srcA << srcB[4:0];
    SRL: aluOut = srcA >> srcB[4:0];
    SRA: aluOut = $signed(srcA) >>> srcB[4:0];
    SLT: aluOut = ($signed(srcA) < $signed(srcB));
    SLTU:aluOut = (srcA < srcB);
    PCPLUS: aluOut = srcA + 32'h0000_0004;
    default: aluOut = {`BUS_W{1'b0}};
    endcase
end

endmodule