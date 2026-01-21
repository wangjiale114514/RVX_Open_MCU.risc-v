//id阶段
//分割重组操作码，立即数，源寄存器，目标寄存器
module stage_id (
    input wire clk,
    input wire reset,
    
    input wire [64:0] inst,

    input wire kill,    //流水线清空
    input wire stop,    //流水线暂停

    output reg [31:0] inst_adderss,    //pc值
    output reg [15:0] inst_op,//inst出口（低op，中funct3，高funct7）
    output reg [4:0] inst_rs,
    output reg [4:0] inst_rt,
    output reg [4:0] inst_rd,
    output reg [31:0] inst_imm,
    output reg inst_bp,       //分支预测结果

    output reg err            //错误触发
);

    always @(posedge clk) begin
        if (reset) begin     //复位
            inst_op <= 16'b0;
            inst_rs <= 5'b0;
            inst_rt <= 5'b0;
            inst_rd <= 5'b0;
            inst_imm <= 32'b0;
            inst_bp <= 1'b0;
        end
        else begin
            if (kill) begin    //清空流水线
                inst_op <= 16'b0;
                inst_rs <= 5'b0;
                inst_rt <= 5'b0;
                inst_rd <= 5'b0;
                inst_imm <= 32'b0;
                inst_bp <= 1'b0;
            end
            else begin
                if (!stop) begin
                    case (inst[6:0])
                        7'b0110011: begin    //R-type
                            inst_adderss <= inst[63:32];  //adderss
                            inst_op[6:0] <= inst[6:0];    //op
                            inst_op[9:7] <= inst[14:12];  //funct3
                            inst_op[15:10] <= inst[31:25];//funct7
                            inst_rs <= inst[19:15];       //rs1
                            inst_rt <= inst[24:20];       //rs2
                            inst_rd <= inst[11:7];        //rd
                            inst_imm <= 32'b0;            //imm
                            inst_bp <= inst[64];          //bp
                            err <= 1'b0;                  //err
                        end

                        7'b0010011 , 7'b0000011 , 7'b1100111 , 7'b1110011: begin    //I-type
                            inst_adderss <= inst[63:32];  //adderss
                            inst_op[6:0] <= inst[6:0];    //op
                            inst_op[9:7] <= inst[14:12];  //funct3
                            inst_op[15:10] <= 6'b0;       //funct7
                            inst_rs <= inst[19:15];       //rs1
                            inst_rt <= 5'b0;              //rs2
                            inst_rd <= inst[11:7];        //rd
                            inst_imm <= {{20{inst[31]}},inst[31:20]};//imm
                            inst_bp <= inst[64];          //bp
                            err <= 1'b0;                  //err
                        end

                        7'b0100011: begin    //S-type
                            inst_adderss <= inst[63:32];  //adderss
                            inst_op[6:0] <= inst[6:0];    //op
                            inst_op[9:7] <= inst[14:12];  //funct3
                            inst_op[15:10] <= 6'b0;       //funct7
                            inst_rs <= inst[19:15];       //rs1
                            inst_rt <= inst[24:20];       //rs2
                            inst_rd <= 5'b0;              //rd
                            inst_imm <= {{20{inst[31]}},inst[31:25] ,inst[11:7]};//imm
                            inst_bp <= inst[64];          //bp
                            err <= 1'b0;                  //err
                        end

                        7'b1100011: begin    //B-type
                            inst_adderss <= inst[63:32];  //adderss
                            inst_op[6:0] <= inst[6:0];    //op
                            inst_op[9:7] <= inst[14:12];  //funct3
                            inst_op[15:10] <= 6'b0;       //funct7
                            inst_rs <= inst[19:15];       //rs1
                            inst_rt <= inst[24:20];       //rs2
                            inst_rd <= 5'b0;              //rd
                            inst_imm <= {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0}; //imm
                            inst_bp <= inst[64];          //bp
                            err <= 1'b0;                  //err
                        end

                        7'b0110111 , 7'b0010111: begin    //U-type
                            inst_adderss <= inst[63:32];  //adderss
                            inst_op[6:0] <= inst[6:0];    //op
                            inst_op[9:7] <= 3'b0;         //funct3
                            inst_op[15:10] <= 6'b0;       //funct7
                            inst_rs <= 5'b0;              //rs1
                            inst_rt <= 5'b0;              //rs2
                            inst_rd <= inst[11:7];        //rd
                            inst_imm <= {inst[31:12], 12'b0};//imm
                            inst_bp <= inst[64];          //bp
                            err <= 1'b0;                  //err
                        end

                        7'b1101111: begin                //J-type
                            inst_adderss <= inst[63:32];  //adderss
                            inst_op[6:0] <= inst[6:0];    //op
                            inst_op[9:7] <= 3'b0;         //funct3
                            inst_op[15:10] <= 6'b0;       //funct7
                            inst_rs <= 5'b0;              //rs1
                            inst_rt <= 5'b0;              //rs2
                            inst_rd <= inst[11:7];        //rd
                            inst_imm <= {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};  //imm
                            inst_bp <= inst[64];          //bp
                            err <= 1'b0;                  //err
                        end

                        default: begin    //err处理
                            inst_adderss <= 32'b0;
                            inst_op <= 16'b0;
                            inst_rs <= 5'b0;
                            inst_rt <= 5'b0;
                            inst_rd <= 5'b0;
                            inst_imm <= 32'b0;
                            inst_bp <= 1'b0;
                            err <= 1'b1;
                        end
                    endcase
                end
            end
        end
    end

endmodule