`include "PC_module.v"
module fetch(clk,rst,flush, PCsrcE,PCplusImmE,PCD, instrD, PCF, instrF);
input clk, rst, flush;
input PCsrcE;
input [31:0] PCplusImmE, instrF;
output [31:0] instrD, PCD, PCF;

wire [31:0]  PCplus4F,instrF, nextPCF, four;
reg [31:0] reg_instrF, reg_PCF;

PC_Module pc(
    .clk(clk),
    .rst(rst),
    .PC(PCF),
    .nextPC(nextPCF)
    );

assign nextPCF = (PCsrcE)? PCplusImmE:PCplus4F;
assign four = 32'd4;
assign PCplus4F = PCF + four;

//pipeline registers
always @ (posedge clk or posedge rst) begin //rst used to implement stall
    if(rst | flush) begin
        reg_instrF <= 32'b0;
        reg_PCF <= 32'b0;
    end
    else begin
        reg_instrF <= instrF;
        reg_PCF <= PCF;
    end
end

//signals to Decoder
assign instrD = (rst) ? 32'b0 : reg_instrF;
assign PCD = (rst) ? 32'b0 : reg_PCF;

endmodule

