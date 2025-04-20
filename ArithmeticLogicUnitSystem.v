`timescale 1ns / 1ps

module ArithmeticLogicUnitSystem(
    input Clock,
    input [2:0] RF_OutASel, RF_OutBSel, RF_FunSel,
    input [3:0] RF_RegSel, RF_ScrSel,
    input [4:0] ALU_FunSel,
    input ALU_WF,
    input [1:0] ARF_OutCSel, ARF_OutDSel, ARF_FunSel,
    input [2:0] ARF_RegSel,
    input [1:0] MuxASel, MuxBSel, MuxCSel,
    input MuxDSel,
    input DR_E,
    input [1:0] DR_FunSel,
    input IR_LH, IR_Write,
    input Mem_WR, Mem_CS,
    output [31:0] OutA, OutB, ALUOut, MuxAOut, MuxBOut, MuxDOut, DROut,
    output [3:0] FlagsOut,
    output [7:0] MuxCOut, MemOut,
    output [15:0] OutC, Address, IROut
);

    wire [31:0] valA, valB, aluOutput, drOutput;
    wire [15:0] arfOutC, arfOutD, irOutput;
    wire [3:0] statusFlags;
    wire [7:0] muxCout;

    assign MuxDOut = MuxDSel ? {16'd0, arfOutC} : valA;

    ArithmeticLogicUnit ALU (
        .A(MuxDOut), .B(valB), .FunSel(ALU_FunSel), .WF(ALU_WF),
        .Clock(Clock), .ALUOut(aluOutput), .FlagsOut(statusFlags)
    );

    assign ALUOut = aluOutput;
    assign FlagsOut = statusFlags;

    RegisterFile RF (
        .I(aluOutput), .OutASel(RF_OutASel), .OutBSel(RF_OutBSel),
        .FunSel(RF_FunSel), .RegSel(RF_RegSel), .ScrSel(RF_ScrSel),
        .Clock(Clock), .OutA(valA), .OutB(valB)
    );

    assign OutA = valA;
    assign OutB = valB;

    AddressRegisterFile ARF (
        .I(aluOutput), .OutCSel(ARF_OutCSel), .OutDSel(ARF_OutDSel),
        .FunSel(ARF_FunSel), .RegSel(ARF_RegSel), .Clock(Clock),
        .OutC(arfOutC), .OutD(arfOutD)
    );

    assign OutC = arfOutC;
    assign Address = arfOutD;

    Memory MEM (
        .Address(arfOutD), .Data(muxCout), .WR(Mem_WR), .CS(Mem_CS),
        .Clock(Clock), .MemOut(MemOut)
    );

    Mux4to1_8 MuxC (
        .in0(aluOutput[7:0]), .in1(aluOutput[15:8]),
        .in2(aluOutput[23:16]), .in3(aluOutput[31:24]),
        .sel(MuxCSel), .out(muxCout)
    );

    assign MuxCOut = muxCout;

    DataRegister DR (
        .I(muxCout), .E(DR_E), .FunSel(DR_FunSel),
        .Clock(Clock), .DROut(drOutput)
    );

    assign DROut = drOutput;

    InstructionRegister IR (
        .I(MemOut), .LH(IR_LH), .Write(IR_Write),
        .Clock(Clock), .IROut(irOutput)
    );

    assign IROut = irOutput;

    Mux4to1_32 MuxA (
        .in0(aluOutput), .in1({16'd0, arfOutC}),
        .in2(drOutput), .in3({24'd0, irOutput[7:0]}),
        .sel(MuxASel), .out(MuxAOut)
    );

    Mux4to1_32 MuxB (
        .in0(aluOutput), .in1({16'd0, arfOutC}),
        .in2(drOutput), .in3({24'd0, irOutput[7:0]}),
        .sel(MuxBSel), .out(MuxBOut)
    );

endmodule

module Mux4to1_32 (
    input [31:0] in0, in1, in2, in3,
    input [1:0] sel,
    output reg [31:0] out
);
    always @(*) begin
        case (sel)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            2'b11: out = in3;
            default: out = 32'b0;
        endcase
    end
endmodule

module Mux4to1_8 (
    input [7:0] in0, in1, in2, in3,
    input [1:0] sel,
    output reg [7:0] out
);
    always @(*) begin
        case (sel)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            2'b11: out = in3;
            default: out = 8'b0;
        endcase
    end
endmodule