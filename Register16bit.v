module Register16bit(
    input Clock,                 // <- İsim uyuşmalı
    input E,
    input [1:0] FunSel,
    input [15:0] I,
    output reg [15:0] Q
);

always @(posedge Clock) begin
    if (E) begin
        case (FunSel)
            2'b00: Q <= Q - 1;        // Decrement
            2'b01: Q <= Q + 1;        // Increment
            2'b10: Q <= I;            // Load
            2'b11: Q <= 16'b0;        // Clear
            default: Q <= Q;          // Retain (opsiyonel)
        endcase
    end
end

endmodule