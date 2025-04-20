`timescale 1ns / 1ps

module RegisterFile(
    input Clock,
    input [2:0] OutASel, OutBSel,
    input [3:0] RegSel, ScrSel,
    input [2:0] FunSel,
    input [31:0] I, 
    output [31:0] OutA, OutB
);


    wire [31:0] R1_Q, R2_Q, R3_Q, R4_Q;
    reg R1_E, R2_E, R3_E, R4_E;


    wire [31:0] S1_Q, S2_Q, S3_Q, S4_Q;
    reg S1_E, S2_E, S3_E, S4_E;


    Register32bit R1(.Clock(Clock), .rst(1'b0), .E(R1_E), .FunSel(FunSel), .I(I), .Q(R1_Q));
    Register32bit R2(.Clock(Clock), .rst(1'b0), .E(R2_E), .FunSel(FunSel), .I(I), .Q(R2_Q));
    Register32bit R3(.Clock(Clock), .rst(1'b0), .E(R3_E), .FunSel(FunSel), .I(I), .Q(R3_Q));
    Register32bit R4(.Clock(Clock), .rst(1'b0), .E(R4_E), .FunSel(FunSel), .I(I), .Q(R4_Q));

    Register32bit S1(.Clock(Clock), .rst(1'b0), .E(S1_E), .FunSel(FunSel), .I(I), .Q(S1_Q));
    Register32bit S2(.Clock(Clock), .rst(1'b0), .E(S2_E), .FunSel(FunSel), .I(I), .Q(S2_Q));
    Register32bit S3(.Clock(Clock), .rst(1'b0), .E(S3_E), .FunSel(FunSel), .I(I), .Q(S3_Q));
    Register32bit S4(.Clock(Clock), .rst(1'b0), .E(S4_E), .FunSel(FunSel), .I(I), .Q(S4_Q));


    assign OutA = (OutASel == 3'b000) ? R1_Q :
                  (OutASel == 3'b001) ? R2_Q :
                  (OutASel == 3'b010) ? R3_Q :
                  (OutASel == 3'b011) ? R4_Q :
                  (OutASel == 3'b100) ? S1_Q :
                  (OutASel == 3'b101) ? S2_Q :
                  (OutASel == 3'b110) ? S3_Q : S4_Q;

    assign OutB = (OutBSel == 3'b000) ? R1_Q :
                  (OutBSel == 3'b001) ? R2_Q :
                  (OutBSel == 3'b010) ? R3_Q :
                  (OutBSel == 3'b011) ? R4_Q :
                  (OutBSel == 3'b100) ? S1_Q :
                  (OutBSel == 3'b101) ? S2_Q :
                  (OutBSel == 3'b110) ? S3_Q : S4_Q;


    always @(*) begin

        R1_E = (RegSel == 4'b1000 || RegSel == 4'b1010 || RegSel == 4'b1001 ||
                RegSel == 4'b1110 || RegSel == 4'b1101 || RegSel == 4'b1011 ||
                RegSel == 4'b1111);

        R2_E = (RegSel == 4'b0100 || RegSel == 4'b0110 || RegSel == 4'b0101 ||
                RegSel == 4'b1110 || RegSel == 4'b1101 || RegSel == 4'b0111 ||
                RegSel == 4'b1111);

        R3_E = (RegSel == 4'b0010 || RegSel == 4'b0110 || RegSel == 4'b0011 ||
                RegSel == 4'b1010 || RegSel == 4'b1110 || RegSel == 4'b1011 ||
                RegSel == 4'b1111);

        R4_E = (RegSel == 4'b0001 || RegSel == 4'b0101 || RegSel == 4'b0011 ||
                RegSel == 4'b1001 || RegSel == 4'b1101 || RegSel == 4'b0111 ||
                RegSel == 4'b1011 || RegSel == 4'b1111);


        S1_E = (ScrSel == 4'b1000 || ScrSel == 4'b1010 || ScrSel == 4'b1001 ||
                ScrSel == 4'b1110 || ScrSel == 4'b1101 || ScrSel == 4'b1011 ||
                ScrSel == 4'b1111);

        S2_E = (ScrSel == 4'b0100 || ScrSel == 4'b0110 || ScrSel == 4'b0101 ||
                ScrSel == 4'b1110 || ScrSel == 4'b1101 || ScrSel == 4'b0111 ||
                ScrSel == 4'b1111);

        S3_E = (ScrSel == 4'b0010 || ScrSel == 4'b0110 || ScrSel == 4'b0011 ||
                ScrSel == 4'b1010 || ScrSel == 4'b1110 || ScrSel == 4'b1011 ||
                ScrSel == 4'b1111);

        S4_E = (ScrSel == 4'b0001 || ScrSel == 4'b0101 || ScrSel == 4'b0011 ||
                ScrSel == 4'b1001 || ScrSel == 4'b1101 || ScrSel == 4'b0111 ||
                ScrSel == 4'b1011 || ScrSel == 4'b1111);
    end

endmodule