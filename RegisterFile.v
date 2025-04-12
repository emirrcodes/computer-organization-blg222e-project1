module RegisterFile (
    input clk,
    input rst,
    input [2:0] FunSel,
    input [3:0] RegSel,
    input [3:0] ScrSel,
    input [2:0] OutASel,
    input [2:0] OutBSel,
    input [7:0] I,
    output reg [31:0] OutA,
    output reg [31:0] OutB
);

// 8 tane 32-bit register
reg [31:0] R [0:7]; // R[0]=R1, R[1]=R2, ..., R[7]=S4

integer i;

always @(posedge clk) begin
    if (rst) begin
        for (i = 0; i < 8; i = i + 1)
            R[i] <= 32'b0;
    end
    else begin
        for (i = 0; i < 4; i = i + 1) begin // R1-R4
            if (RegSel[i]) begin
                R[i] <= apply_function(R[i], FunSel, I);
            end
        end
        for (i = 0; i < 4; i = i + 1) begin // S1-S4
            if (ScrSel[i]) begin
                R[i+4] <= apply_function(R[i+4], FunSel, I);
            end
        end
    end
end

// Çıkış register seçimi
always @(*) begin
    OutA = R[OutASel];
    OutB = R[OutBSel];
end

// Fonksiyon modülü
function [31:0] apply_function;
    input [31:0] current;
    input [2:0] fs;
    input [7:0] data;

    begin
        case (fs)
            3'b000: apply_function = current - 1;
            3'b001: apply_function = current + 1;
            3'b010: apply_function = {24'b0, data}; // Load
            3'b011: apply_function = 32'b0;         // Clear
            3'b100: apply_function = {24'b0, data}; // Upper Clear
            3'b101: apply_function = {16'b0, data, 8'b0}; // Clear upper 16 bits, load lower 16
            3'b110: apply_function = {current[23:0], data}; // Left Shift
            3'b111: apply_function = {{16{data[7]}}, data, 8'b0}; // Sign Extend
            default: apply_function = current;
        endcase
    end
endfunction

endmodule
