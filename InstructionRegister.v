`timescale 1ns / 1ps
module InstructionRegister(
    input Clock,
    input rst,
    input Write,           // ← değiştirdik
    input LH,              // ← isim sadeleştirildi (L_H → LH)
    input [7:0] I,
    output reg [15:0] IROut // ← Q → IROut
);

always @(posedge Clock) begin
    if (rst)
        IROut <= 16'b0;
    else if (Write) begin
        if (LH == 1'b0)
            IROut[7:0] <= I;
        else
            IROut[15:8] <= I;
    end
end

endmodule