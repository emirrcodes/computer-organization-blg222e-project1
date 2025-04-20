`timescale 1ns / 1ps

module Register16bit(
    input Clock,
    input rst,
    input E,
    input [1:0] FunSel,
    input [15:0] I,
    output reg [15:0] Q
);

always @(posedge Clock) begin
    if (rst)
        Q <= 16'b0;
    else if (E) begin
        case (FunSel)
            2'b00: Q <= Q - 1;
            2'b01: Q <= Q + 1;
            2'b10: Q <= I;
            2'b11: Q <= 16'b0;
        endcase
    end
end

endmodule