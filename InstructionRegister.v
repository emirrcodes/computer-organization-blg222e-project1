module InstructionRegister(
    input clk,
    input rst,
    input E,
    input L_H,               // 0: LSB, 1: MSB
    input [7:0] I,           // 8-bit input
    output reg [15:0] Q      // 16-bit register output
);

always @(posedge clk) begin
    if (rst)
        Q <= 16'b0;
    else if (E) begin
        if (L_H == 1'b0)         // Load lower 8 bits
            Q[7:0] <= I;
        else                    // Load upper 8 bits
            Q[15:8] <= I;
    end
end

endmodule
