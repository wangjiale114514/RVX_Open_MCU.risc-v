`include "../Units/RVX_Info.v"

module Stage_MEM (
    input wire clk,
    input wire rst,

    input wire [4:0] memOp_in,
    input wire [5:0] wdOp_in,

    input wire [(`BUS_W-1):0] rs2Data_in,
    input wire [(`BUS_W-1):0] exResult_in,

    output reg [5:0] wdOp_out,
    output reg [(`BUS_W-1):0] memResult_out,

    input wire [(`BUS_W-1):0] dmRData_in,    //dm
    output reg [(`BUS_W-1):0] dmAddr_out,    //dm

    output reg dmWEn_out,                     //dm
    output reg dmREn_out,                     //dm
    output reg [3:0] dmDataW_out,            //dm
    output reg [(`BUS_W-1):0] dmWData_out    //dm
);

parameter LB = 3'b000;
parameter LH = 3'b001;
parameter LW = 3'b010;
parameter LBU = 3'b100;
parameter LHU = 3'b101;

parameter SB = 3'b000;
parameter SH = 3'b001;
parameter SW = 3'b010;

reg workEn;
reg dmWR;
reg [2:0] cptOp;

always @(*) begin
    workEn <= memOp_in[0];
    dmWR <= memOp_in[1];
    cptOp <= memOp_in[4:2];
end

reg [(`BUS_W-1):0] dmRData;
always @(*)begin
    if(workEn)begin
        dmAddr_out <= exResult_in;
        dmWEn_out <= dmWR;
        dmREn_out <= !dmWR;
        case(cptOp)
        SB : dmDataW_out <= 4'b0001;
        SH : dmDataW_out <= 4'b0011;
        SW : dmDataW_out <= 4'b1111;
        default : dmDataW_out <= 4'b0000;
        endcase
        if(dmWR)begin
            dmWData_out <= rs2Data_in;
        end else begin
            case(cptOp)
            LB : dmRData <= {{{`BUS_W-8}{dmRData_in[7]}}, dmRData_in[7:0]};
            LH : dmRData <= {{{`BUS_W-16}{dmRData_in[15]}}, dmRData_in[15:0]};
            LW : dmRData <= dmRData_in;
            LBU : dmRData <= {{{`BUS_W-8}{1'b0}}, dmRData_in[7:0]};
            LHU : dmRData <= {{{`BUS_W-16}{1'b0}}, dmRData_in[15:0]};
            default : dmRData <= {`BUS_W{1'b0}};
            endcase
        end
        end else begin
            dmAddr_out <= {`BUS_W{1'b0}};
            dmWEn_out <= 1'b0;
            dmREn_out <= 1'b0;
            dmDataW_out <= 4'b0000;
            dmWData_out <= {`BUS_W{1'b0}};
            dmRData <= {`BUS_W{1'b0}};
        end
end

always @(posedge clk or negedge rst) begin
    if(!rst)begin
        wdOp_out <= 6'b000000;
        memResult_out <= {`BUS_W{1'b0}};
    end else begin
        wdOp_out <= wdOp_in;
        if(workEn)begin
            memResult_out <= dmRData;
        end else begin
            memResult_out <= exResult_in;
        end
    end
end

endmodule