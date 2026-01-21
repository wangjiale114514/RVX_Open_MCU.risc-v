`include "../../Units/RVX_Info.v"

module Splicer_Imm (
    input wire [(`RVINST_W-1):0] inst_in,
    output reg [(`BUS_W-1):0] imm_out
);
reg [6:0] opcode;
reg [(`BUS_W-1):0] imm_i;
reg [(`BUS_W-1):0] imm_s;
reg [(`BUS_W-1):0] imm_b;
reg [(`BUS_W-1):0] imm_u;
reg [(`BUS_W-1):0] imm_j;

always @(*) begin
    opcode <= inst_in[6:0];
    imm_i <= {{20{inst_in[31]}}, inst_in[31:20]};
    imm_s <= {{20{inst_in[31]}}, inst_in[31:25], inst_in[11:7]};
    imm_b <= {{19{inst_in[31]}}, inst_in[7], inst_in[30:25], inst_in[11:8], 1'b0};
    imm_u <= {inst_in[31:12], 12'b0};
    imm_j <= {{11{inst_in[31]}}, inst_in[31], inst_in[19:12], inst_in[20], inst_in[30:21], 1'b0};
end

always @(*) begin
    case(opcode)
    `OP_I, `OP_IL, `OP_IJ, `OP_IE : imm_out <= imm_i;
    `OP_S : imm_out <= imm_s;
    `OP_B : imm_out <= imm_b;
    `OP_U, `OP_UA : imm_out <= imm_u;
    `OP_J : imm_out <= imm_j;
    default : imm_out <= {`BUS_W{1'b0}};
    endcase
end

endmodule