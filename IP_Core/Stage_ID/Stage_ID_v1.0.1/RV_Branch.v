`include "../../Units/RVX_Info.v"

module RV_Branch (
    input wire [2:0] branchOp,
    input wire [(`BUS_W-1):0] srcA,
    input wire [(`BUS_W-1):0] srcB,
    output reg branchTaken
);

parameter BEQ = 3'b000;
parameter BNE = 3'b001;
parameter BLT = 3'b100;
parameter BGE = 3'b101;
parameter BLTU= 3'b110;
parameter BGEU= 3'b111;

always @(*) begin
    case (branchOp)
        BEQ: branchTaken = (srcA == srcB);
        BNE: branchTaken = (srcA != srcB);
        BLT: branchTaken = ($signed(srcA) < $signed(srcB));
        BGE: branchTaken = ($signed(srcA) >= $signed(srcB));
        BLTU:branchTaken = (srcA < srcB);
        BGEU:branchTaken = (srcA >= srcB);
        default: branchTaken = 0;
    endcase
end

endmodule