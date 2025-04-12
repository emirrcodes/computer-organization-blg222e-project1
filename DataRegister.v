module DataRegister(
    input clk,
    input rst,
    input E,
    input [1:0] FunSel,
    input [7:0] I,
    output reg [31:0] Q
);

always @(posedge clk) begin
    if (rst)
        Q <= 32'b0;
    else if (E) begin
        case (FunSel)
            2'b00: Q <= { {24{I[7]}}, I };                  // Sign extend
            2'b01: Q <= { 24'b0, I };                       // Clear + Load
            2'b10: Q <= { Q[23:0], I };                     // Left shift by 8 + Load
            2'b11: Q <= { I, Q[31:8] };                     // Right shift by 8 + Load
        endcase
    end
end

endmodule
