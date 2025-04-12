module ArithmeticLogicUnit (
    input [31:0] A,
    input [31:0] B,
    input [4:0] FunSel,
    input WF, // WriteFlag: 1 ise flag'ler güncellenir
    output reg [31:0] ALUOut,
    output reg [3:0] Flags // Z C N O (MSB: Z, LSB: O)
);

reg carry, overflow, negative, zero;

always @(*) begin
    carry = 0;
    overflow = 0;
    negative = 0;
    zero = 0;

    case (FunSel)
        5'b00000: ALUOut = {16'b0, A[15:0]};                         // A (16-bit)
        5'b00001: ALUOut = {16'b0, B[15:0]};                         // B (16-bit)
        5'b00010: ALUOut = {16'b0, ~A[15:0]};                        // NOT A (16-bit)
        5'b00011: ALUOut = {16'b0, ~B[15:0]};                        // NOT B (16-bit)
        5'b00100: begin                                              // A + B (16-bit)
            {carry, ALUOut} = {1'b0, A[15:0]} + B[15:0];
            overflow = (A[15] == B[15]) && (ALUOut[15] != A[15]);
        end
        5'b00101: begin                                              // A + B + carry (16-bit)
            {carry, ALUOut} = {1'b0, A[15:0]} + B[15:0] + carry;
            overflow = (A[15] == B[15]) && (ALUOut[15] != A[15]);
        end
        5'b00110: begin                                              // A - B (16-bit)
            {carry, ALUOut} = {1'b0, A[15:0]} - B[15:0];
            overflow = (A[15] != B[15]) && (ALUOut[15] != A[15]);
        end
        5'b00111: ALUOut = {16'b0, A[15:0] & B[15:0]};               // AND
        5'b01000: ALUOut = {16'b0, A[15:0] | B[15:0]};               // OR
        5'b01001: ALUOut = {16'b0, A[15:0] ^ B[15:0]};               // XOR
        5'b01010: ALUOut = {16'b0, ~(A[15:0] & B[15:0])};            // NAND
        5'b01011: begin                                              // LSL A
            ALUOut = A << 1;
            carry = A[31];
        end
        5'b01100: begin                                              // LSR A
            ALUOut = A >> 1;
            carry = A[0];
        end
        5'b01101: ALUOut = $signed(A) >>> 1;                         // ASR A
        5'b01110: ALUOut = {A[30:0], A[31]};                         // CSL A
        5'b01111: ALUOut = {A[0], A[31:1]};                          // CSR A
        5'b10000: ALUOut = A;                                        // A (32-bit)
        5'b10001: ALUOut = B;                                        // B (32-bit)
        5'b10010: ALUOut = ~A;                                       // NOT A (32-bit)
        5'b10011: ALUOut = ~B;                                       // NOT B (32-bit)
        5'b10100: begin                                              // A + B (32-bit)
            {carry, ALUOut} = A + B;
            overflow = (A[31] == B[31]) && (ALUOut[31] != A[31]);
        end
        5'b10101: begin                                              // A + B + carry (32-bit)
            {carry, ALUOut} = A + B + carry;
            overflow = (A[31] == B[31]) && (ALUOut[31] != A[31]);
        end
        5'b10110: begin                                              // A - B (32-bit)
            {carry, ALUOut} = A - B;
            overflow = (A[31] != B[31]) && (ALUOut[31] != A[31]);
        end
        5'b10111: ALUOut = A & B;
        5'b11000: ALUOut = A | B;
        5'b11001: ALUOut = A ^ B;
        5'b11010: ALUOut = ~(A & B);
        5'b11011: begin
            ALUOut = A << 1;
            carry = A[31];
        end
        5'b11100: begin
            ALUOut = A >> 1;
            carry = A[0];
        end
        5'b11101: ALUOut = $signed(A) >>> 1;
        5'b11110: ALUOut = {A[30:0], A[31]};
        5'b11111: ALUOut = {A[0], A[31:1]};
        default: ALUOut = 32'b0;
    endcase

    zero = (ALUOut == 0);
    negative = ALUOut[31];
    Flags = (WF) ? {zero, carry, negative, overflow} : Flags;
end

endmodule
