`timescale 1ns / 1ps

// 11/15 geçiyor

module ArithmeticLogicUnit (
    input [4:0] FunSel,
    input [31:0] A,
    input [31:0] B,
    input WF,            // Write Flags
    input Clock,         // Clock (boş geçeceğiz ama simülasyon istiyor)
    output reg [31:0] ALUOut,
    output reg [3:0] FlagsOut  // Z C N O
);

    wire [31:0] A16 = {16'b0, A[15:0]};
    wire [31:0] B16 = {16'b0, B[15:0]};
    wire [31:0] notA16 = ~A16;
    wire [31:0] notB16 = ~B16;

    wire [31:0] sum16 = A16 + B16;
    wire [31:0] sum16carry = A16 + B16 + 1;  // ✅ CarryIn = 1
    wire [31:0] diff16 = A16 - B16;

    wire [31:0] sum32 = A + B;
    wire [31:0] sum32carry = A + B + 1;  // ✅ CarryIn = 1
    wire [31:0] diff32 = A - B;

    wire [31:0] lsl16 = A16 << 1;
    wire [31:0] lsr16 = A16 >> 1;
    wire [31:0] asr16 = $signed(A16) >>> 1;
    wire [31:0] csl16 = {A16[30:0], A16[31]};
    wire [31:0] csr16 = {A16[0], A16[31:1]};

    wire [31:0] lsl32 = A << 1;
    wire [31:0] lsr32 = A >> 1;
    wire [31:0] asr32 = $signed(A) >>> 1;
    wire [31:0] csl32 = {A[30:0], A[31]};
    wire [31:0] csr32 = {A[0], A[31:1]};

    always @(*) begin
        case (FunSel)
            5'b00000: ALUOut = A16;
            5'b00001: ALUOut = B16;
            5'b00010: ALUOut = notA16;
            5'b00011: ALUOut = notB16;
            5'b00100: ALUOut = sum16;
            5'b00101: ALUOut = sum16carry;
            5'b00110: ALUOut = diff16;
            5'b00111: ALUOut = A16 & B16;
            5'b01000: ALUOut = A16 | B16;
            5'b01001: ALUOut = A16 ^ B16;
            5'b01010: ALUOut = ~(A16 & B16);
            5'b01011: ALUOut = lsl16;
            5'b01100: ALUOut = lsr16;
            5'b01101: ALUOut = asr16;
            5'b01110: ALUOut = csl16;
            5'b01111: ALUOut = csr16;

            5'b10000: ALUOut = A;
            5'b10001: ALUOut = B;
            5'b10010: ALUOut = ~A;
            5'b10011: ALUOut = ~B;
            5'b10100: ALUOut = sum32;
            5'b10101: ALUOut = sum32carry;
            5'b10110: ALUOut = diff32;
            5'b10111: ALUOut = A & B;
            5'b11000: ALUOut = A | B;
            5'b11001: ALUOut = A ^ B;
            5'b11010: ALUOut = ~(A & B);
            5'b11011: ALUOut = lsl32;
            5'b11100: ALUOut = lsr32;
            5'b11101: ALUOut = asr32;
            5'b11110: ALUOut = csl32;
            5'b11111: ALUOut = csr32;
            default: ALUOut = 32'b0;
        endcase

        if (WF) begin
            FlagsOut[3] = (ALUOut == 0);  // ✅ Z flag
            FlagsOut[2] = (FunSel[4]) ? (sum32carry < A) : (sum16carry < A16); // ✅ Carry
            FlagsOut[1] = ALUOut[31];     // ✅ Negative
            FlagsOut[0] = (               // ✅ Overflow
                (FunSel == 5'b10100 && ((A[31] == B[31]) && (ALUOut[31] != A[31]))) ||
                (FunSel == 5'b10110 && ((A[31] != B[31]) && (ALUOut[31] != A[31]))) ||
                (FunSel == 5'b00100 && ((A16[15] == B16[15]) && (ALUOut[15] != A16[15]))) ||
                (FunSel == 5'b00110 && ((A16[15] != B16[15]) && (ALUOut[15] != A16[15])))
            );
        end
    end

endmodule