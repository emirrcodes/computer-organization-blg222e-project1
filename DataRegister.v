module DataRegister(
    input clk,
    input rst,
    input E,
    input [1:0] FunSel,
    input [7:0] I,
    output reg [31:0] DROut
);

always @(posedge clk) begin
    if (rst)
        DROut <= 32'b0;
    else if (E) begin
        case (FunSel)
            2'b00: DROut <= {{24{I[7]}}, I};                    // Sign extend
            2'b01: DROut <= {24'b0, I};                         // Zero extend
            2'b10: DROut <= {DROut[23:0], I};                   // Left shift 8 bit + load
            2'b11: DROut <= {I, DROut[31:8]};                   // Right shift 8 bit + load
            default: DROut <= DROut;
        endcase
    end
end

endmodule