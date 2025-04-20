`timescale 1ns / 1ps
module Register32bit(
    input Clock,
    input rst,
    input E,
    input [2:0] FunSel,
    input [31:0] I,
    output reg [31:0] Q
);

always @(posedge Clock) begin
    if (rst)
        Q <= 32'b0;
    else if (E) begin
        case (FunSel)
            3'b000: Q <= Q - 1;                            // Decrement
            3'b001: Q <= Q + 1;                            // Increment
            3'b010: Q <= {16'b0, I};                       // Load 16-bit input (zero-extend)
            3'b011: Q <= 32'b0;                            // Clear
            3'b100: Q <= {24'b0, I[7:0]};                  // Upper 24 bit clear, lower 8 bit load
            3'b101: Q <= {16'b0, I};                       // Upper 16 bit clear, lower 16 bit load
            3'b110: Q <= {Q[23:0], I[7:0]};                // 8-bit left shift + load I[7:0]
            3'b111: Q <= {{16{I[15]}}, I};                 // Sign extend + load
            default: Q <= Q;
        endcase
    end
end

endmodule