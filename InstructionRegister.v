module InstructionRegister(
    input clk,
    input rst,
    input Write,
    input LH, // Load High (1) or Low (0)
    input [7:0] I,
    output reg [15:0] IROut
);

always @(posedge clk) begin
    if (rst)
        IROut <= 16'b0;
    else if (Write) begin
        if (LH)
            IROut[15:8] <= I;     // Load MSB
        else
            IROut[7:0]  <= I;     // Load LSB
    end
end

endmodule