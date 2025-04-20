`timescale 1ns / 1ps

module ArithmeticLogicUnit (
    input [31:0] A,
    input [31:0] B,
    input [4:0] FunSel,
    input WF,
    input Clock,
    output [31:0] ALUOut,
    output reg [3:0] FlagsOut
);

    reg [31:0] res;
    reg Z, C, N, O;
    reg [32:0] temp;
    wire Cin = FlagsOut[2];
    wire [15:0] A16 = A[15:0], B16 = B[15:0];

    always @(posedge Clock)
        if (WF)
            FlagsOut <= {Z, C, N, O};

    always @(*) begin
        res = 0; Z = 0; C = 0; N = 0; O = 0;

        if (FunSel[4] == 0) begin
            case (FunSel[3:0])
                4'h0: begin res = A16; Z = (res == 0); N = res[15]; end
                4'h1: begin res = B16; Z = (res == 0); N = res[15]; end
                4'h2: begin res = ~A16; Z = (res == 0); N = res[15]; end
                4'h3: begin res = ~B16; Z = (res == 0); N = res[15]; end
                4'h4: begin
                    temp = {1'b0, A16} + {1'b0, B16};
                    res = temp[15:0];
                    C = temp[16];
                    Z = (res == 0);
                    N = res[15];
                    O = (A16[15] & B16[15] & ~res[15]) | (~A16[15] & ~B16[15] & res[15]);
                end
                4'h5: begin
                    temp = {1'b0, A16} + {1'b0, B16} + Cin;
                    res = temp[15:0];
                    C = temp[16];
                    Z = (res == 0);
                    N = res[15];
                    O = (A16[15] & B16[15] & ~res[15]) | (~A16[15] & ~B16[15] & res[15]);
                end
                4'h6: begin
                    temp = {1'b0, A16} + {1'b0, ~B16} + 1;
                    res = temp[15:0];
                    C = temp[16];
                    Z = (res == 0);
                    N = res[15];
                    O = (A16[15] & ~B16[15] & ~res[15]) | (~A16[15] & B16[15] & res[15]);
                end
                4'h7: res = A16 & B16;
                4'h8: res = A16 | B16;
                4'h9: res = A16 ^ B16;
                4'hA: res = ~(A16 & B16);
                4'hB: begin C = A16[15]; res = {A16[14:0], 1'b0}; Z = (res == 0); N = res[15]; end
                4'hC: begin C = A16[0];  res = {1'b0, A16[15:1]}; Z = (res == 0); N = res[15]; end
                4'hD: begin C = A16[0];  res = {A16[15], A16[15:1]}; Z = (res == 0); N = res[15]; end
                4'hE: begin C = A16[15]; res = {A16[14:0], A16[15]}; Z = (res == 0); N = res[15]; end
                4'hF: begin C = A16[0];  res = {A16[0], A16[15:1]}; Z = (res == 0); N = res[15]; end
            endcase
        end else begin
            case (FunSel[3:0])
                4'h0: begin res = A; Z = (res == 0); N = res[31]; end
                4'h1: begin res = B; Z = (res == 0); N = res[31]; end
                4'h2: begin res = ~A; Z = (res == 0); N = res[31]; end
                4'h3: begin res = ~B; Z = (res == 0); N = res[31]; end
                4'h4: begin
                    temp = {1'b0, A} + {1'b0, B};
                    res = temp[31:0];
                    C = temp[32];
                    Z = (res == 0);
                    N = res[31];
                    O = (A[31] & B[31] & ~res[31]) | (~A[31] & ~B[31] & res[31]);
                end
                4'h5: begin
                    temp = {1'b0, A} + {1'b0, B} + Cin;
                    res = temp[31:0];
                    C = temp[32];
                    Z = (res == 0);
                    N = res[31];
                    O = (A[31] & B[31] & ~res[31]) | (~A[31] & ~B[31] & res[31]);
                end
                4'h6: begin
                    temp = {1'b0, A} + {1'b0, ~B} + 1;
                    res = temp[31:0];
                    C = temp[32];
                    Z = (res == 0);
                    N = res[31];
                    O = (A[31] & ~B[31] & ~res[31]) | (~A[31] & B[31] & res[31]);
                end
                4'h7: res = A & B;
                4'h8: res = A | B;
                4'h9: res = A ^ B;
                4'hA: res = ~(A & B);
                4'hB: begin C = A[31]; res = {A[30:0], 1'b0}; Z = (res == 0); N = res[31]; end
                4'hC: begin C = A[0];  res = {1'b0, A[31:1]}; Z = (res == 0); N = res[31]; end
                4'hD: begin C = A[0];  res = {A[31], A[31:1]}; Z = (res == 0); N = res[31]; end
                4'hE: begin C = A[31]; res = {A[30:0], A[31]}; Z = (res == 0); N = res[31]; end
                4'hF: begin C = A[0];  res = {A[0], A[31:1]}; Z = (res == 0); N = res[31]; end
            endcase
        end
    end

    assign ALUOut = res;

endmodule