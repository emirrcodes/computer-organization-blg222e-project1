module Register16bit(
    input clk,
    input rst,
    input E,
    input [1:0] FunSel,
    input [15:0] I,
    output reg [15:0] Q
);

always @(posedge clk) begin
    if (rst)
        Q <= 16'b0;
    else if (E) begin
        case (FunSel)
            2'b00: Q <= Q - 1;        // Decrement
            2'b01: Q <= Q + 1;        // Increment
            2'b10: Q <= I;            // Load input
            2'b11: Q <= 16'b0;        // Clear
            default: Q <= Q;          // Retain (optional)
        endcase
    end
end

endmodule