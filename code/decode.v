`include "Control.v"
`include "immGen.v"
`include "RegFile.v"

module decode(clk,rst, instrD, PCD, PCplus4D, RegWriteW, rdW, resultW, strCtrlE, RegWriteE, 
MemWriteE, MemtoRegE, PCBranchE, ALUopE, SrcASelE, SrcBSelE, immE, PCE, r1E, r2E, rdE);

//data path
input clk,rst,RegWriteW;
input [4:0] rdW;
input [31:0] instrD,PCD,PCplus4D,resultW;

//control
output strCtrlE,RegWriteE,MemWriteE,PCBranchE,SrcASelE,SrcBSelE; 
output [1:0] MemtoRegE;
output [2:0] ALUopE;

//data path
output [31:0] immE,PCE,r1E,r2E;
output [4:0] rdE;

//internal wire control
wire immSelD;
wire strCtrlD,RegWriteD,MemWriteD,PCBranchD,SrcASelD,SrcBSelD,MemtoRegD;
wire [2:0] ALUopD;

//internal wire data path
wire [31:0] immD,r1D,r2D;
// wire [4:0] rdD;
// assign rdD=instrD[11:7];

//pipeline registers
reg reg_strCtrlD,reg_RegWriteD,reg_MemWriteD,reg_MemtoRegD,reg_PCBranchD,reg_SrcASelD,reg_SrcBSelD;
reg [2:0] reg_ALUopD;
reg [31:0] reg_r1D,reg_r2D,reg_immD,reg_PCD;
reg [4:0] reg_rdD;


RegFile regs(
    .clk(clk),
    .rst(rst),
    .rs1(instrD[24:20]),
    .rs2(instrD[19:15]),
    .rd(rdW),
    .we(RegWriteW),
    .wd(resultW),
    .r1(r1D),
    .r2(r2D)
);

immGen immG(
    .instrD(instrD),
    .immSelD(immSelD),
    .immD(immD)
);

Control control(
    .opcode(InstrD[6:0]),
    .funct3(InstrD[14:12]),
    .funct7(InstrD[31:25]),
    .strCtrlD(immSelD),
    .RegWriteD(RegWriteD),
    .MemWriteD(MemWriteD),
    .PCBranchD(PCBranchD),
    .SrcASelD(SrcASelD),
    .SrcBSelD(SrcBSelD),
    .MemtoRegD(MemtoRegD),
    .ALUopD(ALUopD),
    .immSelD(immSelD)
);

//pipeline registers
    always @(posedge clk or negedge rst) begin
        if(rst) begin
            reg_RegWriteD <= 1'b0;
            reg_SrcASelD <= 1'b0;
            reg_SrcBSelD <= 1'b0;
            reg_MemWriteD <= 1'b0;
            reg_MemtoRegD <= 1'b0;
            reg_PCBranchD <= 1'b0;
            reg_ALUopD <= 3'b000;
            reg_strCtrlD <= 1'b0;
            reg_r1D <= 32'h00000000; 
            reg_r2D <= 32'h00000000; 
            reg_immD <= 32'h00000000;
            reg_rdD <= 5'h00;
            reg_PCD <= 32'h00000000; 

        end
        else begin
            reg_RegWriteD <= RegWriteD;
            reg_SrcASelD <= SrcASelD;
            reg_SrcBSelD <= SrcBSelD;
            reg_MemWriteD <= MemWriteD;
            reg_MemtoRegD <= MemtoRegD;
            reg_PCBranchD <= PCBranchD;
            reg_ALUopD <= ALUopD;
            reg_strCtrlD <= strCtrlD;
            reg_r1D <= r1D; 
            reg_r2D <= r2D; 
            reg_immD <= immD;
            reg_rdD <= instr[11:7];
            reg_PCD <= PCD;
        end
    end


assign strCtrlE = reg_strCtrlD;
assign RegWriteE = reg_RegWriteD;
assign MemWriteE = reg_MemWriteD;
assign PCBranchE = reg_PCBranchD;
assign SrcASelE = reg_SrcASelD;
assign SrcBSelE = reg_SrcBSelD;
assign MemtoRegE = reg_MemtoRegD;
assign ALUopE = reg_ALUopD;
assign immE = reg_immD;
assign PCE = reg_PCD;
assign r1E = reg_r1D;
assign r2E = reg_r2D;
assign rdE = reg_rdD;

endmodule