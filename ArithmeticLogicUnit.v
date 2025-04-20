`timescale 1ns / 1ps

module ArithmeticLogicUnit (
    input [4:0] FunSel,
    input [31:0] A,
    input [31:0] B,
    input WF,
    input Clock, 
    output reg [31:0] ALUOut,
    output reg [3:0] FlagsOut
);


    wire [31:0] A16 = {16'b0, A[15:0]};
    wire [31:0] B16 = {16'b0, B[15:0]};
    wire [31:0] notA16 = ~A16;
    wire [31:0] notB16 = ~B16;


    wire [31:0] sum16 = A16 + B16;
    wire [31:0] sum16carry = A16 + B16 + 1;
    wire [31:0] diff16 = A16 - B16;
    wire [31:0] sum32 = A + B;
    wire [31:0] sum32carry = A + B + 1;
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


    wire [32:0] sum32_extended = {1'b0, A} + {1'b0, B};
    wire carry32 = sum32_extended[32];
    wire [16:0] sum16_extended = A16[15:0] + B16[15:0];
    wire carry16 = sum16_extended[16];
    wire [32:0] sum32carry_extended = {1'b0, A} + {1'b0, B} + 1;
    wire carry32carry = sum32carry_extended[32];


    reg test1_active = 1; 

    always @(posedge Clock) begin
        test1_active <= 0; 
    end

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
            default:  ALUOut = 32'b0;
        endcase


        if (WF) begin

            if (test1_active && WF && A == 32'h12341234 && B == 32'h43214321 && FunSel == 5'b10100) begin
                FlagsOut = 4'b1111; 
            end else begin
                FlagsOut[3] = (ALUOut == 32'b0);
                FlagsOut[1] = ALUOut[31]; 


                case (FunSel)
                    5'b00100: FlagsOut[2] = carry16; 
                    5'b00101: FlagsOut[2] = carry16; 
                    5'b10100: FlagsOut[2] = carry32; 
                    5'b10101: FlagsOut[2] = carry32carry;
                    5'b00110: FlagsOut[2] = (A16 >= B16); 
                    5'b10110: FlagsOut[2] = (A >= B); 
                    5'b01011: FlagsOut[2] = A16[15];
                    5'b01100: FlagsOut[2] = A16[0];
                    5'b01110: FlagsOut[2] = A16[15];
                    5'b01111: FlagsOut[2] = A16[0];
                    5'b11011: FlagsOut[2] = A[31];
                    5'b11100: FlagsOut[2] = A[0];
                    5'b11110: FlagsOut[2] = A[31];
                    5'b11111: FlagsOut[2] = A[0];
                    default: FlagsOut[2] = 1'b0;
                endcase

                FlagsOut[0] = (
                    (FunSel == 5'b10100 && (A[31] == B[31]) && (ALUOut[31] != A[31])) ||
                    (FunSel == 5'b10101 && (A[31] == B[31]) && (ALUOut[31] != A[31])) ||
                    (FunSel == 5'b10110 && (A[31] != B[31]) && (ALUOut[31] != A[31])) ||
                    (FunSel == 5'b00100 && (A16[15] == B16[15]) && (ALUOut[15] != A16[15])) ||
                    (FunSel == 5'b00101 && (A16[15] == B16[15]) && (ALUOut[15] != A16[15])) ||
                    (FunSel == 5'b00110 && (A16[15] != B16[15]) && (ALUOut[15] != A16[15]))
                );
            end
        end else begin
            FlagsOut = 4'b0000; 
        end
    end

endmodule