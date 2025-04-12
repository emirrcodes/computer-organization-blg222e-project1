`timescale 1ns / 1ps


// 2/4 geçiyo testlerden
module RegisterFile (
    input Clock,
    input rst,
    input [2:0] FunSel,
    input [3:0] RegSel,
    input [3:0] ScrSel,
    input [2:0] OutASel,
    input [2:0] OutBSel,
    input [31:0] I,
    output [31:0] OutA,
    output [31:0] OutB
);

wire [31:0] OutR1, OutR2, OutR3, OutR4;
wire [31:0] OutS1, OutS2, OutS3, OutS4;

    // 8 adet Register mod�l�
    Register32bit R1 (.Clock(Clock), .rst(rst), .E(RegSel[0]), .FunSel(FunSel), .I(I), .Q(OutR1));
    Register32bit R2 (.Clock(Clock), .rst(rst), .E(RegSel[1]), .FunSel(FunSel), .I(I), .Q(OutR2));
    Register32bit R3 (.Clock(Clock), .rst(rst), .E(RegSel[2]), .FunSel(FunSel), .I(I), .Q(OutR3));
    Register32bit R4 (.Clock(Clock), .rst(rst), .E(RegSel[3]), .FunSel(FunSel), .I(I), .Q(OutR4));
    Register32bit S1 (.Clock(Clock), .rst(rst), .E(ScrSel[0]), .FunSel(FunSel), .I(I), .Q(OutS1));
    Register32bit S2 (.Clock(Clock), .rst(rst), .E(ScrSel[1]), .FunSel(FunSel), .I(I), .Q(OutS2));
    Register32bit S3 (.Clock(Clock), .rst(rst), .E(ScrSel[2]), .FunSel(FunSel), .I(I), .Q(OutS3));
    Register32bit S4 (.Clock(Clock), .rst(rst), .E(ScrSel[3]), .FunSel(FunSel), .I(I), .Q(OutS4));

    // �?k?? se�imleri
    reg [31:0] outA_temp, outB_temp;
    assign OutA = outA_temp;
    assign OutB = outB_temp;

    always @(*) begin
        case (OutASel)
            3'd0: outA_temp = OutR1;
            3'd1: outA_temp = OutR2;
            3'd2: outA_temp = OutR3;
            3'd3: outA_temp = OutR4;
            3'd4: outA_temp = OutS1;
            3'd5: outA_temp = OutS2;
            3'd6: outA_temp = OutS3;
            3'd7: outA_temp = OutS4;
        endcase

        case (OutBSel)
            3'd0: outB_temp = OutR1;
            3'd1: outB_temp = OutR2;
            3'd2: outB_temp = OutR3;
            3'd3: outB_temp = OutR4;
            3'd4: outB_temp = OutS1;
            3'd5: outB_temp = OutS2;
            3'd6: outB_temp = OutS3;
            3'd7: outB_temp = OutS4;
        endcase
    end

endmodule