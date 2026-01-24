`include "../Units/RVX_Info.v"

module Stage_WD (
    input wire [5:0] wdOp_in,
    input wire [(`BUS_W-1):0] memResult_in,

    output reg rfWEn_out,
    output reg [4:0] rfWAddr_out,
    output reg [(`BUS_W-1):0] rfWData_out
);

always @(*) begin
    rfWData_out = memResult_in;
    rfWAddr_out = wdOp_in[5:1];
    rfWEn_out = wdOp_in[0];
end

endmodule