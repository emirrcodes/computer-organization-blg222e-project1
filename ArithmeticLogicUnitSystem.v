module ArithmeticLogicUnitSystem (
    input clk,
    input rst,
    input [1:0] MuxASel,
    input [1:0] MuxBSel,
    input [1:0] MuxCSel,
    input [1:0] MuxDSel,
    input [4:0] FunSel,
    input WF,
    input [31:0] ALUReg,
    input [31:0] DR,
    input [15:0] IR,
    input [15:0] OutC,
    output [31:0] ALUOut,
    output [3:0] Flags,
    output [7:0] MuxCOut,
    output [31:0] MuxDOut
);

wire [31:0] A, B;

assign A = (MuxASel == 2'b00) ? ALUReg :
           (MuxASel == 2'b01) ? {16'b0, OutC} :
           (MuxASel == 2'b10) ? DR :
           {24'b0, IR[7:0]};

assign B = (MuxBSel == 2'b00) ? ALUReg :
           (MuxBSel == 2'b01) ? {16'b0, OutC} :
           (MuxBSel == 2'b10) ? DR :
           {24'b0, IR[7:0]};

ArithmeticLogicUnit alu_inst (
    .A(A),
    .B(B),
    .FunSel(FunSel),
    .WF(WF),
    .ALUOut(ALUOut),
    .Flags(Flags)
);

assign MuxCOut = (MuxCSel == 2'b00) ? ALUOut[7:0] :
                 (MuxCSel == 2'b01) ? ALUOut[15:8] :
                 (MuxCSel == 2'b10) ? ALUOut[23:16] :
                 ALUOut[31:24];

assign MuxDOut = (MuxDSel == 1'b0) ? DR : {16'b0, OutC};

endmodule
