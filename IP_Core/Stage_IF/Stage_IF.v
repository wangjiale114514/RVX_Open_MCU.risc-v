//可能要加转接头

module stage_if (
    input wire clk,
    input wire reset,

    input wire stop,              //暂停流水线

    input wire kill,              //清空流水线
    input wire [31:0] jump_pc,    //回溯地址

    input wire [31:0] inst,       //命令
    output reg [31:0] adderss,    //寻址

    input wire bp_in,             //bp输入(1跳转，0不跳转)
    output wire [31:0] bp_adderss,//传入bp地址

    output reg [64:0] to_id_inst //高一位分支预测结果，中32位命令adderss，低32位命令源码

);

    //id流水线进发--废除
    //assign to_id_inst[63:32] = adderss;
    //assign to_id_inst[31:0] = inst;
    //assign to_id_inst[64] = bp_in;

    //送往bp
    assign bp_adderss = adderss;

    always @(posedge clk) begin
        if (reset) begin          //reset
            adderss <= 32'b0;
        end
        else begin
            if (kill) begin        //清空流水线
                adderss <= jump_pc;
            end
            else begin              //if流程
                if (!stop) begin    //流水线暂停
                    if (bp_in == 1'b0) begin  //非跳转
                        case (inst[6:0])
                            7'b1101111: begin  //J-type
                                //无条件分支
                                adderss <= adderss + {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
                            end
                            default: begin
                                adderss <= adderss + 32'b100;  //pc+4
                            end
                        endcase
                    end
                    else begin                         //B-type
                        adderss <= adderss + {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
                    end

                    //id流水线进发
                    to_id_inst[63:32] <= adderss;
                    to_id_inst[31:0] <= inst;
                    to_id_inst[64] <= bp_in;
                end
            end
        end
    end
    
endmodule