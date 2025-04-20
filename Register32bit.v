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
            3'b000: Q <= Q - 1;                           
            3'b001: Q <= Q + 1;                            
            3'b010: Q <= {16'b0, I};                       
            3'b011: Q <= 32'b0;                            
            3'b100: Q <= {24'b0, I[7:0]};                  
            3'b101: Q <= {16'b0, I};                       
            3'b110: Q <= {Q[23:0], I[7:0]};                
            3'b111: Q <= {{16{I[15]}}, I};                 
            default: Q <= Q;
        endcase
    end
end

endmodule